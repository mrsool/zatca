class ZATCA::Signing::Encrypting
  def self.encrypt_with_ecdsa(content:, private_key: nil, private_key_path: nil)
    private_key = parse_private_key(key: private_key, key_path: private_key_path)
    signature = private_key.dsa_sign_asn1(content)

    Base64.strict_encode64(signature)
  end

  def self.read_private_key_from_file(path)
    OpenSSL::PKey::EC.new(File.read(path))
  end

  def self.get_public_key_from_private_key(key:, key_path:)
    private_key = parse_private_key(key: key, key_path: key_path)
    private_key.public_key
  end

  # Returns a parsed private key
  # If decode_from_base64 is set to true, the key will be decoded from base64
  # before passing to OpenSSL to read it. # This is necessary because that's how
  # ZATCA's sample key is provided.
  def self.parse_private_key(key: nil, key_path: nil, decode_from_base64: false)
    parsed_key = if key.is_a?(OpenSSL::PKey::EC)
      key
    elsif key.is_a?(String)
      key_content = if decode_from_base64
        Base64.decode64(key)
      else
        key
      end

      OpenSSL::PKey::EC.new(key_content)
    elsif key_path.present?
      key_content = File.read(key_path)
      key_content = Base64.decode64(key_content) if decode_from_base64

      OpenSSL::PKey::EC.new(key_content)
    end

    if parsed_key.blank?
      raise ArgumentError.new("private_key or private_key_path is required")
    end

    parsed_key
  end
end
