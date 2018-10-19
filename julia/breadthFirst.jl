using Printf

# いままでに現れた局面を記録する配列。
# この配列は，キュー代わりにも使われる
mutable struct pattern
    hash::Int
    pattern_from::Int
    pattern() = new()
end

# 局面と対応する数字を作り出す関数
function make_hash(char pattern)

    hash = 0;
    for i in 1:8
      #hash |= ((unsigned long)(pattern[7 - i])) << (i * 4);
    end
    return hash
end

function main()

    history  = pattern()

    history_count = 0;    # 現在のパターンの個数
    queue_bottom          # キューの末尾位置を表す添え字

    return true

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
