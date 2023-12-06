class ZATCA::UBL::Signing::UBLExtension < ZATCA::UBL::BaseComponent
  def initialize(signature:)
    super()

    @signature = signature
  end

  def name
    "ext:UBLExtension"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "ext:ExtensionURI", value: "urn:oasis:names:specification:ubl:dsig:enveloped:xades"),
      ZATCA::UBL::BaseComponent.new(name: "ext:ExtensionContent", elements: [
        ZATCA::UBL::Signing::UBLDocumentSignatures.new(signature: @signature)
      ])
    ]
  end

  private
end
