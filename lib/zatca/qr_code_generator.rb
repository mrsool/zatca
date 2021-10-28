require "rqrcode"

module ZATCA
  class QRCodeGenerator
    def initialize(tags)
      @tags = tags
    end

    def render(size: 256)
      qr_code = generate

      qr_code.as_png(size: size, border_modules: 2)&.to_data_url
    end

    private

    def generate
      RQRCode::QRCode.new(@tags.to_base64)
    end
  end
end
