class ZATCA::UBL::CommonAggregateComponents::Delivery < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  def initialize(latest_delivery_date:, actual_delivery_date:)
    super()

    @latest_delivery_date = latest_delivery_date
    @actual_delivery_date = actual_delivery_date
  end

  def name
    "cac:Delivery"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ActualDeliveryDate", value: @actual_delivery_date),
      ZATCA::UBL::BaseComponent.new(name: "cbc:LatestDeliveryDate", value: @latest_delivery_date)
    ]
  end
end
