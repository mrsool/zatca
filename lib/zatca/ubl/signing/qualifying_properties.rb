class ZATCA::UBL::Signing::QualifyingProperties < ZATCA::UBL::BaseComponent
  def initialize(signing_time:, cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    super()

    @signing_time = signing_time
    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def name
    "xades:QualifyingProperties"
  end

  def attributes
    {
      "Target" => "signature",
      "xmlns:xades" => "http://uri.etsi.org/01903/v1.3.2#"
    }
  end

  def elements
    [
      ZATCA::UBL::Signing::SignedProperties.new(signing_time: @signing_time, cert_digest_value: @cert_digest_value, cert_issuer_name: @cert_issuer_name, cert_serial_number: @cert_serial_number)
    ]
  end
end
