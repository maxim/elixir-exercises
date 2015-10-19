defmodule Explain do
  defmacro explain(do: expression) do
    { _, string } = Macro.postwalk(expression, [], &_explain/2)
    IO.inspect Enum.join(string, ", then ")
  end

  defp _explain({ op, _, [ lhs, rhs ] } = expr, list) when is_tuple(lhs) and is_tuple(rhs) do
    string = case op do
      :+ -> "add the two results together"
      :- -> "subtract latter from the former"
      :* -> "multiply the two results"
      :/ -> "divide the former by the latter"
    end

    { expr, list ++ [string] }
  end

  defp _explain({ op, _, [ lhs, rhs ] } = expr, list) when is_tuple(lhs) do
    string = "#{_op_explain(op)} #{rhs}"
    { expr, list ++ [string] }
  end

  defp _explain({ op, _, [ lhs, rhs ] } = expr, list) when is_tuple(rhs) do
    string = "#{_op_explain(op)} #{lhs}"
    { expr, list ++ [string] }
  end

  defp _explain({ op, _, [ lhs, rhs ] } = expr, list) do
    string = case op do
      :+ -> "add #{lhs} and #{rhs}"
      :- -> "subtract #{rhs} from #{lhs}"
      :* -> "multiply #{lhs} by #{rhs}"
      :/ -> "divide #{lhs} by #{rhs}"
    end

    { expr, list ++ [string] }
  end

  defp _explain(value, list) do
    { value, list }
  end

  defp _op_explain(op) do
    case op do
      :+ -> "add"
      :- -> "subtract"
      :* -> "multiply by"
      :/ -> "divide by"
    end
  end
end

defmodule Test do
  import Explain

  explain do: 2 + 3 * 4 # => multiply 3 by 4, then add 2
  explain do: 2 * 3 + 4 # => multiply 2 by 3, then add 4
  explain do: 2 * 3 + 4 * 5 # => multiply 2 by 3, then multiply 4 by 5, then add the two results together
  explain do: 2 * 3 / 6 + (7 + 7) - 1 - 3 # => multiply 2 by 3, then divide by 6, then add 7 and 7, then add the two results together, then subtract 1, then subtract 3
  explain do: 2 * 4 / (5 * 6) # => multiply 2 by 4, then multiply 5 by 6, then divide the former by the latter
end
