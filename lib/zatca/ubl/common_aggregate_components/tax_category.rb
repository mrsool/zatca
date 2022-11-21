class ZATCA::UBL::CommonAggregateComponents::TaxCategory < ZATCA::UBL::BaseComponent
  attr_reader :id, :percent

  def initialize(
    tax_percent: "15.00", id: "S", scheme_agency_id: "6",
    scheme_id: "UN/ECE 5305", tax_scheme_id: "VAT",
    tax_scheme_scheme_id: "UN/ECE 5153"
  )
    super()

    @tax_percent = tax_percent
    @id = id
    @scheme_agency_id = scheme_agency_id
    @scheme_id = scheme_id
    @tax_scheme_id = tax_scheme_id
    @tax_scheme_scheme_id = tax_scheme_scheme_id
  end

  def name
    "cac:TaxCategory"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id, attributes: {"schemeAgencyID" => @scheme_agency_id, "schemeID" => @scheme_id}),
      ZATCA::UBL::BaseComponent.new(name: "cbc:Percent", value: @tax_percent),
      ZATCA::UBL::BaseComponent.new(name: "cac:TaxScheme", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @tax_scheme_id, attributes: {"schemeAgencyID" => @scheme_agency_id, "schemeID" => @tax_scheme_scheme_id})
      ])
    ]
  end
end
