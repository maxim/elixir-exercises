defmodule Ok do
  def ok!({ :ok, data }), do: data
  def ok!({ _, reason }), do: raise "Error: #{reason}"
end

Ok.ok! File.open("non-existent")
