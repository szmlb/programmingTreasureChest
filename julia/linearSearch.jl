using Random

function linearSearch(search_list, search_num)

  num = 1
  while num <= length(search_list)
    if search_num == search_list[num]
      return num
     end
     num += 1
   end

   return false

end

function main()

  # list to be sorted
  rng = MersenneTwister(1234);
  list_size = 1e7
  #search_list = Vector(1:list_size) # The list is to be sorted for binary search
  search_list = shuffle(rng, Vector(1:list_size))

  # Search
  search_num = 1000
  index_found = @time linearSearch(search_list, search_num)

  print("Search for : ")
  println(search_num)

  if index_found == false
    println("Nothing found.")
    return
  end

  print("Found index: ")
  println(index_found)

  print("Found value is ... ")
  println(Int(search_list[index_found]))

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
