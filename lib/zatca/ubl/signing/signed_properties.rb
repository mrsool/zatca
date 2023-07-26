class ZATCA::UBL::Signing::SignedProperties < ZATCA::UBL::BaseComponent
  def initialize(signing_time:, cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    super()

    @signing_time = signing_time
    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def name
    "xades:SignedProperties"
  end

  def attributes
    {
      "Id" => "xadesSignedProperties"
    }
  end

  def elements
    [
      ZATCA::UBL::Signing::SignedSignatureProperties.new(signing_time: @signing_time, cert_digest_value: @cert_digest_value, cert_issuer_name: @cert_issuer_name, cert_serial_number: @cert_serial_number)
    ]
  end

  def generate_hash
    canonicalized_xml = generate_xml(pretty: false)

    ZATCA::Signing::Invoice.generate_base64_hash(canonicalized_xml)
  end
end
