class ZATCA::Hashing
  # Returns the content as:
  # - hash - SHA256 digest (bytes)
  # - hexdigest - SHA256 digest (hex)
  # - base64 - SHA256 digest (bytes) then Base64 encoded
  # - hexdigest_base64 - SHA256 digest (hex) then Base64 encoded
  def self.generate_hashes(content)
    sha256 = Digest::SHA256.digest(content)
    sha256_hex = Digest::SHA256.hexdigest(content)

    {
      base64: Base64.strict_encode64(sha256),
      hexdigest_base64: Base64.strict_encode64(sha256_hex),
      hexdigest: sha256_hex,
      hash: sha256
    }
  end
end
