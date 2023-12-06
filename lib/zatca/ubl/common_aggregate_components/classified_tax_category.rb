class ZATCA::UBL::CommonAggregateComponents::ClassifiedTaxCategory < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  def initialize(id: "S", percent: "15.00", tax_scheme_id: "VAT")
    super()

    @id = id
    @percent = percent
    @tax_scheme_id = tax_scheme_id
  end

  def name
    "cac:ClassifiedTaxCategory"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id),
      ZATCA::UBL::BaseComponent.new(name: "cbc:Percent", value: @percent),
      ZATCA::UBL::BaseComponent.new(name: "cac:TaxScheme", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @tax_scheme_id)
      ])
    ]
  end
end
