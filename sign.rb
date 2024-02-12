require 'nokogiri'
require 'digest'
require 'base64'
require 'zatca'
require 'json'

if ARGV.length < 3
  puts "Usage: ruby script.rb ubl_xml_file private_key_path certificate_path"
  exit
end

xml_file_path = ARGV[0]
private_key_path = ARGV[1]
certificate_path = ARGV[2]

unless File.exist?(xml_file_path)
  puts "Error: #{xml_file_path} does not exist."
  exit
end

unless File.exist?(private_key_path)
  puts "Error: #{private_key_path} does not exist."

begin
  doc = File.open(xml_file_path) { |f| Nokogiri::XML(f) }
rescue => e
  puts "Can't open file as xml: #{e.message}"
  exit
end

canonicalized_content = doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)

sha256 = Digest::SHA256.digest(canonicalized_content)
hexdigestHash = Digest::SHA256.hexdigest(canonicalized_content)
hash_base64 = Base64.strict_encode64(sha256)

signing_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S")
signing_time = signing_time.delete_suffix("Z")

signature = ZATCA::Signing::ECDSA.sign(
      content: hexdigestHash,
      private_key_path: private_key_path,
      decode_from_base64: false
    );

signed_hash = signature[:base64]
signed_hash_bytes = signature[:bytes]
parsed_certificate = ZATCA::Signing::Certificate.read_certificate(certificate_path)
public_key_bytes = parsed_certificate.public_key_bytes
certificate_signature = parsed_certificate.signature

signed_properties_hash = ZATCA::UBL::Signing::SignedProperties.new(
      signing_time: signing_time,
      cert_digest_value: parsed_certificate.hash,
      cert_issuer_name: parsed_certificate.issuer_name,
      cert_serial_number: parsed_certificate.serial_number
    ).generate_hash

valeurs = {
  "{{invoice_digest}}" => parsed_certificate.hash,
  "{{signed_properties_hash}}" => signed_properties_hash,
  "{{signature_value}}" => signed_hash,
  "{{certificate}}" => parsed_certificate.cert_content_without_headers,
  "{{signing_time}}"=>signing_time,
  "{{cert_digest_value}}"=>parsed_certificate.hash,
  "{{cert_issuer_name}}"=>parsed_certificate.issuer_name,
  "{{cert_serial_number}}"=>parsed_certificate.serial_number
}

contenu_template_signature = File.read(File.join(__dir__, 'signature_extensions_hack.xml.tpl'))
valeurs.each do |placeholder, valeur|
  contenu_template_signature.gsub!(placeholder, valeur)
end

final_content = canonicalized_content ;
final_content.sub!("<cbc:ProfileID>", "#{contenu_template_signature}<cbc:ProfileID>")
strXmlStaticElement = "<cac:Signature><cbc:ID>urn:oasis:names:specification:ubl:signature:Invoice</cbc:ID><cbc:SignatureMethod>urn:oasis:names:specification:ubl:dsig:enveloped:xades</cbc:SignatureMethod></cac:Signature>" ;
final_content.sub!("<cac:AccountingSupplierParty>", "#{strXmlStaticElement}<cac:AccountingSupplierParty>")

puts {
       hash: hash_base64,
       signedb64: Base64.strict_encode64(final_content)
}.to_json
