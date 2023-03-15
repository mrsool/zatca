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
      # format: character_value_of_id character_value_of_value_length value_itself.
      # ZATCA previously instructed that they require the value as 8-bit ASCII
      # but as of Phase 2 they say they accept UTF-8. In fact the SDKs now throw
      # errors if you pass values as 8-bit ASCII.

      id_as_hex = [sprintf("%02X", @id)].pack("H*")
      value_length_as_hex = [sprintf("%02X", @value.bytesize)].pack("H*")

      [id_as_hex, value_length_as_hex, value].join
    end
  end
end
