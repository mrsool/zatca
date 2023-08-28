class ZATCA::Signing::Invoice
  # Returns the invoice hashed with SHA256 then Base64 encoded
  def self.generate_base64_hash(xml_invoice)
    sha256 = Digest::SHA256.digest(xml_invoice)
    sha256_hex = Digest::SHA256.hexdigest(xml_invoice)

    {
      base64: Base64.strict_encode64(sha256),
      hexdigest_base64: Base64.strict_encode64(sha256_hex),
      hexdigest: sha256_hex,
      hash: sha256
    }
  end
end
