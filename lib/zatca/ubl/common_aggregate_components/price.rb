class ZATCA::UBL::CommonAggregateComponents::Price < ZATCA::UBL::BaseComponent
  def initialize(price_amount:, allowance_charge: nil, currency_id: "SAR")
    super()

    @price_amount = price_amount
    @allowance_charge = allowance_charge
    @currency_id = currency_id
  end

  def name
    "cac:Price"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:PriceAmount", value: @price_amount, attributes: {currencyID: @currency_id}),
      @allowance_charge
    ]
  end
end
