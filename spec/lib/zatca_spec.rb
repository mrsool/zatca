describe ZATCA::Tags do
  let(:tags) { FIXTURES_TAGS }

  describe "#render_qr_code" do
    it "instantiates a QRCodeGenerator and calls #render" do
      expect_any_instance_of(ZATCA::QRCodeGenerator).to receive(:render)

      ZATCA.render_qr_code(tags)
    end
  end
end
