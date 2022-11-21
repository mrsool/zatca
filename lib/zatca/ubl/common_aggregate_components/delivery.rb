class ZATCA::UBL::CommonAggregateComponents::Delivery < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  def initialize(actual_delivery_date:, latest_delivery_date: nil)
    super()

    @latest_delivery_date = latest_delivery_date
    @actual_delivery_date = actual_delivery_date
  end

  def name
    "cac:Delivery"
  end

  def latest_delivery_date_element
    return nil if @latest_delivery_date.nil?

    ZATCA::UBL::BaseComponent.new(name: "cbc:LatestDeliveryDate", value: @latest_delivery_date)
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ActualDeliveryDate", value: @actual_delivery_date),
      latest_delivery_date_element
    ]
  end
end
