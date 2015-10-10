defmodule MyList do
  def span(from, to) when from > to, do: raise "to must be >= from"
  def span(from, to) when from === to, do: [from]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
end

IO.inspect MyList.span(1, 40)

primes = for x <- MyList.span(2, 40),
  Enum.all?(
    MyList.span(2, Enum.max([2, x-1])),
    fn v -> rem(x, v) > 0 end
  ), do: x

IO.inspect primes
