using Printf

function simpleSearch(text, pattern, original_text)

    while text != '\0'
        # わかりやすいように，いま何を比較しているか表示
        @printf "    本文:%s \nパターン:" original_text
        for i = 1:text-original_text
            @printf "　"
        end
        @printf "%s \n" pattern

        # パターンの先頭から比較を始める
        i = 0
        while pattern[i] != '\0'

            if pattern[i] != text[i]
                break;              # 一致しなかった
            end
            i = i + 1
        end
        if pattern[i] == '\0'        # 一致した
            return text;
        end

        # 一致しなかったので，テキストを1つずらして再度挑戦
        text = text + 1
    end

    return false
end

function main()

    original_text = "Team Swift"
    original_pattern = "if"

    result = simpleSearch(original_text, original_pattern, original_text)
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
