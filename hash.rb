require 'nokogiri'
require 'digest'
require 'base64'

if ARGV.empty?
  puts "Please specify ubl xml file path as argument"
  exit
end

xml_file_path = ARGV[0]

begin
  doc = File.open(xml_file_path) { |f| Nokogiri::XML(f) }
rescue => e
  puts "Can't open file as xml: #{e.message}"
  exit
end

canonicalized_content = doc.canonicalize(Nokogiri::XML::XML_C14N_1_1)
sha256 = Digest::SHA256.digest(canonicalized_content)
hash_base64 = Base64.strict_encode64(sha256)

puts {
            hash: hash_base64
 }.to_json
