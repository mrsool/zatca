describe ZATCA::Tags do
  let(:tags) { ZATCA::Tags.new(FIXTURES_TAGS) }

  describe "#to_base64" do
    it "generates valid Base64" do
      expect(tags.to_base64).to eq("MDEwNk1yc29vbDAyMEYzMTAyMjg4MzM0MDAwMDMwMzE5MjAyMS0xMC0yMFQxOToyOTozMiswMzowMDA0MDMxMTUwNTAyMTU=")
    end
  end
end
