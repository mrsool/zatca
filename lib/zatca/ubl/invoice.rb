class ZATCA::UBL::Invoice < ZATCA::UBL::BaseComponent
  INVOICE_TYPE_CODES = {
    invoice: "388",
    debit: "383",
    credit: "381"
  }.freeze

  option :id, type: Dry::Types["coercible.string"]
  option :uuid, type: Dry::Types["coercible.string"]
  option :issue_date, type: Dry::Types["coercible.string"]
  option :issue_time, type: Dry::Types["coercible.string"]
  option :invoice_type_mask, type: Dry::Types["coercible.string"]
  option :currency_code, type: Dry::Types["coercible.string"], default: proc { "SAR" }
  option :line_count_numeric, type: Dry::Types["coercible.string"], optional: true
  option :qr_code, type: Dry::Types["coercible.string"].optional, optional: true, default: proc {}
  option :payment_means_code, type: Dry::Types["coercible.string"]

  option :invoice_type_code_value, type: Dry::Types["coercible.string"]
  option :invoice_counter_value, type: Dry::Types["coercible.string"]
  option :previous_invoice_hash, type: Dry::Types["coercible.string"], optional: true

  option :accounting_supplier_party, type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Party)
  option :accounting_customer_party, type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Party)

  option :delivery,
    type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Delivery),
    optional: true

  option :allowance_charges,
    type: ZATCA::Types::Array.of(ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::AllowanceCharge)),
    optional: true,
    default: proc { [] }

  option :tax_totals,
    type: ZATCA::Types::Array.of(ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::TaxTotal)),
    default: proc { [] }

  option :legal_monetary_total, type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::LegalMonetaryTotal)

  option :invoice_lines,
    type: ZATCA::Types::Array.of(ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::InvoiceLine))

  option :signature,
    type: ZATCA::Types.Instance(ZATCA::UBL::Signing::Signature).optional,
    optional: true,
    default: proc {}

  attr_accessor :signature, :qr_code

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
    add_sequential_ids

    [
      # Invoice signature
      ubl_extensions_element,

      # Metadata
      ZATCA::UBL::BaseComponent.new(name: "cbc:ProfileID", value: "reporting:1.0"),
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: id),
      ZATCA::UBL::BaseComponent.new(name: "cbc:UUID", value: uuid),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueDate", value: issue_date),
      ZATCA::UBL::BaseComponent.new(name: "cbc:IssueTime", value: issue_time),

      # Invoice type
      ZATCA::UBL::BaseComponent.new(
        name: "cbc:InvoiceTypeCode",
        attributes: {"name" => invoice_type_mask},
        value: invoice_type_code_value
      ),

      # Currency codes
      ZATCA::UBL::BaseComponent.new(name: "cbc:DocumentCurrencyCode", value: currency_code),
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxCurrencyCode", value: currency_code),

      # Line Count Numeric (Standard Invoice only)
      line_count_numeric_element,

      # Additional document references
      # Invoice counter value (ICV)
      ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "ICV"),
        ZATCA::UBL::BaseComponent.new(name: "cbc:UUID", value: invoice_counter_value)
      ]),

      # Previous invoice hash (PIH)
      previous_invoice_hash_document_reference,

      # QR code
      qr_code_document_reference,

      # Static: signature
      static_signature_element,

      # AccountingSupplierParty
      ZATCA::UBL::BaseComponent.new(name: "cac:AccountingSupplierParty", elements: [
        accounting_supplier_party
      ]),

      # AccountingCustomerParty
      ZATCA::UBL::BaseComponent.new(name: "cac:AccountingCustomerParty", elements: [
        accounting_customer_party
      ]),

      # Delivery
      delivery,

      # PaymentMeans
      ZATCA::UBL::BaseComponent.new(name: "cac:PaymentMeans", elements: [
        ZATCA::UBL::BaseComponent.new(name: "cbc:PaymentMeansCode", value: payment_means_code)
      ]),

      # AllowanceCharges
      # TODO: Figure out how this ties to invoice lines
      *allowance_charges,

      # TaxTotals
      *tax_totals,

      # LegalMonetaryTotal
      legal_monetary_total,

      # InvoiceLines
      *invoice_lines
    ]
  end

  def generate_hash
    canonicalized_xml = generate_unsigned_xml(pretty: false)

    ZATCA::Signing::Invoice.generate_base64_hash(canonicalized_xml)
  end

  def generate_unsigned_xml(pretty: false)
    # HACK: Set signature and QR code to nil temporarily so they get removed
    # from the XML before generating the hash.
    original_signature = signature
    original_qr_code = qr_code
    self.signature = nil
    self.qr_code = nil

    unsigned_xml = generate_xml(pretty: pretty)

    self.signature = original_signature
    self.qr_code = original_qr_code

    unsigned_xml
  end

  private

  def previous_invoice_hash_document_reference
    return nil if previous_invoice_hash.nil?

    ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "PIH"),
      ZATCA::UBL::BaseComponent.new(name: "cac:Attachment", elements: [
        ZATCA::UBL::BaseComponent.new(
          name: "cbc:EmbeddedDocumentBinaryObject",
          attributes: {"mimeCode" => "text/plain"},
          value: previous_invoice_hash
        )
      ])
    ])
  end

  def qr_code_document_reference
    return nil if qr_code.blank?

    ZATCA::UBL::BaseComponent.new(name: "cac:AdditionalDocumentReference", elements: [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "QR"),
      ZATCA::UBL::BaseComponent.new(name: "cac:Attachment", elements: [
        ZATCA::UBL::BaseComponent.new(
          name: "cbc:EmbeddedDocumentBinaryObject",
          attributes: {"mimeCode" => "text/plain"},
          value: qr_code
        )
      ])
    ])
  end

  def line_count_numeric_element
    return nil if line_count_numeric.blank?

    ZATCA::UBL::BaseComponent.new(name: "cbc:LineCountNumeric", value: line_count_numeric)
  end

  def ubl_extensions_element
    return nil if signature.blank?

    ZATCA::UBL::Signing::UBLExtensions.new(signature: signature)
  end

  def static_signature_element
    return nil if signature.blank?

    ZATCA::UBL::BaseComponent.new(name: "cac:Signature", elements: [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "urn:oasis:names:specification:ubl:signature:Invoice"),
      ZATCA::UBL::BaseComponent.new(name: "cbc:SignatureMethod", value: "urn:oasis:names:specification:ubl:dsig:enveloped:xades")
    ])
  end

  def add_sequential_ids
    add_sequential_ids_to_allowance_charges
    add_sequential_ids_to_invoice_lines
  end

  # Allowance charges must have sequential IDs, this method uses the array index
  # of each element to do that
  def add_sequential_ids_to_allowance_charges
    @_added_sequential_ids_to_allowance_charges ||= false

    return if @_added_sequential_ids_to_allowance_charges

    allowance_charges.each_with_index do |allowance_charge, index|
      allowance_charge.index = index + 1
    end

    @_added_sequential_ids_to_allowance_charges = true
  end

  # Invoice lines must have sequential IDs, this method uses the array index
  # of each element to do that
  def add_sequential_ids_to_invoice_lines
    @_added_sequential_ids_to_invoice_lines ||= false

    return if @_added_sequential_ids_to_invoice_lines

    invoice_lines.each_with_index do |invoice_line, index|
      invoice_line.index = index + 1
    end

    @_added_sequential_ids_to_invoice_lines = true
  end
end
