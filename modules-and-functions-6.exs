defmodule Chop do
  def guess(actual, min..max) when (actual < min) or (actual > max),
    do: 'Impossible guess!'

  def guess(actual, min..max) do
    attempt = div(max+min, 2)
    IO.puts "Is it #{attempt}"
    _guess(actual, min..max, attempt)
  end

  defp _guess(actual, _, attempt) when actual == attempt,
    do: attempt

  defp _guess(actual, min.._, attempt) when actual < attempt,
    do: guess(actual, min..(attempt-1))

  defp _guess(actual, _..max, attempt) when actual > attempt,
    do: guess(actual, (attempt+1)..max)
end

IO.puts(Chop.guess(273, 1..1000))
