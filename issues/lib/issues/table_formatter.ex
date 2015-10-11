defmodule Issues.TableFormatter do
  import Enum, only: [
    map: 2, into: 2, join: 2, each: 2, max: 1, zip: 2, at: 2, map_join: 3
  ]

  def print_table_for_columns(list_of_issues, list_of_columns) do
    rows =
      list_of_issues
      |> map(&extract_column_values(&1, list_of_columns))
      |> into([ list_of_columns ])

    col_widths = determine_col_widths(rows)

    rows
      |> map(&pad_row(&1, col_widths))
      |> List.insert_at(1, [generate_separator(col_widths)])
      |> map(&join(&1, " | "))
      |> each(&IO.puts/1)
  end

  def determine_col_widths(rows) do
    col_count = length(List.first(rows))

    for col_index <- (0..col_count - 1) do
      rows
        |> map(&find_length_at_index(&1, col_index))
        |> max
    end
  end

  def pad_row(row, col_widths) do
    for { text, col_width } <- row |> zip(col_widths),
      do: String.ljust(text, col_width)
  end

  def extract_column_values(hashdict, list_of_columns),
    do: hashdict
      |> HashDict.take(list_of_columns)
      |> HashDict.values
      |> map(&to_string(&1))

  def find_length_at_index(list, index),
    do: at(list, index) |> to_string |> String.length

  def generate_separator(col_widths),
    do: map_join(col_widths, "-+-", &String.duplicate("-", &1))
end
