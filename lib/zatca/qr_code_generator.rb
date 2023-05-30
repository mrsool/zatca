require "rqrcode"

module ZATCA
  class QRCodeGenerator
    def initialize(tags: nil, base64: nil)
      @tags = tags
      @base64 = base64
    end

    def render(size: 256)
      qr_code = generate

      qr_code.as_png(size: size, border_modules: 2)&.to_data_url
    end

    private

    def generate
      if @tags.present?
        RQRCode::QRCode.new(@tags.to_base64)
      elsif @base64.present?
        RQRCode::QRCode.new(@base64)
      else
        raise ArgumentError, "Either tags or base64 must be provided"
      end
    end
  end
end
