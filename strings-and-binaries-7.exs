defmodule ShipmentCalc do
  def read_orders(filename) do
    import Stream, only: [drop: 2, map: 2]
    import String, only: [strip: 1, split: 2]

    stream = File.stream!(filename)
      |> drop(1)
      |> map(&strip/1)
      |> map(&split(&1, ","))

    for [ id, << _::utf8, ship_to::binary >>, net_amount ] <- stream,
      do: [
        id: String.to_integer(id),
        ship_to: String.to_atom(ship_to),
        net_amount: String.to_float(net_amount)
      ]
  end

  def add_totals(orders, tax_rates) do
    Enum.map(orders, &_add_total(&1, tax_rates))
  end

  defp _add_total(
    order = [ id: _, ship_to: state, net_amount: net_amount ],
    tax_rates
  ) do

    total_amount = if tax_rate = Keyword.get(tax_rates, state) do
      add_tax(net_amount, tax_rate)
    else
      net_amount
    end

    order ++ [ total_amount: total_amount ]
  end

  def add_tax(amount, tax_rate) do
    (tax_rate * amount) + amount
  end
end


tax_rates = [ NC: 0.075, TX: 0.08 ]

ShipmentCalc.read_orders("sales_info.csv")
  |> ShipmentCalc.add_totals(tax_rates)
  |> IO.inspect
