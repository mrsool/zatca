require "active_support"

class ZATCA::UBL::Builder
  extend Dry::Initializer

  option :element, type: ZATCA::Types.Instance(ZATCA::UBL::BaseComponent)

  def build(
    canonicalized: false,
    spaces: 4,
    apply_invoice_hacks: false,
    remove_root_xml_tag: false
  )
    @remove_root_xml_tag = remove_root_xml_tag

    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      element.build_xml(xml)
    end

    xml = if canonicalized
      canonicalized_xml(builder: builder)
    else
      uncanonicalized_xml(builder: builder, spaces: spaces)
    end

    xml = apply_hacks_to_invoice(element, xml) if apply_invoice_hacks

    xml
  end

  private

  # ZATCA sadly requires very specific and unconventional indentation in the XML
  # when it is pretty (uncanonicalized), the only way we can accomplish this is
  # to find and replace blocks manually.
  def apply_hacks_to_invoice(element, xml)
    return xml unless element.is_a?(ZATCA::UBL::Invoice)

    apply_qualifying_properties_hacks(element, xml)
  end

  def apply_qualifying_properties_hacks(invoice, xml)
    return xml if invoice.qualifying_properties.blank?

    regex = ZATCA::Hacks.qualifying_properties_regex

    xml.gsub(regex, invoice.qualifying_properties)
  end

  # This function does not produce canonicalization matching C14N 1.1, it applies
  # C14N 1.1 then manually adds back the whitespace in the format that ZATCA
  # expects.
  def canonicalized_xml(builder:)
    builder.doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)

    # TODO: In case ZATCA ever asks us to use their whitespace format again.
    # In some meetings they say we have to use it, in some meetings they say
    # we don't. The simpler approach is that we don't use it.
    #
    # ZATCA's docs specifically state we must use C14N 1.1 canonicalization.
    # xml = uncanonicalized_xml(builder: builder, spaces: 4)
    # xml_doc = Nokogiri::XML(xml)

    # canonical_xml = xml_doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)

    # canonical_xml
  end

  def uncanonicalized_xml(builder:, spaces: 4)
    builder.to_xml(indent: spaces.to_i)

    # xml = builder.to_xml(indent: spaces.to_i)
    # xml = match_xml_string_to_zatca_whitespaces(xml)
    # xml
  end

  def match_xml_string_to_zatca_whitespaces(xml)
    # ZATCA has elements that are not spaced by multiples of 4, and random new
    # lines with trailing whitespaces, so we need to manually adjust our
    # indentation to match ZATCA's.
    zatca_weird_whitespaces.each do |whitespace_hash|
      xml.gsub!(whitespace_hash[:our_version], whitespace_hash[:zatca_version])
    end

    # Canonicalization already removes the root XML tag for us, but since we had
    # to create a new uncanonicalized document for ZATCA's invoice hacks, we
    # have to remove it manually.
    if @remove_root_xml_tag
      xml.gsub!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", "")
    end

    # ZATCA Removes the final newline character, so we do the same
    xml.chomp

    # This part is not clear, ZATCA shared documents with us that use CRLF
    # but the samples in the SDK use LF, so we're not sure which one is correct.
    # ZATCA wants CRLF (\r\n) in their canonicalized form instead of just LF (\n)
    xml.gsub!("\n", "\r\n")

    xml
  end

  # Not sure if this is needed, in some meetings ZATCA says you have to match
  # their whitspace exactly and in some meetings they say you don't.
  # HACK: This is really hacky, using regexes or XPaths would be better, but
  # that wasn't easy to build and maintain, so we're using this if/until we run
  # into issues.
  #
  # We may eventually go to an approach where we just have hardcoded XML in each
  # element's file and we just add in the values instead of generating our own
  # XML if this gets too hard to maintain.
  def zatca_weird_whitespaces
    @_zatca_weird_whitespaces ||= [
      {
        our_version: "<cbc:ProfileID>",
        zatca_version: "\n    <cbc:ProfileID>"
      },
      {
        our_version: "<cac:AccountingSupplierParty>",
        zatca_version: "\n    \n    <cac:AccountingSupplierParty>"
      },
      {
        our_version: "                <cbc:CompanyID>",
        zatca_version: "                    <cbc:CompanyID>"
      },
      {
        our_version: "            <cac:TaxCategory>",
        zatca_version: "             <cac:TaxCategory>"
      },
      {
        our_version: "            </cac:TaxCategory>",
        zatca_version: "             </cac:TaxCategory>"
      },
      {
        our_version: '                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>',
        zatca_version: '                 <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>'
      },
      {
        our_version: "<cac:TaxScheme>\n                    <cbc:ID schemeAgencyID=\"6\" schemeID=\"UN/ECE 5153\">VAT</cbc:ID>",
        zatca_version: "<cac:TaxScheme>\n                   <cbc:ID schemeAgencyID=\"6\" schemeID=\"UN/ECE 5153\">VAT</cbc:ID>"
      },
      {
        our_version: "<cac:TaxTotal>\n            <cbc:TaxAmount currencyID=\"SAR\">",
        zatca_version: "<cac:TaxTotal>\n             <cbc:TaxAmount currencyID=\"SAR\">"
      },
      {
        our_version: "            <cbc:RoundingAmount currencyID=\"SAR\">",
        zatca_version: "             <cbc:RoundingAmount currencyID=\"SAR\">"
      },
      {
        our_version: "                <cbc:ChargeIndicator>",
        zatca_version: "               <cbc:ChargeIndicator>"
      },
      {
        our_version: "                <cbc:AllowanceChargeReason>",
        zatca_version: "               <cbc:AllowanceChargeReason>"
      },
      {
        our_version: "                <cbc:Amount currencyID=\"SAR\">",
        zatca_version: "               <cbc:Amount currencyID=\"SAR\">"
      },
      {
        our_version: "<cbc:ID schemeAgencyID=\"6\" schemeID=\"UN/ECE 5305\">S</cbc:ID>\n                <cbc:Percent>",
        zatca_version: "<cbc:ID schemeAgencyID=\"6\" schemeID=\"UN/ECE 5305\">S</cbc:ID>\n                 <cbc:Percent>"
      }
    ]
  end
end
