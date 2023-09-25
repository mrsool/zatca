class ZATCA::UBL::Signing::SignedInfo < ZATCA::UBL::BaseComponent
  def initialize(invoice_digest:, signed_properties_hash:)
    super()

    @invoice_digest = invoice_digest
    @signed_properties_hash = signed_properties_hash
  end

  def name
    "ds:SignedInfo"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "ds:CanonicalizationMethod", attributes: {"Algorithm" => "http://www.w3.org/2006/12/xml-c14n11"}),
      ZATCA::UBL::BaseComponent.new(name: "ds:SignatureMethod", attributes: {"Algorithm" => "http://www.w3.org/2001/04/xmldsig-more#ecdsa-sha256"}),
      ZATCA::UBL::Signing::InvoiceSignedDataReference.new(digest_value: @invoice_digest),
      ZATCA::UBL::Signing::SignaturePropertiesReference.new(digest_value: @signed_properties_hash)
    ]
  end
end
