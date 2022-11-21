class ZATCA::UBL::CommonAggregateComponents::InvoiceLine < ZATCA::UBL::BaseComponent
  # <cac:InvoiceLine>
  # <cbc:ID>1</cbc:ID>
  # <cbc:InvoicedQuantity unitCode="PCE">44.000000</cbc:InvoicedQuantity>
  # <cbc:LineExtensionAmount currencyID="SAR">966.00</cbc:LineExtensionAmount>
  # <cac:TaxTotal>
  #     <cbc:TaxAmount currencyID="SAR">144.90</cbc:TaxAmount>
  #     <cbc:RoundingAmount currencyID="SAR">1110.90</cbc:RoundingAmount>

  # </cac:TaxTotal>
  # <cac:Item>
  #     <cbc:Name>dsd</cbc:Name>
  #     <cac:ClassifiedTaxCategory>
  #         <cbc:ID>S</cbc:ID>
  #         <cbc:Percent>15.00</cbc:Percent>
  #         <cac:TaxScheme>
  #             <cbc:ID>VAT</cbc:ID>
  #         </cac:TaxScheme>
  #     </cac:ClassifiedTaxCategory>
  # </cac:Item>
  # <cac:Price>
  #     <cbc:PriceAmount currencyID="SAR">22.00</cbc:PriceAmount>
  #     <cac:AllowanceCharge>
  #         <cbc:ChargeIndicator>false</cbc:ChargeIndicator>
  #         <cbc:AllowanceChargeReason>discount</cbc:AllowanceChargeReason>
  #         <cbc:Amount currencyID="SAR">2.00</cbc:Amount>
  #     </cac:AllowanceCharge>
  # </cac:Price>
  # </cac:InvoiceLine>

  def initialize(
    id:, invoiced_quantity:, invoiced_quantity_unit_code:,
    line_extension_amount:, tax_total:, item:,
    price:, allowance_charge: nil, currency_id: "SAR"
  )
    super()

    @id = id
    @invoiced_quantity = sprintf("%.6f", invoiced_quantity.to_f)
    @invoiced_quantity_unit_code = invoiced_quantity_unit_code
    @line_extension_amount = line_extension_amount
    @tax_total = tax_total
    @item = item
    @price = price
    @allowance_charge = allowance_charge
    @currency_id = currency_id
  end

  def name
    "cac:InvoiceLine"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id),
      ZATCA::UBL::BaseComponent.new(name: "cbc:InvoicedQuantity", value: @invoiced_quantity, attributes: {unitCode: @invoiced_quantity_unit_code}),
      ZATCA::UBL::BaseComponent.new(name: "cbc:LineExtensionAmount", value: @line_extension_amount, attributes: {currencyID: @currency_id}),
      @tax_total,
      @item,
      @price,
      @allowance_charge
    ]
  end
end
