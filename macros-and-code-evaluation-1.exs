defmodule My do
  defmacro myunless(condition, clauses) do
    do_clause = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)

    quote do
      if unquote(condition),
        do: unquote(else_clause),
        else: unquote(do_clause)
    end
  end
end

defmodule Test do
  require My

  My.myunless 1 == 1 do
    IO.puts "1 is not equal 1"
  else
    IO.puts "1 is equal 1"
  end

  My.myunless 1 == 2 do
    IO.puts "1 is not equal 2"
  else
    IO.puts "1 is equal 2"
  end

  # => 1 is equal 1
  # => 1 is not equal 2
end
