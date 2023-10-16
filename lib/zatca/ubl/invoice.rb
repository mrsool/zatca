class ZATCA::UBL::Invoice < ZATCA::UBL::BaseComponent
  TYPES = {
    invoice: "388",
    debit: "383",
    credit: "381"
  }.freeze

  PAYMENT_MEANS = {
    cash: "10",
    credit: "30",
    bank_account: "42",
    bank_card: "48"
  }.freeze

  attr_reader :signed_hash
  attr_reader :signed_hash_bytes
  attr_reader :public_key_bytes
  attr_reader :certificate_signature
  attr_reader :qualifying_properties

  attr_accessor :signature, :qr_code

  option :id, type: Dry::Types["coercible.string"]
  option :uuid, type: Dry::Types["coercible.string"]
  option :note, type: Dry::Types["coercible.string"].optional, optional: true, default: proc {}
  option :note_language_id, type: Dry::Types["coercible.string"].optional, optional: true, default: proc {}
  option :issue_date, type: Dry::Types["coercible.string"]
  option :issue_time, type: Dry::Types["coercible.string"]
  option :subtype, type: Dry::Types["coercible.string"]
  option :currency_code, type: Dry::Types["coercible.string"], default: proc { "SAR" }
  option :line_count_numeric, type: Dry::Types["coercible.string"], optional: true
  option :qr_code, type: Dry::Types["coercible.string"].optional, optional: true, default: proc {}
  option :payment_means_code, type: Dry::Types["coercible.string"]

  option :type, type: Dry::Types["coercible.string"]
  option :invoice_counter_value, type: Dry::Types["coercible.string"]
  option :previous_invoice_hash, type: Dry::Types["coercible.string"], optional: true

  option :add_ids_to_allowance_charges,
    type: Dry::Types["strict.bool"],
    optional: true,
    default: proc { true }

  option :accounting_supplier_party, type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Party)
  option :accounting_customer_party, type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Party)

  option :delivery,
    type: ZATCA::Types.Instance(ZATCA::UBL::CommonAggregateComponents::Delivery).optional,
    optional: true,
    default: proc {}

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
        attributes: {"name" => subtype},
        value: type
      ),

      # Note
      note_element,

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

    ZATCA::Hashing.generate_hashes(canonicalized_xml)[:base64]
  end

  # When submitting to ZATCA, we need to submit the XML in Base64 format, and it
  # needs to be pretty-printed matching their indentation style.
  # The pretty option here is left only for debugging purposes.
  def to_base64(pretty: true)
    Base64.strict_encode64(generate_xml(pretty: pretty))
  end

  # HACK:
  # Override this method because dry-initializer isn't helping us by having
  # an after_initialize callback. We just need to set the qualifying properties
  # at any point before generating the XML.
  def generate_xml(pretty: true, spaces: 2)
    set_qualifying_properties(
      signing_time: @signature&.signing_time,
      cert_digest_value: @signature&.cert_digest_value,
      cert_issuer_name: @signature&.cert_issuer_name,
      cert_serial_number: @signature&.cert_serial_number
    )

    super(pretty: pretty, spaces: spaces)
  end

  def generate_unsigned_xml(pretty: false)
    # HACK: Set signature and QR code to nil temporarily so they get removed
    # from the XML before generating the unsigned XML. An unsigned einvoice
    # should not have a signature or QR code, we additionally remove the qualifying
    # properties because it is a replacement that happens on the generated XML and
    # we only want that replacement on the version we submit to ZATCA.
    original_signature = signature
    original_qr_code = qr_code
    original_qualifying_properties = @qualifying_properties

    self.signature = nil
    self.qr_code = nil
    @qualifying_properties = nil

    unsigned_xml = generate_xml(pretty: pretty)

    self.signature = original_signature
    self.qr_code = original_qr_code
    @qualifying_properties = original_qualifying_properties

    unsigned_xml
  end

  def sign(
    private_key_path:,
    certificate_path:,
    signing_time: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S"),
    decode_private_key_from_base64: false
  )
    # ZATCA does not like signing_times ending with Z
    signing_time = signing_time.delete_suffix("Z")

    canonicalized_xml = generate_unsigned_xml(pretty: false)
    generated_hashes = ZATCA::Hashing.generate_hashes(canonicalized_xml)

    # Sign the invoice hash using the private key
    signature = ZATCA::Signing::ECDSA.sign(
      content: generated_hashes[:hexdigest],
      private_key_path: private_key_path,
      decode_from_base64: decode_private_key_from_base64
    )

    @signed_hash = signature[:base64]
    @signed_hash_bytes = signature[:bytes]

    # Parse and hash the certificate
    parsed_certificate = ZATCA::Signing::Certificate.read_certificate(certificate_path)
    @public_key_bytes = parsed_certificate.public_key_bytes

    # Current Version
    @certificate_signature = parsed_certificate.signature

    # ZATCA requires a different set of attributes when hashing the SignedProperties
    # attributes and does not want those attributes present in the actual XML.
    # So we'll have two sets of signed properties for this purpose, one just
    # to generate a hash out of, and one to actually include in the XML.
    # See: https://zatca1.discourse.group/t/what-do-signed-properties-look-like-when-hashing/717
    #
    # The other SignedProperties that's in the XML is generated when we construct
    # the Signature element below

    signed_properties_for_hashing = ZATCA::UBL::Signing::SignedProperties.new(
      signing_time: signing_time,
      cert_digest_value: parsed_certificate.hash,
      cert_issuer_name: parsed_certificate.issuer_name,
      cert_serial_number: parsed_certificate.serial_number
    )

    set_qualifying_properties(
      signing_time: signing_time,
      cert_digest_value: parsed_certificate.hash,
      cert_issuer_name: parsed_certificate.issuer_name,
      cert_serial_number: parsed_certificate.serial_number
    )

    # ZATCA uses very specific whitespace also for the version of this block
    # that we need to submit to their servers, so we will keep a copy of the XML
    # as it should be spaced, and then after building the XML we will replace
    # the QualifyingProperties block with this one.
    #
    # See: https://zatca1.discourse.group/t/what-do-signed-properties-look-like-when-hashing/717
    #
    # If their server is ever updated to format the block before hashing it on their
    # end, we can safely remove this behavior.
    @qualifying_properties = ZATCA::Hacks.zatca_indented_qualifying_properties(
      signing_time: signing_time,
      cert_digest_value: parsed_certificate.hash,
      cert_issuer_name: parsed_certificate.issuer_name,
      cert_serial_number: parsed_certificate.serial_number
    )

    signed_properties_hash = signed_properties_for_hashing.generate_hash

    # Create the signature element using the certficiate, invoice hash, and signed
    # properties hash
    signature_element = ZATCA::UBL::Signing::Signature.new(
      invoice_hash: generated_hashes[:base64],
      signed_properties_hash: signed_properties_hash,

      # Current Version
      signature_value: @signed_hash,

      # GPT4 Version
      # signature_value: @signed_hash[:base64],

      certificate: parsed_certificate.cert_content_without_headers,
      signing_time: signing_time,
      cert_digest_value: parsed_certificate.hash,
      cert_issuer_name: parsed_certificate.issuer_name,
      cert_serial_number: parsed_certificate.serial_number
    )

    self.signature = signature_element
  end

  private

  def note_element
    return nil if note.blank? && note_language_id.blank?

    ZATCA::UBL::BaseComponent.new(
      name: "cbc:Note",
      attributes: {"languageID" => note_language_id},
      value: note
    )
  end

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

  # Allowance charges might need to have sequential IDs, this method uses the
  # array index of each element to do that.
  def add_sequential_ids_to_allowance_charges
    return unless add_ids_to_allowance_charges

    @_added_sequential_ids_to_allowance_charges ||= false

    return if @_added_sequential_ids_to_allowance_charges

    allowance_charges.each_with_index do |allowance_charge, index|
      allowance_charge.index = index + 1
    end

    @_added_sequential_ids_to_allowance_charges = true
  end

  # Invoice lines must have sequential IDs, this method uses the array index
  # of each element to do that.
  def add_sequential_ids_to_invoice_lines
    @_added_sequential_ids_to_invoice_lines ||= false

    return if @_added_sequential_ids_to_invoice_lines

    invoice_lines.each_with_index do |invoice_line, index|
      invoice_line.index = index + 1
    end

    @_added_sequential_ids_to_invoice_lines = true
  end

  # ZATCA uses very specific whitespace also for the version of this block
  # that we need to submit to their servers, so we will keep a copy of the XML
  # as it should be spaced, and then after building the XML we will replace
  # the QualifyingProperties block with this one.
  #
  # See: https://zatca1.discourse.group/t/what-do-signed-properties-look-like-when-hashing/717
  #
  # If their server is ever updated to format the block before hashing it on their
  # end, we can safely remove this behavior.
  def set_qualifying_properties(
    signing_time:,
    cert_digest_value:,
    cert_issuer_name:,
    cert_serial_number:
  )
    @qualifying_properties = ZATCA::Hacks.zatca_indented_qualifying_properties(
      signing_time: signing_time,
      cert_digest_value: cert_digest_value,
      cert_issuer_name: cert_issuer_name,
      cert_serial_number: cert_serial_number
    )
  end
end
