describe ZATCA::Tags do
  let(:tags) { ZATCA::Tags.new(FIXTURES_TAGS) }
  let(:unicode_tags) { ZATCA::Tags.new(FIXTURES_UNICODE_TAGS) }

  describe "#to_base64" do
    it "generates valid Base64 with ASCII tags" do
      base64 = tags.to_base64
      expected_base64 = "AQZNcnNvb2wCDzMxMDIyODgzMzQwMDAwMwMUMjAyMS0xMC0yMFQxOToyOTozMloEAzExNQUCMTUGLElNcmxITzFnYnFianN4NmpDMDFsYjY3N09QNVh3eWpJblhTcW5XSDU1Yms9B2BNRVVDSUMvUVZQNUt6WG1BMEVWMDJPUmEzMkpKeVA3OHRkc1V6WUk4a0tvT0JueUFBaUVBMm5OUVpLTmduVXJ1YWtTWG1WNE0rTXN0WDkxemxrZzUxaVRNV20wd1FjTT0IWDBWMBAGByqGSM49AgEGBSuBBAAKA0IABGGDDKDmhWAITDv7LXqLX2cmr6+qddUkpcLCvWs5rC2O29W/hS4ajAK4Qdnahym6MaijX75Cg3j4aao7ouYXJ9EJSDBGAiEA7mHT6yg85jtQGWp3M7tPT7Jk2+zsvVHGs3bU5Z7YE68CIQD60ebQamYjYvdebnFjNfx4X4dop7LsEBFCNSsLY0IFaQ=="

      expect(base64).to eq(expected_base64)
    end

    it "generates valid Base64 with unicode tags" do
      base64 = unicode_tags.to_base64
      expected_base64 = "AQrZhdix2LPZiNmEAg8zMTAyMjg4MzM0MDAwMDMDFDIwMjEtMTAtMjBUMTk6Mjk6MzJaBAMxMTUFAjE1BixJTXJsSE8xZ2JxYmpzeDZqQzAxbGI2NzdPUDVYd3lqSW5YU3FuV0g1NWJrPQdgTUVVQ0lDL1FWUDVLelhtQTBFVjAyT1JhMzJKSnlQNzh0ZHNVellJOGtLb09CbnlBQWlFQTJuTlFaS05nblVydWFrU1htVjRNK01zdFg5MXpsa2c1MWlUTVdtMHdRY009CFgwVjAQBgcqhkjOPQIBBgUrgQQACgNCAARhgwyg5oVgCEw7+y16i19nJq+vqnXVJKXCwr1rOawtjtvVv4UuGowCuEHZ2ocpujGoo1++QoN4+GmqO6LmFyfRCUgwRgIhAO5h0+soPOY7UBlqdzO7T0+yZNvs7L1RxrN21OWe2BOvAiEA+tHm0GpmI2L3Xm5xYzX8eF+HaKey7BARQjUrC2NCBWk="

      expect(base64).to eq(expected_base64)
    end
  end
end
