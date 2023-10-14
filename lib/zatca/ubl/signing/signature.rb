class ZATCA::UBL::Signing::Signature < ZATCA::UBL::BaseComponent
  attr_reader :signing_time, :cert_digest_value, :cert_issuer_name, :cert_serial_number

  def initialize(
    invoice_hash:, signed_properties_hash:, signature_value:,
    certificate:, signing_time:, cert_digest_value:, cert_issuer_name:,
    cert_serial_number:
  )
    super()

    @invoice_digest = invoice_hash
    @signed_properties_hash = signed_properties_hash
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

  def elements
    [
      ZATCA::UBL::Signing::SignedInfo.new(
        invoice_digest: @invoice_digest,
        signed_properties_hash: @signed_properties_hash
      ),

      ZATCA::UBL::BaseComponent.new(name: "ds:SignatureValue", value: @signature_value),
      ZATCA::UBL::Signing::KeyInfo.new(certificate: @certificate),

      ZATCA::UBL::Signing::Object.new(
        signing_time: @signing_time,
        cert_digest_value: @cert_digest_value,
        cert_issuer_name: @cert_issuer_name,
        cert_serial_number: @cert_serial_number
      )
    ]
  end
end
