class ZATCA::UBL::Builder
  extend Dry::Initializer

  option :element, type: ZATCA::Types.Instance(ZATCA::UBL::BaseComponent)

  def build(pretty: true)
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      element.build_xml(xml)
    end

    if pretty
      builder.to_xml
    else
      # ZATCA's docs specifically state we must use C14N 1.1 canoniclization
      builder.doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)
    end
  end
end
