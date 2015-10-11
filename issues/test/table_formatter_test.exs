defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def simple_test_data do
    [ [c1: "r1 c1", c2: "r1 c2",   c3: "r1 c3", c4: "r1+++c4" ],
      [c1: "r2 c1", c2: "r2 c2",   c3: "r2 c3", c4: "r2 c4"   ],
      [c1: "r3 c1", c2: "r3 c2",   c3: "r3 c3", c4: "r3 c4"   ],
      [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"   ] ]
  end

  def headers, do: [ :c1, :c2, :c4 ]

  def filter_test_rows,
    do: TF.transform_into_filtered_rows(simple_test_data, headers)

  test "transform_into_filtered_rows" do
    filtered_rows = filter_test_rows
    assert length(filtered_rows) == 5
    assert List.first(filtered_rows) == [ "c1", "c2", "c4" ]
    assert List.last(filtered_rows) == [ "r4 c1", "r4++c2", "r4 c4" ]
  end

  test "determine_col_widths" do
    widths = TF.determine_col_widths(filter_test_rows)
    assert widths == [ 5, 6, 7 ]
  end

  test "output is correct" do
    result = capture_io fn ->
      TF.print_table_for_columns(simple_test_data, headers)
    end

    assert result == """
    c1    | c2     | c4
    ------+--------+--------
    r1 c1 | r1 c2  | r1+++c4
    r2 c1 | r2 c2  | r2 c4
    r3 c1 | r3 c2  | r3 c4
    r4 c1 | r4++c2 | r4 c4
    """
  end
end
