class ZATCA::UBL::Signing::Object < ZATCA::UBL::BaseComponent
  def initialize(signing_time:, cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    super()

    @signing_time = signing_time
    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def name
    "ds:Object"
  end

  def elements
    [
      ZATCA::UBL::Signing::QualifyingProperties.new(signing_time: @signing_time, cert_digest_value: @cert_digest_value, cert_issuer_name: @cert_issuer_name, cert_serial_number: @cert_serial_number)
    ]
  end
end
