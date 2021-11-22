describe ZATCA::Tag do
  let(:tag) { ZATCA::Tag.new(key: :seller_name, value: "Mrsool") }
  let(:unicode_tag) { ZATCA::Tag.new(key: :seller_name, value: "مرسول") }

  describe "#id" do
    it "gets mapped from seller_name to 1" do
      expect(ZATCA::Tag.new(key: :seller_name, value: "").id).to eq(1)
    end

    it "gets mapped from vat_registration_number to 2" do
      expect(ZATCA::Tag.new(key: :vat_registration_number, value: "").id).to eq(2)
    end

    it "gets mapped from timestamp to 3" do
      expect(ZATCA::Tag.new(key: :timestamp, value: "").id).to eq(3)
    end

    it "gets mapped from invoice_total to 4" do
      expect(ZATCA::Tag.new(key: :invoice_total, value: "").id).to eq(4)
    end

    it "gets mapped from vat_total to 5" do
      expect(ZATCA::Tag.new(key: :vat_total, value: "").id).to eq(5)
    end
  end

  describe "#to_h" do
    it "generates a valid Hash" do
      expect(tag.to_h).to eq({id: 1, key: :seller_name, value: "Mrsool"})
    end
  end

  describe "#to_tlv" do
    it "generates a valid TLV" do
      expect(tag.to_tlv).to eq("\x01\x06Mrsool")
    end

    it "generates a valid TLV when passed unicode input" do
      expected_output = "\x01\n\xD9\x85\xD8\xB1\xD8\xB3\xD9\x88\xD9\x84".force_encoding("ASCII-8BIT")

      expect(unicode_tag.to_tlv).to eq(expected_output)
    end
  end
end
