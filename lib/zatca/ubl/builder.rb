class ZATCA::UBL::Builder
  extend Dry::Initializer

  option :element, type: ZATCA::Types.Instance(ZATCA::UBL::BaseComponent)

  def build(pretty: true, spaces: 2)
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      element.build_xml(xml)
    end

    if pretty
      xml = builder.to_xml(indent: spaces.to_i)
      apply_hacks_to_pretty_invoice(element, xml)
    else
      # ZATCA's docs specifically state we must use C14N 1.1 canoniclization.
      # but only when hashing.
      builder.doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)
    end
  end

  private

  # ZATCA sadly requires very specific and unconventional indentation in the XML
  # when it is pretty (uncanonicalized), the only way we can accomplish this is
  # to find and replace blocks manually.
  def apply_hacks_to_pretty_invoice(element, xml)
    return xml unless element.is_a?(ZATCA::UBL::Invoice)

    apply_qualifying_properties_hacks(element, xml)
  end

  def apply_qualifying_properties_hacks(invoice, xml)
    return xml if invoice.qualifying_properties.blank?

    regex = ZATCA::Hacks.qualifying_properties_regex

    xml.gsub(regex, invoice.qualifying_properties)
  end
end
