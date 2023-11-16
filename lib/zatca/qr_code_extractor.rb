require "nokogiri"
require "base64"

class ZATCA::QRCodeExtractor
  attr_reader :invoice_base64

  def initialize(invoice_base64:)
    @invoice_base64 = invoice_base64
  end

  def extract
    xml_invoice = Base64.strict_decode64(invoice_base64)
    extract_qr_code_base64_from_xml(xml_invoice)
  end

  private

  def extract_qr_code_base64_from_xml(xml)
    # Read Invoice
    doc = Nokogiri::XML(xml)

    # Extract QR Code by XPath
    qr_code_node = doc.xpath(qr_code_xpath)&.first

    qr_code_node.present? ? qr_code_node.text : nil
  end

  def qr_code_xpath
    "//cac:AdditionalDocumentReference[cbc:ID='QR']/cac:Attachment/cbc:EmbeddedDocumentBinaryObject"
  end
end
