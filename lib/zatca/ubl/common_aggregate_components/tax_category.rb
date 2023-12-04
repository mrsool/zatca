class ZATCA::UBL::CommonAggregateComponents::TaxCategory < ZATCA::UBL::BaseComponent
  attr_reader :id, :percent

  #     <cac:TaxCategory>
  #         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
  #         <cbc:Percent>15.00</cbc:Percent>
  #         <cac:TaxScheme>
  #             <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
  #         </cac:TaxScheme>
  #     </cac:TaxCategory>
  # <cac:TaxCategory>
  #   <cbc:ID>O</cbc:ID>
  #   <cbc:TaxExemptionReasonCode>VATEX-EU-O</cbc:TaxExemptionReasonCode>
  #   <cac:TaxScheme>
  #     <cbc:ID>VAT</cbc:ID>
  #     </cac:TaxScheme>
  # </cac:TaxCategory>
  def initialize(
    tax_percent: "15.00", id: "S", scheme_agency_id: "6",
    scheme_id: "UN/ECE 5305", tax_scheme_id: "VAT",
    tax_scheme_scheme_id: "UN/ECE 5153", tax_exemption_reason_code: nil
  )
    super()

    @tax_percent = tax_percent
    @id = id
    @scheme_agency_id = scheme_agency_id
    @scheme_id = scheme_id
    @tax_scheme_id = tax_scheme_id
    @tax_scheme_scheme_id = tax_scheme_scheme_id
    @tax_exemption_reason_code = tax_exemption_reason_code
  end

  def name
    "cac:TaxCategory"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id, attributes: {"schemeAgencyID" => @scheme_agency_id, "schemeID" => @scheme_id}.compact),
      tax_exemption_reason_code_element,
      ZATCA::UBL::BaseComponent.new(name: "cbc:Percent", value: @tax_percent),
      ZATCA::UBL::BaseComponent.new(name: "cac:TaxScheme", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @tax_scheme_id, attributes: {"schemeAgencyID" => @scheme_agency_id, "schemeID" => @tax_scheme_scheme_id}.compact)
      ])
    ]
  end

  private

  def tax_exemption_reason_code_element
    if @tax_exemption_reason_code.present?
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxExemptionReasonCode", value: @tax_exemption_reason_code)
    end
  end
end
