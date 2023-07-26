class ZATCA::Signing::Invoice
  # Returns the invoice hashed with SHA256 then Base64 encoded
  def self.generate_base64_hash(xml_invoice)
    sha256 = Digest::SHA256.digest(xml_invoice)
    hex_to_base64 = [[sha256].pack("H*")].pack("m0")

    {
      base64: Base64.strict_encode64(sha256),
      hex_to_base64: hex_to_base64,
      hash: sha256
    }
  end
end
