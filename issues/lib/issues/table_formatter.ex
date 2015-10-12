defmodule Issues.TableFormatter do
  import Enum, only: [
    map: 2, into: 2, join: 2, each: 2, max: 1, zip: 2, at: 2, map_join: 3
  ]

  @doc """
  Takes a list of row data, where each row is a HashDict, and a list of headers.
  Prints a table to STDOUT of the data from each row identified by each header.
  That is, each header identifies a column, and those columns are extracted and
  printed from the rows. We calculate the width of each column to fit the
  longest element in that column.
  """
  def print_table_for_columns(dict_rows, headers) do
    rows = transform_into_filtered_rows(dict_rows, headers)
    col_widths = determine_col_widths(rows)

    rows
      |> map(&pad_row(&1, col_widths))
      |> List.insert_at(1, [generate_separator(col_widths)])
      |> map(&join(&1, " | "))
      |> map(&String.rstrip/1)
      |> each(&IO.puts/1)
  end


  @doc """
  Given a list of rows, where each row contains a keyed list of columns, return
  a list containing lists of the data in each row. The `headers` parameter
  contains the list of columns to extract.

  ## Example

    iex> list = [ [ c1: "1", c2: "2", c3: "3" ],
    ...>          [ c1: "4", c2: "5", c3: "6" ] ]
    [[c1: "1", c2: "2", c3: "3"], [c1: "4", c2: "5", c3: "6"]]
    iex> Issues.TableFormatter.transform_into_filtered_rows(list, [:c1, :c3])
    [["c1", "c3"], ["1", "3"], ["4", "6"]]
  """
  def transform_into_filtered_rows(dict_rows, headers),
    do: dict_rows
      |> map(fn dict ->
          extract_column_values(dict, headers) |> map(&to_string(&1))
         end)
      |> into([ headers |> map(&to_string(&1)) ])

  @doc """
  Given a HashDict and a list of keys (headers), return a list of values from
  the HashDict corresponding to the given keys, ordered the same as the keys.

  ## Examples
    iex> row = [{ :a, 'a' }, { :b, 'b' }, { :c, 'c' }]
    iex> Issues.TableFormatter.extract_column_values(row, [:c, :a])
    ['c', 'a']
  """
  def extract_column_values(hashdict_row, headers) do
    for col_name <- headers, do: hashdict_row[col_name]
  end

  @doc """
  Given a list containing sublists, where each sublist contains the data for a
  row, return a list containing the maximum width of each column.

  ## Example
    iex> data = [ [ "cat", "wombat", "elk" ], [ "mongoose", "ant", "gnu" ] ]
    iex> Issues.TableFormatter.determine_col_widths(data)
    [8, 6, 3]
  """
  def determine_col_widths(rows) do
    col_count = length(List.first(rows))

    for col_index <- (0..col_count - 1) do
      rows
        |> map(&find_length_at_index(&1, col_index))
        |> max
    end
  end

  @doc """
  Given a list of strings and a list of widths, return a list of strings each
  padded (on the right) with spaces up to the corresponding width.

  ## Example
    iex> Issues.TableFormatter.pad_row(["foo", "bar"], [ 10, 5 ])
    ["foo       ", "bar  "]
  """
  def pad_row(row, col_widths) do
    for { text, col_width } <- row |> zip(col_widths),
      do: String.ljust(text, col_width)
  end

  @doc """
  Given a list and an index, find a String.length of the element at the index.

  ## Example
    iex> Issues.TableFormatter.find_length_at_index(["foo", "baar"], 1)
    4
  """
  def find_length_at_index(list, index),
    do: at(list, index) |> to_string |> String.length

  @doc """
  Generate the line that goes below the column headings. It is a string of
  hyphens, with + signs where the vertical bar between the column goes.

  ## Example
    iex> Issues.TableFormatter.generate_separator([5, 6, 9])
    "------+--------+----------"
  """
  def generate_separator(col_widths),
    do: map_join(col_widths, "-+-", &String.duplicate("-", &1))
end
