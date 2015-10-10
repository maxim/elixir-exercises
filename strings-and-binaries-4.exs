defmodule StringCalc do
  def calculate(chars) do
    [a, op, b] = _parse_tokens(chars, [[]])
    _calculate(List.to_integer(a), List.to_integer(b), op)
  end

  defp _calculate(a, b, op) when op === '+', do: a + b
  defp _calculate(a, b, op) when op === '-', do: a - b
  defp _calculate(a, b, op) when op === '*', do: a * b
  defp _calculate(a, b, op) when op === '/', do: a / b

  defp _parse_tokens([], tokens), do: tokens

  defp _parse_tokens([head | tail], [ lhs ]) when head in ?0..?9 do
    _parse_tokens(tail, [ lhs ++ [head] ])
  end

  defp _parse_tokens([head | tail], [ lhs, op, rhs ]) when head in ?0..?9 do
    _parse_tokens(tail, [ lhs, op, rhs ++ [head] ])
  end

  defp _parse_tokens([head | tail], tokens) when head === ?\s do
    _parse_tokens(tail, tokens)
  end

  defp _parse_tokens([head | tail], [ lhs ]) when head in '+-*/' do
    _parse_tokens(tail, [ lhs, [head], [] ])
  end
end

IO.inspect StringCalc.calculate('123 + 27')
