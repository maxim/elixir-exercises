defmodule MyList do
  def flatten([]), do: []
  def flatten([ head | tail ]), do: flatten(head) ++ flatten(tail)
  def flatten(value), do: [value]
end

IO.inspect MyList.flatten([ 1, [ 2, 3, [4] ], 5, [[[6]]]])
IO.inspect MyList.flatten([ 1 ])
