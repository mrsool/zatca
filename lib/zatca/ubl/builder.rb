class ZATCA::UBL::Builder
  def initialize(element:)
    @element = element
  end

  def build
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      @element.build_xml(xml)
    end

    builder.to_xml
  end
end
