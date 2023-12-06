class ZATCA::Signing::Certificate
  attr_accessor :serial_number, :issuer_name, :cert_content_without_headers,
    :hash, :public_key, :public_key_without_headers, :signature,
    :public_key_bytes

  # Returns the certificate hashed with SHA256 then Base64 encoded
  def self.generate_base64_hash(base64_certificate)
    ZATCA::Hashing.generate_hashes(base64_certificate)[:hexdigest_base64]
  end

  def self.read_certificate(certificate_path)
    certificate = OpenSSL::X509::Certificate.new(File.read(certificate_path))

    new(openssl_certificate: certificate)
  end

  def initialize(openssl_certificate:)
    super()

    @serial_number = nil
    @issuer_name = nil
    @cert_content_without_headers = nil
    @hash = nil
    @public_key = nil
    @public_key_without_headers = nil
    @public_key_bytes = nil
    @signature = nil

    @openssl_certificate = openssl_certificate

    parse_certificate
  end

  private

  attr_reader :openssl_certificate

  def parse_certificate
    @cert_content_without_headers = openssl_certificate
      .to_pem
      .gsub("-----BEGIN CERTIFICATE-----", "")
      .gsub("-----END CERTIFICATE-----", "")
      .delete("\n")

    @hash = self.class.generate_base64_hash(cert_content_without_headers)

    # ZATCA expects the issuer name to have spaces after commas, the issue name
    # looks like "CN=TSZEINVOICE-SubCA-1,DC=extgazt,DC=gov,DC=local"
    # but ZATCA wants it to be "CN=TSZEINVOICE-SubCA-1, DC=extgazt, DC=gov, DC=local"
    @issuer_name = openssl_certificate.issuer.to_utf8.gsub(",", ", ")

    @serial_number = openssl_certificate.serial.to_s
    @cert_content_without_headers = cert_content_without_headers
    @public_key = openssl_certificate.public_key.to_pem
    @public_key_without_headers = @public_key
      .gsub("-----BEGIN PUBLIC KEY-----", "")
      .gsub("-----END PUBLIC KEY-----", "")
      .delete("\n")

    @public_key_bytes = parse_public_key_bytes

    parse_signature
  end

  def parse_public_key_bytes
    openssl_certificate.public_key.to_der
  end

  def parse_signature
    der = openssl_certificate.to_der
    asn1 = OpenSSL::ASN1.decode(der)

    # The last element of the ASN1 structure is always the signature
    # The signature would look like so:
    # "0F\x02!\x00\xEEa\xD3\xEB(<\xE6;P\x19jw3\xBBOO\xB2d\xDB\xEC\xEC\xBDQ\xC6\xB3v\xD4\xE5\x9E\xD8\x13\xAF\x02!\x00\xFA\xD1\xE6\xD0jf#b\xF7^nqc5\xFCx_\x87h\xA7\xB2\xEC\x10\x11B5+\vcB\x05i"
    @signature = asn1.value[-1].value
  end
end
