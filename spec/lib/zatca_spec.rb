describe ZATCA::Tags do
  let(:tags) { FIXTURES_TAGS }

  describe "#render_qr_code" do
    it "instantiates a QRCodeGenerator and calls #render with a hash of tags" do
      expect_any_instance_of(ZATCA::QRCodeGenerator).to receive(:render)

      ZATCA.render_qr_code(tags: tags)
    end

    it "instantiates a QRCodeGenerator and calls #render with ZATCA::Tags" do
      expect_any_instance_of(ZATCA::QRCodeGenerator).to receive(:render)

      tags = ZATCA::Tags.new(FIXTURES_TAGS)
      ZATCA.render_qr_code(tags: tags)
    end

    it "instantiates a QRCodeGenerator and calls #render with base64" do
      expect_any_instance_of(ZATCA::QRCodeGenerator).to receive(:render)

      ZATCA.render_qr_code(base64: FIXTURES_BASE64_QR_CODE)
    end
  end
end
