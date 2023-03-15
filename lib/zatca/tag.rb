module ZATCA
  class Tag
    TAG_IDS = {
      seller_name: 1,
      vat_registration_number: 2,
      timestamp: 3,
      invoice_total: 4,
      vat_total: 5,
      xml_invoice_hash: 6,
      ecdsa_signature: 7,
      ecdsa_public_key: 8,
      ecdsa_stamp_signature: 9
    }.freeze

    attr_accessor :id, :key, :value

    def initialize(key:, value:)
      @id = TAG_IDS[key]
      @key = key
      @value = value.to_s
    end

    def to_h
      {id: @id, key: @key, value: @value}
    end

    def to_tlv
      # TLV should be concatenated together without any separator in the following
      # format: character_value_of_id character_value_of_value_length value_itself
      # All of this should be in 8-bit ASCII.
      # tlv = @id.chr + @value.bytesize.chr + value

      id_as_hex = [sprintf("%02X", @id)].pack("H*")
      value_length_as_hex = [sprintf("%02X", @value.bytesize)].pack("H*")

      tlv = [id_as_hex, value_length_as_hex, value].join
      # Base64.strict_encode64(tlv)
      # We need to use force_encoding because encode will raise errors when
      # trying to encode a string with utf-8 characters.
      # tlv.force_encoding("ASCII-8BIT")
    end
  end
end
