describe ZATCA::UBL::Invoice do
  context "simplified invoice" do
    it "should generate xml that matches ZATCA's" do
      invoice = construct_simplified_invoice
      zatca_xml = read_xml_fixture("simplified_invoice_signed.xml")

      expect(invoice.generate_xml).to eq(zatca_xml)
    end

    it "should be able to create an unsigned invoice qr-less invoice then add them later" do
      invoice = construct_unsigned_simplified_invoice

      # Hash the invoice
      invoice_hash = invoice.generate_hash

      # Parse the private key
      # We need to specifically decode the key because ZATCA's sample key is Base64 encoded
      private_key_path = private_key_fixtures_path("private_key.pem")
      private_key = ZATCA::Signing::Encrypting.parse_private_key(key_path: private_key_path, decode_from_base64: true)

      # Sign the invoice hash using the private key
      signature = ZATCA::Signing::Encrypting.encrypt_with_ecdsa(
        content: invoice_hash,
        private_key: private_key
      )

      # Parse and hash the certificate
      certificate_path = certificate_path("certificate.pem")
      parsed_certificate = ZATCA::Signing::Certificate.read_certificate(certificate_path)

      # Hash signed properties
      signing_time = "2022-08-10T17:44:09Z"
      signed_properties = ZATCA::UBL::Signing::SignedProperties.new(
        signing_time: signing_time,
        cert_digest_value: parsed_certificate.hash,
        cert_issuer_name: parsed_certificate.issuer_name,
        cert_serial_number: parsed_certificate.serial_number
      )

      signature_properties_digest = signed_properties.generate_hash

      # Create the signature element using the certficiate, invoice hash, and signed properties hash
      signature_element = ZATCA::UBL::Signing::Signature.new(
        invoice_digest_value: invoice_hash,
        signature_properties_digest: signature_properties_digest,
        signature_value: signature,
        certificate: parsed_certificate.cert_content_without_headers,
        signing_time: signing_time,
        cert_digest_value: parsed_certificate.hash,
        cert_issuer_name: parsed_certificate.issuer_name,
        cert_serial_number: parsed_certificate.serial_number
      )

      invoice.signature = signature_element

      # Create a QR Code
      tags = ZATCA::Tags.new({
        seller_name: "Ahmed Mohamed AL Ahmady",
        vat_registration_number: "301121971500003",
        timestamp: "2022-08-10T17:44:09+03:00",
        vat_total: "144.90",
        invoice_total: "1108.90",
        xml_invoice_hash: invoice_hash,
        ecdsa_signature: signature,
        ecdsa_public_key: parsed_certificate.public_key,
        ecdsa_stamp_signature: parsed_certificate.hash
      })

      invoice.qr_code = tags.to_base64

      zatca_xml = read_xml_fixture("simplified_invoice_signed.xml")
      generated_xml = invoice.generate_xml
      File.write("TEST_ME_WITH_ZATCA.xml", generated_xml)

      expect(generated_xml).to eq(zatca_xml)
    end
  end

  context "standard invoice" do
    # There are a few things manually modified in this fixture:
    # 1. ZATCA incorrectly has the signature algorithm set to:
    # <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
    # when in reality it is:
    # <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#ecdsa-sha256"/>
    #
    # 2. Using short form of value-less/child-less tags for Signature Value
    # In original ZATCA sample it is:
    # <ds:SignatureValue></ds:SignatureValue>
    # In our modified version it is:
    # <ds:SignatureValue/>
    #
    # 3. Inside of TaxCategory for the standard invoice, ZATCA doesn't include the
    # schemeAgencyID or schemeID, but we retain them here as in the simplified
    # invoice
    #
    # ZATCA:
    # <cac:TaxCategory>
    #        <cbc:ID>S</cbc:ID>
    #
    # Our version:
    # <cac:TaxCategory>
    #        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
    it "should generate xml that matches ZATCA's" do
      invoice = construct_standard_invoice
      zatca_xml = read_xml_fixture("standard_invoice.xml")

      expect(invoice.generate_xml).to eq(zatca_xml)
    end
  end
end
