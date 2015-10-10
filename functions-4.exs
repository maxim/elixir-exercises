prefix = fn prefix -> (fn string -> "#{prefix} #{string}" end) end

mrs = prefix.("Mrs")
IO.puts mrs.("Smith")
IO.puts prefix.("Elixir").("Rocks")
