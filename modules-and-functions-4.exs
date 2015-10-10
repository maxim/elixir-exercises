defmodule SumUp do
  def to(0), do: 0
  def to(1), do: 1
  def to(n), do: n + to(n - 1)
end

IO.puts SumUp.to(3)
