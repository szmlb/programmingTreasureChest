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
    hashData() = new()
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
function GetDataFromMap(hashtable, key)

    # 探索を開始するハッシュ値を求める
    hashval = MakeHash2(key, hashtable.size)

    # その位置から順番に，keyと同じ値をもつデータが現れるまで探索を行う
    for k in 0:Int(hashtable.size/2)
        word = hashtable.data[(hashval + k * k) % hashtable.size]
        if word != nothing
            if cmp(key, word->english == 0
                return word.japanese
            end
        end
    end

    # ハッシュ表サイズの半分に相当する回数探し続けても
    #   見つからない場合は，該当するデータがハッシュ表のなかにないことを意味する
    return nothing
end

function main()

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
