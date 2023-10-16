require "active_support"

class ZATCA::UBL::CommonAggregateComponents::PartyTaxScheme < ZATCA::UBL::BaseComponent
  def initialize(
    company_id: nil,
    tax_scheme_id: "VAT"
  )
    super()

    @company_id = company_id
    @tax_scheme_id = tax_scheme_id
  end

  def name
    "cac:PartyTaxScheme"
  end

  def company_id_element
    return nil if @company_id.blank?

    ZATCA::UBL::BaseComponent.new(name: "cbc:CompanyID", value: @company_id)
  end

  def elements
    [
      company_id_element,
      ZATCA::UBL::BaseComponent.new(name: "cac:TaxScheme", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @tax_scheme_id)
      ])
    ]
  end
end
