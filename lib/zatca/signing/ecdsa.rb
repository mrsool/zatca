require "starkbank-ecdsa"

class ZATCA::Signing::ECDSA
  def self.sign(content:, private_key: nil, private_key_path: nil, decode_from_base64: false)
    private_key = parse_private_key(key: private_key, key_path: private_key_path, decode_from_base64: decode_from_base64)

    ecdsa_signature = EllipticCurve::Ecdsa.sign(content, private_key)

    {
      base64: ecdsa_signature.toBase64,
      bytes: ecdsa_signature.toDer,
      public_key_bytes: private_key.publicKey.toDer
    }
  end

  def self.add_header_blocks(key_content)
    # If key is missing header blocks, add them, otherwise return it as is
    header = "-----BEGIN EC PRIVATE KEY-----"
    footer = "-----END EC PRIVATE KEY-----"

    unless key_content.include?(header) && key_content.include?(footer)
      key_content = "#{header}\n#{key_content}\n#{footer}"
    end

    key_content
  end

  def self.read_private_key_from_pem(pem)
    EllipticCurve::PrivateKey.fromPem(add_header_blocks(pem))
  end

  # Returns a parsed private key
  # If decode_from_base64 is set to true, the key will be decoded from base64
  # before passing to OpenSSL to read it. # This is necessary because that's how
  # ZATCA's sample key is provided.
  def self.parse_private_key(key: nil, key_path: nil, decode_from_base64: false)
    parsed_key = if key.is_a?(EllipticCurve::PrivateKey)
      key
    elsif key.is_a?(String)
      key_content = if decode_from_base64
        Base64.decode64(key)
      else
        key
      end

      read_private_key_from_pem(key_content)
    elsif key_path.present?
      key_content = File.read(key_path)
      key_content = Base64.decode64(key_content) if decode_from_base64

      read_private_key_from_pem(key_content)
    end

    if parsed_key.blank?
      raise ArgumentError.new("private_key or private_key_path is required")
    end

    parsed_key
  end
end
