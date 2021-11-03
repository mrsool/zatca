module ZATCA
  class Tag
    TAG_IDS = {
      seller_name: 1,
      vat_registration_number: 2,
      timestamp: 3,
      invoice_total: 4,
      vat_total: 5
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
      # format: hex_value_of_id hex_value_of_length value_itself
      # where hex_values should be padded with a 0 if containing only a single digit.

      sprintf("%02X%02X%s", @id, @value.length, @value)
    end
  end
end
