class ZATCA::UBL::Signing::Cert < ZATCA::UBL::BaseComponent
  # <xades:Cert>
  #   <xades:CertDigest>
  #     <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
  #     <ds:DigestValue>NjlhOTVmYzIzN2I0MjcxNGRjNDQ1N2EzM2I5NGNjNDUyZmQ5ZjExMDUwNGM2ODNjNDAxMTQ0ZDk1NDQ4OTRmYg==</ds:DigestValue>
  #   </xades:CertDigest>
  #   <xades:IssuerSerial>
  #     <ds:X509IssuerName>CN=TSZEINVOICE-SubCA-1, DC=extgazt, DC=gov, DC=local</ds:X509IssuerName>
  #     <ds:X509SerialNumber>2475382876776561391517206651645660279462721580</ds:X509SerialNumber>
  #   </xades:IssuerSerial>
  # </xades:Cert>

  def initialize(cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    super()

    @cert_digest_value = cert_digest_value
    @cert_issuer_name = cert_issuer_name
    @cert_serial_number = cert_serial_number
  end

  def name
    "xades:Cert"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "xades:CertDigest", elements: [
        ZATCA::UBL::BaseComponent.new(
          name: "ds:DigestMethod",
          attributes: attributes_for_signing.merge({
            "Algorithm" => "http://www.w3.org/2001/04/xmlenc#sha256"
          })
        ),
        ZATCA::UBL::BaseComponent.new(name: "ds:DigestValue", value: @cert_digest_value, attributes: attributes_for_signing)
      ]),
      ZATCA::UBL::BaseComponent.new(name: "xades:IssuerSerial", elements: [
        ZATCA::UBL::BaseComponent.new(name: "ds:X509IssuerName", value: @cert_issuer_name, attributes: attributes_for_signing),
        ZATCA::UBL::BaseComponent.new(name: "ds:X509SerialNumber", value: @cert_serial_number, attributes: attributes_for_signing)
      ])
    ]
  end

  private

  def attributes_for_signing
    {
      "xmlns:xades" => "http://uri.etsi.org/01903/v1.3.2#"
    }
  end
end
