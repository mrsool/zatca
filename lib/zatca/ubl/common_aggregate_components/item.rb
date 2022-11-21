class ZATCA::UBL::CommonAggregateComponents::Item < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  def initialize(name:, classified_tax_category: nil)
    super()

    @name = name
    @classified_tax_category = classified_tax_category || ZATCA::UBL::CommonAggregateComponents::ClassifiedTaxCategory.new
  end

  def name
    "cac:Item"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:Name", value: @name),
      @classified_tax_category
    ]
  end
end
