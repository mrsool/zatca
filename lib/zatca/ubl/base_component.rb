require "byebug"

class ZATCA::UBL::BaseComponent
  attr_accessor :elements, :attributes, :name, :value

  SCHEMA = nil

  def self.schema
    self::SCHEMA
  end

  def initialize(elements: [], attributes: {}, value: "", name: "")
    @elements = elements
    @attributes = attributes
    @value = value
    @name = name
  end

  def schema
    self.class.schema
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.root { build_xml(xml) }
    end

    builder.to_xml
  end

  def build_xml(xml)
    xml.send(name, attributes) do
      if elements.length > 0
        elements.each { |element| element.build_xml(xml) }
      else
        xml.text(value)
      end
    end
  end
end
