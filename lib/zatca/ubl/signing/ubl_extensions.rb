class ZATCA::UBL::Signing::UBLExtensions < ZATCA::UBL::BaseComponent
  def initialize(signature:)
    super()

    @signature = signature
  end

  def name
    "ext:UBLExtensions"
  end

  def elements
    [
      ZATCA::UBL::Signing::UBLExtension.new(signature: @signature)
    ]
  end
end
