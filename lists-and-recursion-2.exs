defmodule MyList do
  def max([]), do: nil
  def max([ a ]), do: a
  def max([ a, b ]) when a >= b, do: a
  def max([ _, b ]), do: b
  def max([ head | tail ]), do: max([head, max(tail)])
end

IO.inspect(MyList.max [1,3,2]) # => 3
IO.inspect(MyList.max [3])
IO.inspect(MyList.max [])
IO.inspect(MyList.max [432, 124, 4381, 23, 0, 12])
