defmodule MyList do
  def span(from, to) when from > to, do: raise "to must be >= from"
  def span(from, to) when from === to, do: [from]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
end

IO.inspect MyList.span(1, 40)
