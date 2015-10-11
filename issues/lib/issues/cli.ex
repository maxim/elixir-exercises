defmodule Issues.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that
  end up generating a table of the last _n_ issues in a github project.
  """

  @default_count 4

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally) the number
  of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse =
      OptionParser.parse argv,
        switches: [ help: :boolean ],
        aliases:  [ h:    :help    ]

    case parse do
      { [ help: true ], _, _ }
        -> :help

      { _, [ user, project, count ], _ }
        -> { user, project, String.to_integer(count) }

      { _, [ user, project ], _ } -> { user, project, @default_count }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
      |> decode_response
      |> convert_to_list_of_hashdicts
      |> sort_into_ascending_order
      |> Enum.take(count)
      |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({ :ok, body }), do: body
  def decode_response({ :error, error }) do
    { _, message } = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_hashdicts(list),
    do: list |> Enum.map(&Enum.into(&1, HashDict.new))

  def sort_into_ascending_order(list_of_issues),
    do: list_of_issues |> Enum.sort(&(&1["created_at"] <= &2["created_at"]))

  def print_table_for_columns(list_of_issues, list_of_columns) do
    indent_one_space = fn v -> " #{v}" end

    extract_column_values = fn hashdict ->
      hashdict
      |> HashDict.take(list_of_columns)
      |> HashDict.values
      |> Enum.map(indent_one_space)
    end

    find_length_at_index = fn list, index ->
      Enum.at(list, index)
        |> to_string
        |> String.length
    end

    generate_heading_line = fn widths ->
      widths
        |> Enum.map(&String.duplicate("-", &1))
        |> Enum.join("+")
    end

    rows =
      list_of_issues
      |> Enum.map(extract_column_values)
      |> Enum.into([ list_of_columns |> Enum.map(indent_one_space) ])

    widths =
      for col_index <- (0..(length(list_of_columns) - 1)) do
        rows
          |> Enum.map(&find_length_at_index.(&1, col_index))
          |> Enum.max
      end |> Enum.map(&(&1 + 1))

    table_rows = for row <- rows do
      for { text, width } <- row |> Enum.zip(widths) do
        String.ljust(text, width)
      end
    end |> List.insert_at(1, [generate_heading_line.(widths)])

    table_rows
      |> Enum.map(&Enum.join(&1, "|"))
      |> Enum.each(&IO.puts/1)
  end
end
