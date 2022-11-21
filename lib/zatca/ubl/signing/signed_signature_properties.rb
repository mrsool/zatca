class ZATCA::UBL::Signing::SignedSignatureProperties < ZATCA::UBL::BaseComponent
  def initialize(signing_time:, cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    super()

    @signing_time = signing_time
    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def name
    "xades:SignedSignatureProperties"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "xades:SigningTime", value: @signing_time),
      ZATCA::UBL::BaseComponent.new(name: "xades:SigningCertificate", elements: [
        ZATCA::UBL::Signing::Cert.new(cert_digest_value: @cert_digest_value, cert_issuer_name: @cert_issuer_name, cert_serial_number: @cert_serial_number)
      ])
    ]
  end
end
