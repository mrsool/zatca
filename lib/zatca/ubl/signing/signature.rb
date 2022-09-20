class ZATCA::UBL::Signing::Signature < ZATCA::UBL::BaseComponent
  def initialize(
    invoice_digest:, signature_properties_digest:, signature_value:,
    certificate:, signing_time:, cert_digest_value:, cert_issuer_name:,
    cert_serial_number:
  )
    super()

    @invoice_digest = invoice_digest_value
    @signature_properties_digest = signature_properties_digest
    @signature_value = signature_value
    @certificate = certificate
    @signing_time = signing_time
    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def attributes
    {
      "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#",
      "Id" => "signature"
    }
  end

  def name
    "ds:Signature"
  end
end
