defmodule Word do
  def anagram?(word1, word2) do
    Enum.reverse(word2) === word1
  end
end

IO.inspect Word.anagram?('bat', 'tab')
