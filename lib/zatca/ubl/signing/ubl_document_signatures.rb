class ZATCA::UBL::Signing::UBLDocumentSignatures < ZATCA::UBL::BaseComponent
  def initialize(signature:)
    super()

    @signature = signature
  end

  def name
    "sig:UBLDocumentSignatures"
  end

  def attributes
    {
      "xmlns:sig" => "urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2",
      "xmlns:sac" => "urn:oasis:names:specification:ubl:schema:xsd:SignatureAggregateComponents-2",
      "xmlns:sbc" => "urn:oasis:names:specification:ubl:schema:xsd:SignatureBasicComponents-2"
    }
  end

  def elements
    [
      ZATCA::UBL::Signing::SignatureInformation.new(signature: @signature)
    ]
  end
end
