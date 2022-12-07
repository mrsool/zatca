class ZATCA::UBL::CommonAggregateComponents::AllowanceCharge < ZATCA::UBL::BaseComponent
  attr_accessor :id, :charge_indicator, :allowance_charge_reason, :amount

  #   <cac:AllowanceCharge>
  #   <cbc:ID>1</cbc:ID>
  #   <cbc:ChargeIndicator>false</cbc:ChargeIndicator>
  #   <cbc:AllowanceChargeReason>discount</cbc:AllowanceChargeReason>
  #   <cbc:Amount currencyID="SAR">2</cbc:Amount>
  #   <cac:TaxCategory>
  #       <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
  #       <cbc:Percent>15</cbc:Percent>
  #       <cac:TaxScheme>
  #           <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
  #       </cac:TaxScheme>
  #   </cac:TaxCategory>
  # </cac:AllowanceCharge>

  def initialize(
    charge_indicator:, allowance_charge_reason:, amount:, currency_id: "SAR",
    tax_category: nil, add_tax_category: true, add_id: true
  )
    super()

    @charge_indicator = charge_indicator.to_s

    @allowance_charge_reason = allowance_charge_reason
    @amount = amount
    @currency_id = currency_id

    @add_tax_category = add_tax_category
    @tax_category = tax_category
    @add_id = add_id

    if add_tax_category && @tax_category.blank?
      @tax_category = ZATCA::UBL::CommonAggregateComponents::TaxCategory.new
    end
  end

  def name
    "cac:AllowanceCharge"
  end

  def id_element
    if @add_id
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: index)
    end
  end

  def elements
    [
      id_element,
      ZATCA::UBL::BaseComponent.new(name: "cbc:ChargeIndicator", value: @charge_indicator),
      ZATCA::UBL::BaseComponent.new(name: "cbc:AllowanceChargeReason", value: @allowance_charge_reason),
      ZATCA::UBL::BaseComponent.new(name: "cbc:Amount", value: @amount, attributes: {"currencyID" => @currency_id}),
      @tax_category
    ]
  end
end
