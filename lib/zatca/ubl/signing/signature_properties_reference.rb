class ZATCA::UBL::Signing::SignaturePropertiesReference < ZATCA::UBL::BaseComponent
  attr_accessor :digest_value

  def initialize(digest_value:)
    super()
    @digest_value = digest_value
  end

  def name
    "ds:Reference"
  end

  def attributes
    {
      "Type" => "http://www.w3.org/2000/09/xmldsig#SignatureProperties",
      "URI" => "#xadesSignedProperties"
    }
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "ds:DigestMethod", attributes: {"Algorithm" => "http://www.w3.org/2001/04/xmlenc#sha256"}),
      ZATCA::UBL::BaseComponent.new(name: "ds:DigestValue", value: @digest_value)
    ]
  end
end
