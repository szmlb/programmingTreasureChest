function mergeSort(n, sort_list)

    if n <= 1
      return
    end
    m = n / 2

    # ブロックを前半と後半に分ける
    mergeSort(m,  sort_list)
    mergeSort(n - m, sort_list + m)

end

function main()

  # list to be sorted
  rng = MersenneTwister(1234);
  list_size = 100
  sort_list = shuffle(rng, Vector(1:list_size))

  print("List to be sorted:")
  println(sort_list)

  # Sort
  @time mergeSort(length(sort_list), sort_list)

  print("Sorted list:")
  println(sort_list)

end

if contains(@__FILE__, PROGRAM_FILE)
    main()
end
