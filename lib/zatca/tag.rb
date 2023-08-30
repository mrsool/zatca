module ZATCA
  class Tag
    TAG_IDS = {
      seller_name: 1,
      vat_registration_number: 2,
      timestamp: 3,
      invoice_total: 4,
      vat_total: 5,
      xml_invoice_hash: 6,
      ecdsa_public_key: 7,
      ecdsa_signature: 8,
      ecdsa_stamp_signature: 9 # TODO: is this needed ?
    }.freeze

    PHASE_1_TAGS = [
      :seller_name,
      :vat_registration_number,
      :timestamp,
      :invoice_total,
      :vat_total
    ].freeze

    attr_accessor :id, :key, :value

    def initialize(key:, value:)
      @id = TAG_IDS[key]
      @key = key
      @value = value.to_s
    end

    def to_h
      {id: @id, key: @key, value: @value}
    end

    def should_be_utf8_encoded?
      PHASE_1_TAGS.include?(key)
    end

    def to_tlv
      tlv = @id.chr + @value.bytesize.chr + @value
      tlv.force_encoding("ASCII-8BIT")
    end
  end
end
