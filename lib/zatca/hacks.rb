module ZATCA::Hacks
  extend self

  # rubocop:disable Layout/HeredocIndentation
  # rubocop:disable Layout/ClosingHeredocIndentation
  # ZATCA also hashes serverside to ensure our signed properties hash is correct.
  # However ZATCA does not format the XML to use the same whitespace needed for
  # hashing. They generate the hash using the whitespace as you sent it, so to
  # account for that we need to ensure we use the same exact whitespace as them.
  #
  # Due to the way our SDK works, we will sadly not be able to use the same
  # generated XML, we need to use ZATCA's specific spacing.
  # So we will generate the entire XML first then replace the qualifying
  # properties block to account for this.
  def zatca_indented_qualifying_properties(signing_time:, cert_digest_value:, cert_issuer_name:, cert_serial_number:)
    <<-XML.chomp
                            <xades:QualifyingProperties xmlns:xades="http://uri.etsi.org/01903/v1.3.2#" Target="signature">
                                <xades:SignedProperties Id="xadesSignedProperties">
                                    <xades:SignedSignatureProperties>
                                        <xades:SigningTime>#{signing_time}</xades:SigningTime>
                                        <xades:SigningCertificate>
                                            <xades:Cert>
                                                <xades:CertDigest>
                                                    <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
                                                    <ds:DigestValue>#{cert_digest_value}</ds:DigestValue>
                                                </xades:CertDigest>
                                                <xades:IssuerSerial>
                                                    <ds:X509IssuerName>#{cert_issuer_name}</ds:X509IssuerName>
                                                    <ds:X509SerialNumber>#{cert_serial_number}</ds:X509SerialNumber>
                                                </xades:IssuerSerial>
                                            </xades:Cert>
                                        </xades:SigningCertificate>
                                    </xades:SignedSignatureProperties>
                                </xades:SignedProperties>
                            </xades:QualifyingProperties>
  XML
  end

  # rubocop:enable Layout/HeredocIndentation
  # rubocop:enable Layout/ClosingHeredocIndentation

  def qualifying_properties_regex
    /[ ]*<xades:QualifyingProperties.*?<\/xades:QualifyingProperties>/m
  end
end
