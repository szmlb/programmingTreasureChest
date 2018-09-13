using Random
using Printf

# 英単語&和訳を保持する構造体
mutable struct wordSet
    english::String
    japanese::String
    wordSet() = new()
end

# ハッシュ表
mutable struct hashTable
    data # 要検討. リストにする？
    size::Int
    hashTable() = new()
end

# 文字列のASCIIコードに重率を掛けてハッシュ値を生成
function makeHash2(str,  hashmax)
  len = length(str)
  n = weight = hash = 0
  while n < len
    # 重率が256^7まで到達したら, 一巡して再び元に戻す
    if weight > 7
      weight = 0
    end
    hash = hash + parse(Int, str[n+1])^(16*weight)

    n = n + 1
    weight = weight + 1
  end

  return hash % hashmax

end

# firsthashの位置が埋まっていた場合に再ハッシュを行うための関数
function reHash(hashtable, firsthash)

  # firstvalからk^2だけ後ろにある空き位置を探す. "k>ハッシュ表サイズの半分"となったら,  それ以降の探索はムダ.

  for k in 1:Int(hashtable.size/2)
    hashval = (firsthash + k^2) % hashtable.size
    if hashtable.data[hashval] == nothing
      return hashval
    end
  end

  # 空き位置が見つからなかったら-1を返す
  return -1

end

# newdataをhashtableに追加する
function addDataToMap(hashtable, newdata)

  # 英単語を元にハッシュ値を生成
  hashval = makeHash2(newdata.english, hashtable.size)

  # もしもhashの位置がすでに埋まっていたら, 再ハッシュを行う
  if hashtable.data[hashval] != nothing
    hashval = reHash(hashtable, hashval)

    # 再ハッシュ結果が-1であれば, 空き位置が見つからなかった (マップが満杯)
    if hashval == -1
      @printf "%sをマップに挿入しようと試みましたが, 空き位置がありませんでした.\n" newdata.english

      return
    end
  end

  # hashvalの位置にnewdataへのポインタを格納
  hashtable.data[hashval] = newdata

end

# 英単語keyに対応する和訳をhashtableから探し出して返す
function getDataFromMap(hashtable, key)

    # 探索を開始するハッシュ値を求める
    hashval = MakeHash2(key, hashtable.size)

    # その位置から順番に，keyと同じ値をもつデータが現れるまで探索を行う
    for k in 0:Int(hashtable.size/2)
        word = hashtable.data[(hashval + k * k) % hashtable.size]
        if word != nothing
            if cmp(key, word->english) == 0
                return word.japanese
            end
        end
    end

    # ハッシュ表サイズの半分に相当する回数探し続けても
    #   見つからない場合は，該当するデータがハッシュ表のなかにないことを意味する
    return nothing
end

# 英単語keyに関するデータをhashtableから取り除く(データそのものは削除しない)
function deleteDataFromMap(hashtable, key)

    # 探索を開始するハッシュ値を求める
    hashval = MakeHash2(key, hashtable->size)

    # その位置から順番に，keyと同じ値をもつデータが現れるまで探索を行う
    for k in 0:Int(hashtable->size/2)
        word = hashtable->data[(hashval + k * k) % hashtable->size]
        if word != nothing
            if cmp(key, word.english) == 0
                hashtable->data[(hashval + k * k) % hashtable.size] = nothing
                # ハッシュテーブルから取り除いたデータを返す
                return word
            end
        end
    end

    # ハッシュ表サイズの半分に相当する回数探し続けても
    # 見つからない場合は，該当するデータがハッシュ表のなかに
    # ないことを意味する
    return nothing
end

# ハッシュテーブルを指定したサイズに初期化する
function initHashTable(hashtable, size)
    hashtable.data = Array{wordSet}(undef, size)
    hashtable.size = size

end

#=
# ハッシュテーブルのクリーンアップ
function cleanupHashTable(hashtable)
    free(hashtable.data)
    hashtable->size = 0
end
=#

# hashtable中の全データを表示する（単なる表示用）
function printAllData(hashtable)
    for n in 1:hashtable.size
        if hashtable.data[n] != nothing
            @printf "%d:\t%s\t%s\n" n hashtable.data[n].english hashtable.data[n].japanese
        end
    end
end

function main()

    hash_table = hashTable()
    word_found = wordSet()

    #words = Array{wordSet}(undef, 5)
    #words = Array{wordSet,1}(undef, 5)
    words = Vector{wordSet}(undef, 5)
    for i in 1:length(words)
      words[i] = wordSet()
    end

    words[1].english = "dolphin"
    words[1].japanese = "イルカ"

    words[2].english = "beluga"
    words[2].japanese = "シロイルカ"

    words[3].english = "grampus"
    words[3].japanese = "シャチ"

    words[4].english = "medusa"
    words[4].japanese = "海月"

    words[5].english = "otter"
    words[5].japanese = "カワウソ"

    # ハッシュテーブルの初期化
    initHashTable(hash_table, 503);

    # データを追加
    for n in 1:5
        addDataToMap(hash_table, words[n])
    end

    while n != 0

        @printf "どの操作を行いますか?（1:検索 2:削除 3:全表示 0:終了）\n>"
        buf = paprse(Int, readline())
        if buf == 1 # 検索
            @printf "検索する英単語を入力してください："
            key = readline()
            japanese = getDataFromMap(hash_table, key)
            if japanese != nothing
                @printf "%sの和訳は%sです。\n" key japanese
            else
                @printf "%sがマップのなかに見つかりませんでした。\n" key
            end
        elseif buf == 2 # 削除
            @printf "削除する英単語を入力してください："
            key = readline()
            wordfound = deleteDataFromMap(hash_table, key)
            if wordfound != nothing
                @printf "%sをマップから削除しました。\n" key
            else
                @printf "%sがマップのなかに見つかりませんでした。\n" key
            end
        elseif buf == 3 # 全表示
            printAllData(hash_table)
        end
    end
    #cleanupHashTable(hash_table) # クリーンアップ

    return 0

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
