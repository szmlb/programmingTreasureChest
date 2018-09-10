using Random
using Printf

mutable struct wordSet
    english::String
    japanese::String
    wordSet() = new()
end

mutable struct hashTable
    data
    size::Int
    hashData() = new()
end

function main()

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
