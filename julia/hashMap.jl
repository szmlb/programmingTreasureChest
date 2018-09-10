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
    data
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

function main()

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
