class ZATCA::UBL::CommonAggregateComponents::TaxTotal < ZATCA::UBL::BaseComponent
  # <cac:TaxTotal>
  # <cbc:TaxAmount currencyID="SAR">144.9</cbc:TaxAmount>
  # <cac:TaxSubtotal>
  #     <cbc:TaxableAmount currencyID="SAR">966.00</cbc:TaxableAmount>
  #     <cbc:TaxAmount currencyID="SAR">144.90</cbc:TaxAmount>
  #     <cac:TaxCategory>
  #         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
  #         <cbc:Percent>15.00</cbc:Percent>
  #         <cac:TaxScheme>
  #             <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
  #         </cac:TaxScheme>
  #     </cac:TaxCategory>
  # </cac:TaxSubtotal>
  # </cac:TaxTotal>

  def initialize(
    tax_amount:, tax_subtotal_amount: nil, taxable_amount: nil,
    rounding_amount: nil, tax_category: nil, currency_id: "SAR"
  )
    super()

    @tax_amount = tax_amount
    @tax_subtotal_amount = tax_subtotal_amount
    @taxable_amount = taxable_amount
    @rounding_amount = rounding_amount
    @tax_category = tax_category || ZATCA::UBL::CommonAggregateComponents::TaxCategory.new
    @currency_id = currency_id
  end

  def name
    "cac:TaxTotal"
  end

  def tax_subtotal_element
    if @taxable_amount.present? && @tax_subtotal_amount.present? && @tax_category.present?
      ZATCA::UBL::BaseComponent.new(name: "cac:TaxSubtotal", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:TaxableAmount", value: @taxable_amount, attributes: {"currencyID" => @currency_id}),
        ZATCA::UBL::BaseComponent.new(name: "cbc:TaxAmount", value: @tax_subtotal_amount, attributes: {"currencyID" => @currency_id}),
        @tax_category
      ])
    end
  end

  def rounding_amount_element
    if @rounding_amount.present?
      ZATCA::UBL::BaseComponent.new(name: "cbc:RoundingAmount", value: @rounding_amount, attributes: {"currencyID" => @currency_id})
    end
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxAmount", value: @tax_amount, attributes: {"currencyID" => @currency_id}),
      rounding_amount_element,
      tax_subtotal_element
    ]
  end
end
