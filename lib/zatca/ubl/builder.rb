class ZATCA::UBL::Builder
  extend Dry::Initializer

  option :element, type: ZATCA::Types.Instance(ZATCA::UBL::BaseComponent)

  def build
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      element.build_xml(xml)
    end

    builder.to_xml
  end
end
