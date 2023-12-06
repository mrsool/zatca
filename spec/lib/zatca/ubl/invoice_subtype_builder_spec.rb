RSpec.describe ZATCA::UBL::InvoiceSubtypeBuilder do
  subject { described_class }

  describe "#build" do
    it "builds standard tax invoice subtype" do
      code = subject.build(
        simplified: false,
        third_party: false,
        nominal: false,
        exports: false,
        summary: false,
        self_billed: false
      )
      expect(code).to eq("0100000")
    end

    it "builds simplified tax invoice subtype" do
      code = subject.build(
        simplified: true,
        third_party: false,
        nominal: false,
        exports: false,
        summary: false,
        self_billed: false
      )
      expect(code).to eq("0200000")
    end

    it "builds third-party invoice transaction subtype" do
      code = subject.build(
        simplified: false,
        third_party: true,
        nominal: false,
        exports: false,
        summary: false,
        self_billed: false
      )
      expect(code).to eq("0110000")
    end

    it "builds nominal invoice transaction subtype" do
      code = subject.build(
        simplified: false,
        third_party: false,
        nominal: true,
        exports: false,
        summary: false,
        self_billed: false
      )
      expect(code).to eq("0101000")
    end

    it "builds exports invoice transaction subtype" do
      code = subject.build(
        simplified: false,
        third_party: false,
        nominal: false,
        exports: true,
        summary: false,
        self_billed: false
      )
      expect(code).to eq("0100100")
    end

    it "builds summary invoice transaction subtype" do
      code = subject.build(
        simplified: false,
        third_party: false,
        nominal: false,
        exports: false,
        summary: true,
        self_billed: false
      )
      expect(code).to eq("0100010")
    end

    it "builds self-billed invoice subtype" do
      code = subject.build(
        simplified: false,
        third_party: false,
        nominal: false,
        exports: false,
        summary: false,
        self_billed: true
      )
      expect(code).to eq("0100001")
    end

    it "builds complex invoice subtype" do
      code = subject.build(
        simplified: true,
        third_party: true,
        nominal: true,
        exports: true,
        summary: true,
        self_billed: true
      )
      expect(code).to eq("0211111")
    end
  end
end
