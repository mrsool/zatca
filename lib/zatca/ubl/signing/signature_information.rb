class ZATCA::UBL::Signing::SignatureInformation < ZATCA::UBL::BaseComponent
  def initialize(signature:)
    super()

    @signature = signature
  end

  def name
    "sac:SignatureInformation"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: "urn:oasis:names:specification:ubl:signature:1"),
      ZATCA::UBL::BaseComponent.new(name: "sbc:ReferencedSignatureID", value: "urn:oasis:names:specification:ubl:signature:Invoice"),
      @signature
    ]
  end
end
