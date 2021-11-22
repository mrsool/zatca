describe ZATCA::Tags do
  let(:tags) { ZATCA::Tags.new(FIXTURES_TAGS) }
  let(:unicode_tags) { ZATCA::Tags.new(FIXTURES_UNICODE_TAGS) }

  describe "#to_base64" do
    it "generates valid Base64 with ASCII tags" do
      expect(tags.to_base64).to eq("AQZNcnNvb2wCDzMxMDIyODgzMzQwMDAwMwMZMjAyMS0xMC0yMFQxOToyOTozMiswMzowMAQDMTE1BQIxNQ==")
    end

    it "generates valid Base64 with unicode tags" do
      expect(unicode_tags.to_base64).to eq("AQrZhdix2LPZiNmEAg8zMTAyMjg4MzM0MDAwMDMDGTIwMjEtMTAtMjBUMTk6Mjk6MzIrMDM6MDAEAzExNQUCMTU=")
    end
  end
end
