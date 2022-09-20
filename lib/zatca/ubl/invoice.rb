class ZATCA::UBL::Invoice < ZATCA::UBL::BaseComponent
  # TODO: Add other properties
  def initialize(signature:)
    super()

    @signature = signature
  end

  def name
    "Invoice"
  end

  def attributes
    {
      "xmlns" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
      "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
      "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
      "xmlns:ext" => "urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
    }
  end

  def elements
    [
      ZATCA::UBL::Signing::UBLExtensions.new(signature: @signature),
      ZATCA::UBL::BaseComponent.new(name: "cbc:ProfileID", value: "reporting:1.0"),
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueDate", value: @issue_date),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueTime", value: @issue_time),
      ZATCA::UBL::BaseComponent.new(
        name: "cbc:InvoiceTypeCode",
        attributes: {"name" => @invoice_type_mask},
        value: @invoice_type_code_value
      ),
      ZATCA::UBL::BaseComponent.new(name: "cbc:DocumentCurrencyCode", value: "SAR"),
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxCurrencyCode", value: "SAR"),

      # TODO: 3 additional document references (id/uuid, pih, qr code, )

      ZATCA::UBL::BaseComponent.new(name: "cbc:Signature", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "urn:oasis:names:specification:ubl:signature:Invoice"),
        ZATCA::UBL::BaseComponent.new(name: "cbc:SignatureMethod", value: "urn:oasis:names:specification:ubl:dsig:enveloped:xades")
      ])
      # TODO: AccountingSupplierParty
      # TODO: AccountingCustomerParty
      # TODO: Delivery
      # TODO: PaymentMeans
      # TODO: AllowanceCharge
      # TODO: TaxTotal
      # TODO: LegalMonetaryTotal
      # TODO: InvoiceLine
    ]
  end
end
