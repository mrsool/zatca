describe ZATCA::Tags do
  let(:tags) { ZATCA::Tags.new(FIXTURES_TAGS) }

  describe "#to_base64" do
    it "generates valid Base64" do
      expect(tags.to_base64).to eq("AQZNcnNvb2wCDzMxMDIyODgzMzQwMDAwMwMZMjAyMS0xMC0yMFQxOToyOTozMiswMzowMAQDMTE1BQIxNQ==")
    end
  end
end
