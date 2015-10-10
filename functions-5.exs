# original
result1 = Enum.map [1,2,3,4], fn x -> x + 2 end
IO.inspect result1

# &-syntax
result2 = Enum.map [1,2,3,4], &(&1 + 2)
IO.inspect result2

# original
Enum.each [1,2,3,4], fn x -> IO.inspect x end

# &-syntax
Enum.each [1,2,3,4], &IO.inspect/1
