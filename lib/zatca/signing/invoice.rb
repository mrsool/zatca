class ZATCA::Signing::Invoice
  # Returns the invoice hashed with SHA256 then Base64 encoded
  def self.generate_base64_hash(xml_invoice)
    sha256 = Digest::SHA256.digest(xml_invoice)
    Base64.strict_encode64(sha256)
  end
end
