require "base64"

module ZATCA
  class Tags
    def initialize(tags)
      keys_to_coerce_to_string = tags.except(:timestamp).keys
      stringified_tags = tags.map do |key, value|
        if keys_to_coerce_to_string.include?(key)
          [key, value.to_s]
        else
          [key, value]
        end
      end.to_h

      schema_result = TagsSchema.call(stringified_tags)
      if schema_result.failure?
        raise(Error, "Parsing tags failed due to:\n#{schema_result.errors(full: true).to_h}")
      end

      stringified_tags[:timestamp] = tags[:timestamp].to_s

      # Create tags, then sort them by ID
      @tags = stringified_tags.map do |key, value|
        Tag.new(key: key, value: value)
      end.sort_by(&:id)
    end

    def to_base64
      Base64.strict_encode64(to_tlv)
    end

    private

    def to_tlv
      @tags.map(&:to_tlv).join("")
    end
  end
end
