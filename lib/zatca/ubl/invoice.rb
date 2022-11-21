class ZATCA::UBL::Invoice < ZATCA::UBL::BaseComponent
  def initialize(
    signature:, id:, uuid:, issue_date:, issue_time:, invoice_type_mask:,
    invoice_type_code_value:, invoice_counter_value:, previous_invoice_hash:,
    qr_code:, accounting_supplier_party:, accounting_customer_party:, delivery:,
    payment_means_code:, allowance_charges:, tax_totals:, legal_monetary_total:,
    invoice_lines:, currency_code: "SAR"
  )
    super()

    @signature = signature
    @id = id
    @uuid = uuid
    @issue_date = issue_date
    @issue_time = issue_time
    @invoice_type_mask = invoice_type_mask
    @invoice_type_code_value = invoice_type_code_value

    @invoice_counter_value = invoice_counter_value
    @previous_invoice_hash = previous_invoice_hash
    @qr_code = qr_code

    @accounting_supplier_party = accounting_supplier_party
    @accounting_customer_party = accounting_customer_party

    @delivery = delivery
    @payment_means_code = payment_means_code
    @allowance_charges = allowance_charges
    @tax_totals = tax_totals
    @legal_monetary_total = legal_monetary_total

    @invoice_lines = invoice_lines

    @currency_code = currency_code

    # Add sequential IDs to entities that need them
    add_sequential_ids_to_allowance_charges
    add_sequential_ids_to_invoice_lines
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
      # Invoice signature
      ZATCA::UBL::Signing::UBLExtensions.new(signature: @signature),

      # Metadata
      ZATCA::UBL::BaseComponent.new(name: "cbc:ProfileID", value: "reporting:1.0"),
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id),
      ZATCA::UBL::BaseComponent.new(name: "cbc:UUID", value: @uuid),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueDate", value: @issue_date),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueTime", value: @issue_time),

      # Invoice type
      ZATCA::UBL::BaseComponent.new(
        name: "cbc:InvoiceTypeCode",
        attributes: {"name" => @invoice_type_mask},
        value: @invoice_type_code_value
      ),

      # Currency codes
      ZATCA::UBL::BaseComponent.new(name: "cbc:DocumentCurrencyCode", value: @currency_code),
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxCurrencyCode", value: @currency_code),

      # Additional document references
      # Invoice counter value (ICV)
      ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "ICV"),
        ZATCA::UBL::BaseComponent.new(name: "cbc:UUID", value: @invoice_counter_value)
      ]),

      # Previous invoice hash (PIH)
      previous_invoice_hash_document_reference,

      # QR code
      qr_code_document_reference,

      # Static: signature
      ZATCA::UBL::BaseComponent.new(name: "cac:Signature", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "urn:oasis:names:specification:ubl:signature:Invoice"),
        ZATCA::UBL::BaseComponent.new(name: "cbc:SignatureMethod", value: "urn:oasis:names:specification:ubl:dsig:enveloped:xades")
      ]),

      # AccountingSupplierParty
      ZATCA::UBL::BaseComponent.new(name: "cac:AccountingSupplierParty", elements: [
        @accounting_supplier_party
      ]),

      # AccountingCustomerParty
      ZATCA::UBL::BaseComponent.new(name: "cac:AccountingCustomerParty", elements: [
        @accounting_customer_party
      ]),

      # Delivery
      @delivery,

      # PaymentMeans
      ZATCA::UBL::BaseComponent.new(name: "cac:PaymentMeans", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:PaymentMeansCode", value: @payment_means_code)
      ]),

      # AllowanceCharges
      # TODO: Figure out how this ties to invoice lines
      *@allowance_charges,

      # TaxTotals
      *@tax_totals,

      # LegalMonetaryTotal
      @legal_monetary_total,

      # InvoiceLines
      *@invoice_lines
    ]
  end

  private

  def previous_invoice_hash_document_reference
    ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "PIH"),
      ZATCA::UBL::BaseComponent.new(name: "cac:Attachment", elements: [
        ZATCA::UBL::BaseComponent.new(
          name: "cbc:EmbeddedDocumentBinaryObject",
          attributes: {"mimeCode" => "text/plain"},
          value: @previous_invoice_hash
        )
      ])
    ])
  end

  def qr_code_document_reference
    ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "QR"),
      ZATCA::UBL::BaseComponent.new(name: "cac:Attachment", elements: [
        ZATCA::UBL::BaseComponent.new(
          name: "cbc:EmbeddedDocumentBinaryObject",
          attributes: {"mimeCode" => "text/plain"},
          value: @qr_code
        )
      ])
    ])
  end

  # Allowance charges must have sequential IDs, this method uses the array index
  # of each element to do that
  def add_sequential_ids_to_allowance_charges
    @allowance_charges.each_with_index do |allowance_charge, index|
      allowance_charge.index = index + 1
    end
  end

  # Invoice lines must have sequential IDs, this method uses the array index
  # of each element to do that
  def add_sequential_ids_to_invoice_lines
    @invoice_lines.each_with_index do |invoice_line, index|
      invoice_line.index = index + 1
    end
  end
end
