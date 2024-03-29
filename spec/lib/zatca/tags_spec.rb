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

  describe "#to_hex_tlv" do
    it "generates valid hex TLV with ASCII tags" do
      hex = tags.to_hex_tlv
      expected_hex = "01064d72736f6f6c020f3331303232383833333430303030330314323032312d31302d32305431393a32393a33325a040331313505023135062c494d726c484f31676271626a7378366a4330316c623637374f50355877796a496e5853716e57483535626b3d07604d45554349432f515650354b7a586d4130455630324f526133324a4a79503738746473557a5949386b4b6f4f426e794141694541326e4e515a4b4e676e557275616b53586d56344d2b4d73745839317a6c6b67353169544d576d307751634d3d08583056301006072a8648ce3d020106052b8104000a0342000461830ca0e68560084c3bfb2d7a8b5f6726afafaa75d524a5c2c2bd6b39ac2d8edbd5bf852e1a8c02b841d9da8729ba31a8a35fbe428378f869aa3ba2e61727d109483046022100ee61d3eb283ce63b50196a7733bb4f4fb264dbececbd51c6b376d4e59ed813af022100fad1e6d06a662362f75e6e716335fc785f8768a7b2ec101142352b0b63420569"

      expect(hex).to eq(expected_hex)
    end
  end
end
