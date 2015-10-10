defmodule MyString do
  def center(list) do
    lengths = Enum.map(list, &String.length/1)
    max_length = Enum.max(lengths)

    for { word, length } <- List.zip([list, lengths]) do
      String.rjust(word, length + div(max_length - length, 2))
    end |> Enum.join("\n")
  end
end

IO.puts(MyString.center(["cat", "zebra", "elephant"]))
