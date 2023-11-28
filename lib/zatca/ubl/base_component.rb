require "dry-initializer"
require_relative "../types"

class ZATCA::UBL::BaseComponent
  extend Dry::Initializer
  attr_accessor :elements, :attributes, :name, :value, :index

  # def self.guard_dig(obj)
  #   unless obj.respond_to?(:dig)
  #     raise TypeError, "#{obj.class.name} does not have #dig method"
  #   end
  # end

  ArrayOfBaseComponentOrNil = ZATCA::Types::Array.of(ZATCA::Types.Instance(ZATCA::UBL::BaseComponent))
    .default { [] }
    .constructor { |value| value.blank? ? [] : value.compact }

  option :elements,
    type: ArrayOfBaseComponentOrNil,
    default: proc { [] },
    optional: true

  option :attributes, type: ZATCA::Types::Strict::Hash, default: proc { {} }, optional: true
  option :value, type: ZATCA::Types::Coercible::String, default: proc { "" }, optional: true
  option :name, type: ZATCA::Types::Strict::String, default: proc { "" }, optional: true
  option :index, type: ZATCA::Types::Coercible::Integer.optional, default: proc {}, optional: true

  # def initialize(elements: [], attributes: {}, value: "", name: "", index: nil)
  # @elements = elements
  # @attributes = attributes
  # @value = value
  # @name = name

  # # HACK: Add a nil index property to be used for cases where we need
  # # sequential IDs, this list can be populated after the array is built
  # @index = index
  # end

  # There are cases where we end up constructing elements with no content
  # and we don't want to include them in the final XML.
  #
  # This method helps us to return nil if the element has no attributes,
  # elements or value.
  #
  # which is then caught in the `build_xml` method (using `elements.compact`)
  # and ignored.
  def self.build(elements: [], attributes: {}, value: "", name: "", index: nil)
    return nil if elements.blank? && attributes.blank? && value.blank?

    new(elements: elements, attributes: attributes, value: value, name: name, index: index)
  end

  def [](name)
    elements.find { |element| element.name == name }
  end

  def dig(key, *args)
    value = self[key]
    return value if args.length == 0 || value.nil?
    # DigRb.guard_dig(value)
    value.dig(*args)
  end

  # TODO: Under Active Development
  def find_nested_element_by_path(path)
    path_parts = path.split("/")
    nested_element = self

    path_parts.each_with_index do |path_part, index|
      # byebug
      # next_path_part = path_parts[index + 1]
      # found_element = nested_element[path_part]
      # found_next_path_part = found_element[next_path_part]

      # element_with_next_path_part = found_element.find do |child_element|
      #   child_element.name == next_path_part
      # end
      # byebug
      # nested_element.elements.each do |element|
      #   byebug
      #   next_element = element[path_part]

      #   if next_element && next_element[next_path_part]
      #     nested_element = next_element[next_path_part]
      #     break
      #   elsif next_element.present?
      #     nested_element = next_element
      #   end
      # end

      # nested_element = found_element if found_element.present?
    end

    nested_element
  end

  def schema
    self.class.schema
  end

  def to_h
    {
      name => {
        attributes: attributes,
        **elements.map(&:to_h),
        value: value
      }
    }
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
        elements.compact.each { |element| element.build_xml(xml) }
      elsif value.present?
        xml.text(value)
      end
    end
  end

  def generate_xml(
    canonicalized: false,
    spaces: 2,
    apply_invoice_hacks: false,
    remove_root_xml_tag: false
  )
    ZATCA::UBL::Builder.new(element: self).build(
      canonicalized: canonicalized,
      spaces: spaces,
      apply_invoice_hacks: apply_invoice_hacks,
      remove_root_xml_tag: remove_root_xml_tag
    )
  end
end
