defmodule MyEnum do
  def all?(_, func \\ fn x -> !!x end)
  def all?([], _), do: true
  def all?([ head | tail ], func), do: !!func.(head) && all?(tail)

  def each([], func), do: :ok
  def each([ head | tail ], func) do
    func.(head)
    each(tail, func)
    :ok
  end

  def filter([], func), do: []
  def filter([ head | tail ], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end

  def split(list, n), do: _split([], list, n)

  defp _split(list1, [], _), do: [list1, []]
  defp _split(list1, list2, 0), do: [list1, list2]
  defp _split(list1, [ l2h | l2t ], n),
    do: _split(list1 ++ [l2h], l2t, n - 1)


  def take(list, n), do: _take([], list, n)

  defp _take(result, _, 0), do: result
  defp _take(result, [], _), do: result
  defp _take(result, [ head | tail ], n),
    do: _take(result ++ [head], tail, n - 1)
end

IO.puts MyEnum.all?('abc') # => true
IO.puts MyEnum.all?(['a', nil, 'b']) # => false
IO.puts MyEnum.all?(['a', 'b', false]) # => false
IO.puts MyEnum.all?(['a', 'b', false], &(&1 == 'a')) # => false
IO.puts MyEnum.all?([2, 3, 4], &(&1 >= 2)) # => true

MyEnum.each([1,2,3], &IO.puts/1)
IO.inspect MyEnum.filter([1,2,3,4,5], &(&1 >= 3))
IO.inspect MyEnum.split([1,2,3,4,5], 3)
IO.inspect MyEnum.take([1,2,3,4,5], 2)
