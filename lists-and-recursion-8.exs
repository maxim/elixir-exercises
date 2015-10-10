defmodule ShipmentCalc do
  def apply_tax(amount, tax_rate) do
    (tax_rate * amount) + amount
  end

  def add_taxes(orders, tax_rates) do
    Enum.map(orders,
      fn order ->
        state = Keyword.get(order, :ship_to)
        net_amount = Keyword.get(order, :net_amount)

        total_amount = if tax_rate = Keyword.get(tax_rates, state) do
          apply_tax(net_amount, tax_rate)
        else
          net_amount
        end

        order ++ [ total_amount: total_amount ]
      end
    )
  end
end

tax_rates = [ NC: 0.075, TX: 0.08 ]
orders = [
  [ id: 123, ship_to: :NC, net_amount: 100.00 ],
  [ id: 124, ship_to: :OK, net_amount:  35.50 ],
  [ id: 125, ship_to: :TX, net_amount:  24.00 ],
  [ id: 126, ship_to: :TX, net_amount:  44.80 ],
  [ id: 127, ship_to: :NC, net_amount:  25.00 ],
  [ id: 128, ship_to: :MA, net_amount:  10.00 ],
  [ id: 129, ship_to: :CA, net_amount: 102.00 ],
  [ id: 120, ship_to: :NC, net_amount:  50.00 ]
]

IO.inspect ShipmentCalc.add_taxes(orders, tax_rates)
