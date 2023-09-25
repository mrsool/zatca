class ZATCA::UBL::Signing::SignedProperties < ZATCA::UBL::BaseComponent
  def initialize(
    signing_time:,
    cert_digest_value:,
    cert_issuer_name:,
    cert_serial_number:
  )
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
      ZATCA::UBL::Signing::SignedSignatureProperties.new(
        signing_time: @signing_time,
        cert_digest_value: @cert_digest_value,
        cert_issuer_name: @cert_issuer_name,
        cert_serial_number: @cert_serial_number
      )
    ]
  end

  def generate_hash
    ZATCA::Signing::Invoice.generate_base64_hash(zatca_whitespaced_xml_for_hashing)
  end

  private

  # rubocop:disable Layout/HeredocIndentation
  # rubocop:disable Layout/ClosingHeredocIndentation
  #
  # We need this version of the XML with this exact whitespacing because ZATCA
  # did not opt for canonicalization before hashing (unlike the invoice hash),
  # and also because they have XML attributes that are only added the moment you
  # generate the hash but are expected to be removed in all other instances.
  #
  # We will use this version of the XML to generate the hash only, and expect
  # the output of `build_xml` to generate the non-signing version of the XML.
  # See:
  # - https://zatca1.discourse.group/t/what-do-signed-properties-look-like-when-hashing
  # - https://web.archive.org/web/20230925182417/https://zatca1.discourse.group/t/what-do-signed-properties-look-like-when-hashing/717

  def zatca_whitespaced_xml_for_hashing
    # Note: chomp is used to get rid of the final newline character
    <<-XML.chomp
<xades:SignedProperties xmlns:xades="http://uri.etsi.org/01903/v1.3.2#" Id="xadesSignedProperties">
                                    <xades:SignedSignatureProperties>
                                        <xades:SigningTime>#{@signing_time}</xades:SigningTime>
                                        <xades:SigningCertificate>
                                            <xades:Cert>
                                                <xades:CertDigest>
                                                    <ds:DigestMethod xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
                                                    <ds:DigestValue xmlns:ds="http://www.w3.org/2000/09/xmldsig#">#{@cert_digest_value}</ds:DigestValue>
                                                </xades:CertDigest>
                                                <xades:IssuerSerial>
                                                    <ds:X509IssuerName xmlns:ds="http://www.w3.org/2000/09/xmldsig#">#{@cert_issuer_name}</ds:X509IssuerName>
                                                    <ds:X509SerialNumber xmlns:ds="http://www.w3.org/2000/09/xmldsig#">#{@cert_serial_number}</ds:X509SerialNumber>
                                                </xades:IssuerSerial>
                                            </xades:Cert>
                                        </xades:SigningCertificate>
                                    </xades:SignedSignatureProperties>
                                </xades:SignedProperties>
XML
  end
  # rubocop:enable Layout/HeredocIndentation
  # rubocop:enable Layout/ClosingHeredocIndentation
end
