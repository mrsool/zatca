describe ZATCA::Tags do
  let(:tags) { ZATCA::Tags.new(FIXTURES_TAGS) }
  let(:unicode_tags) { ZATCA::Tags.new(FIXTURES_UNICODE_TAGS) }

  describe "#to_base64" do
    it "generates valid Base64 with ASCII tags" do
      base64 = tags.to_base64
      expected_base64 = "AQZNcnNvb2wCDzMxMDIyODgzMzQwMDAwMwMZMjAyMS0xMC0yMFQxOToyOTozMiswMzowMAQDMTE1BQIxNQYsSU1ybEhPMWdicWJqc3g2akMwMWxiNjc3T1A1WHd5akluWFNxbldINTViaz0HYE1FVUNJQy9RVlA1S3pYbUEwRVYwMk9SYTMySkp5UDc4dGRzVXpZSThrS29PQm55QUFpRUEybk5RWktOZ25VcnVha1NYbVY0TStNc3RYOTF6bGtnNTFpVE1XbTB3UWNNPQhYMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEYYMMoOaFYAhMO/steotfZyavr6p11SSlwsK9azmsLY7b1b+FLhqMArhB2dqHKboxqKNfvkKDePhpqjui5hcn0QlIMEYCIQDuYdPrKDzmO1AZanczu09PsmTb7Oy9UcazdtTlntgTrwIhAPrR5tBqZiNi915ucWM1/Hhfh2insuwQEUI1KwtjQgVp"

      expect(base64).to eq(expected_base64)
    end

    it "generates valid Base64 with unicode tags" do
      base64 = unicode_tags.to_base64
      expected_base64 = "AQrZhdix2LPZiNmEAg8zMTAyMjg4MzM0MDAwMDMDGTIwMjEtMTAtMjBUMTk6Mjk6MzIrMDM6MDAEAzExNQUCMTUGLElNcmxITzFnYnFianN4NmpDMDFsYjY3N09QNVh3eWpJblhTcW5XSDU1Yms9B2BNRVVDSUMvUVZQNUt6WG1BMEVWMDJPUmEzMkpKeVA3OHRkc1V6WUk4a0tvT0JueUFBaUVBMm5OUVpLTmduVXJ1YWtTWG1WNE0rTXN0WDkxemxrZzUxaVRNV20wd1FjTT0IWDBWMBAGByqGSM49AgEGBSuBBAAKA0IABGGDDKDmhWAITDv7LXqLX2cmr6+qddUkpcLCvWs5rC2O29W/hS4ajAK4Qdnahym6MaijX75Cg3j4aao7ouYXJ9EJSDBGAiEA7mHT6yg85jtQGWp3M7tPT7Jk2+zsvVHGs3bU5Z7YE68CIQD60ebQamYjYvdebnFjNfx4X4dop7LsEBFCNSsLY0IFaQ=="

      expect(base64).to eq(expected_base64)
    end
  end
end
