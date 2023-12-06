class ZATCA::UBL::Signing::InvoiceSignedDataReference < ZATCA::UBL::BaseComponent
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
      "Id" => "invoiceSignedData",
      "URI" => ""
    }
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "ds:Transforms", elements: transform_elements),
      ZATCA::UBL::BaseComponent.new(name: "ds:DigestMethod", attributes: {"Algorithm" => "http://www.w3.org/2001/04/xmlenc#sha256"}),
      ZATCA::UBL::BaseComponent.new(name: "ds:DigestValue", value: @digest_value)
    ]
  end

  private

  def nested_transform_element(xpath:)
    ZATCA::UBL::BaseComponent.new(name: "ds:Transform", attributes: {"Algorithm" => "http://www.w3.org/TR/1999/REC-xpath-19991116"}, elements: [
      ZATCA::UBL::BaseComponent.new(name: "ds:XPath", value: xpath)
    ])
  end

  def transform_elements
    [
      nested_transform_element(xpath: "not(//ancestor-or-self::ext:UBLExtensions)"),
      nested_transform_element(xpath: "not(//ancestor-or-self::cac:Signature)"),
      nested_transform_element(xpath: "not(//ancestor-or-self::cac:AdditionalDocumentReference[cbc:ID='QR'])"),
      ZATCA::UBL::BaseComponent.new(name: "ds:Transform", attributes: {"Algorithm" => "http://www.w3.org/2006/12/xml-c14n11"})
    ]
  end
end
