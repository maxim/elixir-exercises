defmodule MyString do
  @printable ?\s..?~

  def printable_ascii?(clist) do
    Enum.all?(clist, fn char -> Enum.member?(@printable, char) end)
  end
end

IO.inspect MyString.printable_ascii?('djfkslja')
IO.inspect MyString.printable_ascii?('y😎l😎')
