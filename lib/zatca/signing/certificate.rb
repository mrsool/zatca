class ZATCA::Signing::Certificate
  attr_accessor :serial_number, :issuer_name, :cert_content_without_headers,
    :hash, :public_key, :signature, :unpacked_signature

  # Returns the certificate hashed with SHA256 then Base64 encoded
  def self.generate_base64_hash(base64_certificate)
    sha256 = Digest::SHA256.hexdigest(base64_certificate)
    Base64.strict_encode64(sha256)
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
    @signature = nil
    @unpacked_signature = nil

    @openssl_certificate = openssl_certificate

    parse_certificate
  end

  private

  attr_reader :openssl_certificate

  def parse_certificate
    @cert_content_without_headers = openssl_certificate.to_pem.gsub("-----BEGIN CERTIFICATE-----", "").gsub("-----END CERTIFICATE-----", "").delete("\n")
    @hash = self.class.generate_base64_hash(cert_content_without_headers)

    # ZATCA expects the issuer name to have spaces after commas, the issue name
    # looks like "CN=TSZEINVOICE-SubCA-1,DC=extgazt,DC=gov,DC=local"
    # but ZATCA wants it to be "CN=TSZEINVOICE-SubCA-1, DC=extgazt, DC=gov, DC=local"
    @issuer_name = openssl_certificate.issuer.to_utf8.gsub(",", ", ")

    @serial_number = openssl_certificate.serial.to_s
    @cert_content_without_headers = cert_content_without_headers
    @public_key = openssl_certificate.public_key.to_pem

    parse_signature
  end

  def parse_signature
    der = openssl_certificate.to_der
    asn1 = OpenSSL::ASN1.decode(der)

    # The last element of the ASN1 structure is always the signature
    # The signature would look like so:
    # "0F\x02!\x00\xEEa\xD3\xEB(<\xE6;P\x19jw3\xBBOO\xB2d\xDB\xEC\xEC\xBDQ\xC6\xB3v\xD4\xE5\x9E\xD8\x13\xAF\x02!\x00\xFA\xD1\xE6\xD0jf#b\xF7^nqc5\xFCx_\x87h\xA7\xB2\xEC\x10\x11B5+\vcB\x05i"
    @signature = asn1.value[-1].value

    # Unpack the signature and convert it to hex, then add colons between each byte
    # So it ends up looking like so:
    # "30:46:02:21:00:ee:61:d3:eb:28:3c:e6:3b:50:19:6a:77:33:bb:4f:4f:b2:64:db:ec:ec:bd:51:c6:b3:76:d4:e5:9e:d8:13:af:02:21:00:fa:d1:e6:d0:6a:66:23:62:f7:5e:6e:71:63:35:fc:78:5f:87:68:a7:b2:ec:10:11:42:35:2b:0b:63:42:05:69"
    @unpacked_signature = @signature.unpack1("H*").gsub(/(..)/, '\1:')[0..-2]
  end
end
