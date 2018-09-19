using Printf

function simpleSearch(text, pattern)

    for i in 1:length(text)-length(pattern)+1
        # わかりやすいように，いま何を比較しているか表示
        @printf "    本文:%s \nパターン:" text
        for j = 1:i-1
            @printf " "
        end
        @printf "%s \n" pattern

        # パターンの先頭から比較を始める
        for j in 1:length(pattern)

            if pattern[i+j-1] != text[j]
                break              # 一致しなかった
            end

        end
        if j == length(pattern)        # 一致した
            return text;
        end

        # 一致しなかったので，テキストを1つずらして再度挑戦
    end

    return false
end

function main()

    original_text = "Team Swift"
    original_pattern = "if"

    result = simpleSearch(original_text, original_pattern)
    if result == false
        @printf "見つかりませんでした\n"
    else
        @printf "見つかりました\n"
    end

    return true

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
