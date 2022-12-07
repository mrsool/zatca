class ZATCA::Signing::Hashing
  def self.sha256_hexdigest(content)
    Digest::SHA256.hexdigest(content)
  end

  def self.sha256_digest(content)
    Digest::SHA256.digest(content)
  end

  def self.base_64_encode(content)
    Base64.strict_encode64(content)
  end
end
