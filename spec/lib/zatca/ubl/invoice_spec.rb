describe ZATCA::UBL::Invoice do
  def construct_simplified_invoice
    signature = ZATCA::UBL::Signing::Signature.new(
      invoice_digest_value: "QnVEexW4nWv4CaE39a/66Jp/OXO/evHQ8pDlG7weq/4=",
      signature_properties_digest: "YzBjNDk5M2I1MDQyM2NkZjBhYjZiZDIzOGE1ZWU4NTFmODY4Nzk2NzA3NjJkM2ZlNDFmNDMyZjMyMzkyNzQxMA==",
      signature_value: "MEYCIQC9Ke7rU0G+lw1jBtDY1UnGVKfHh0ROAdRn554pEXNbUAIhAPzKiwpPSWHyCK/n40QFvlAsGWlS6t/eRAcfMGWueYPO",
      certificate: "MIID9jCCA5ugAwIBAgITbwAAeCy9aKcLA99HrAABAAB4LDAKBggqhkjOPQQDAjBjMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNnb3YxFzAVBgoJkiaJk/IsZAEZFgdleHRnYXp0MRwwGgYDVQQDExNUU1pFSU5WT0lDRS1TdWJDQS0xMB4XDTIyMDQxOTIwNDkwOVoXDTI0MDQxODIwNDkwOVowWTELMAkGA1UEBhMCU0ExEzARBgNVBAoTCjMxMjM0NTY3ODkxDDAKBgNVBAsTA1RTVDEnMCUGA1UEAxMeVFNULS05NzA1NjAwNDAtMzEyMzQ1Njc4OTAwMDAzMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEYYMMoOaFYAhMO/steotfZyavr6p11SSlwsK9azmsLY7b1b+FLhqMArhB2dqHKboxqKNfvkKDePhpqjui5hcn0aOCAjkwggI1MIGaBgNVHREEgZIwgY+kgYwwgYkxOzA5BgNVBAQMMjEtVFNUfDItVFNUfDMtNDdmMTZjMjYtODA2Yi00ZTE1LWIyNjktN2E4MDM4ODRiZTljMR8wHQYKCZImiZPyLGQBAQwPMzEyMzQ1Njc4OTAwMDAzMQ0wCwYDVQQMDAQxMTAwMQwwCgYDVQQaDANUU1QxDDAKBgNVBA8MA1RTVDAdBgNVHQ4EFgQUO5ZiU7NakU3eejVa3I2S1B2sDwkwHwYDVR0jBBgwFoAUdmCM+wagrGdXNZ3PmqynK5k1tS8wTgYDVR0fBEcwRTBDoEGgP4Y9aHR0cDovL3RzdGNybC56YXRjYS5nb3Yuc2EvQ2VydEVucm9sbC9UU1pFSU5WT0lDRS1TdWJDQS0xLmNybDCBrQYIKwYBBQUHAQEEgaAwgZ0wbgYIKwYBBQUHMAGGYmh0dHA6Ly90c3RjcmwuemF0Y2EuZ292LnNhL0NlcnRFbnJvbGwvVFNaRWludm9pY2VTQ0ExLmV4dGdhenQuZ292LmxvY2FsX1RTWkVJTlZPSUNFLVN1YkNBLTEoMSkuY3J0MCsGCCsGAQUFBzABhh9odHRwOi8vdHN0Y3JsLnphdGNhLmdvdi5zYS9vY3NwMA4GA1UdDwEB/wQEAwIHgDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwMwJwYJKwYBBAGCNxUKBBowGDAKBggrBgEFBQcDAjAKBggrBgEFBQcDAzAKBggqhkjOPQQDAgNJADBGAiEA7mHT6yg85jtQGWp3M7tPT7Jk2+zsvVHGs3bU5Z7YE68CIQD60ebQamYjYvdebnFjNfx4X4dop7LsEBFCNSsLY0IFaQ==",
      signing_time: "2022-08-10T17:44:09Z",
      cert_digest_value: "NjlhOTVmYzIzN2I0MjcxNGRjNDQ1N2EzM2I5NGNjNDUyZmQ5ZjExMDUwNGM2ODNjNDAxMTQ0ZDk1NDQ4OTRmYg==",
      cert_issuer_name: "CN=TSZEINVOICE-SubCA-1, DC=extgazt, DC=gov, DC=local",
      cert_serial_number: "2475382876776561391517206651645660279462721580"
    )

    invoice_id = "SME00062"
    invoice_uuid = "6f4d20e0-6bfe-4a80-9389-7dabe6620f12"
    issue_date = "2022-03-13"
    issue_time = "14:40:40"
    invoice_type_mask = "0211010"
    invoice_type_code_value = "388"

    invoice_counter_value = "62"
    previous_invoice_hash = "NWZlY2ViNjZmZmM4NmYzOGQ5NTI3ODZjNmQ2OTZjNzljMmRiYzIzOWRkNGU5MWI0NjcyOWQ3M2EyN2ZiNTdlOQ=="
    qr_code = "ARdBaG1lZCBNb2hhbWVkIEFMIEFobWFkeQIPMzAxMTIxOTcxNTAwMDAzAxQyMDIyLTAzLTEzVDE0OjQwOjQwWgQHMTEwOC45MAUFMTQ0LjkGLFFuVkVleFc0bld2NENhRTM5YS82NkpwL09YTy9ldkhROHBEbEc3d2VxLzQ9B2BNRVlDSVFDOUtlN3JVMEcrbHcxakJ0RFkxVW5HVktmSGgwUk9BZFJuNTU0cEVYTmJVQUloQVB6S2l3cFBTV0h5Q0svbjQwUUZ2bEFzR1dsUzZ0L2VSQWNmTUdXdWVZUE8IWDBWMBAGByqGSM49AgEGBSuBBAAKA0IABGGDDKDmhWAITDv7LXqLX2cmr6+qddUkpcLCvWs5rC2O29W/hS4ajAK4Qdnahym6MaijX75Cg3j4aao7ouYXJ9EJSDBGAiEA7mHT6yg85jtQGWp3M7tPT7Jk2+zsvVHGs3bU5Z7YE68CIQD60ebQamYjYvdebnFjNfx4X4dop7LsEBFCNSsLY0IFaQ=="

    accounting_supplier_party = ZATCA::UBL::CommonAggregateComponents::Party.new(
      party_identification: ZATCA::UBL::CommonAggregateComponents::PartyIdentification.new(
        id: "454634645645654"
      ),
      postal_address: ZATCA::UBL::CommonAggregateComponents::PostalAddress.new(
        street_name: "test",
        additional_street_name: nil,
        building_number: "3454",
        plot_identification: "1234",
        city_subdivision_name: "fgff",
        city_name: "Riyadh",
        postal_zone: "12345",
        country_subentity: "test",
        country_identification_code: "SA"
      ),

      party_tax_scheme: ZATCA::UBL::CommonAggregateComponents::PartyTaxScheme.new(
        company_id: "301121971500003"
      ),

      party_legal_entity: ZATCA::UBL::CommonAggregateComponents::PartyLegalEntity.new(
        registration_name: "Ahmed Mohamed AL Ahmady"
      )
    )

    accounting_customer_party = ZATCA::UBL::CommonAggregateComponents::Party.new(
      party_identification: ZATCA::UBL::CommonAggregateComponents::PartyIdentification.new(
        id: "2345",
        scheme_id: "NAT"
      ),
      postal_address: ZATCA::UBL::CommonAggregateComponents::PostalAddress.new(
        street_name: "baaoun",
        additional_street_name: "sdsd",
        building_number: "3353",
        plot_identification: "3434",
        city_subdivision_name: "fgff",
        city_name: "Dhurma",
        postal_zone: "34534",
        country_subentity: "ulhk",
        country_identification_code: "SA"
      ),

      party_tax_scheme: ZATCA::UBL::CommonAggregateComponents::PartyTaxScheme.new,
      party_legal_entity: ZATCA::UBL::CommonAggregateComponents::PartyLegalEntity.new(
        registration_name: "sdsa"
      )
    )

    delivery = ZATCA::UBL::CommonAggregateComponents::Delivery.new(
      actual_delivery_date: "2022-03-13",
      latest_delivery_date: "2022-03-15"
    )

    payment_means_code = "10"

    allowance_charges = [
      ZATCA::UBL::CommonAggregateComponents::AllowanceCharge.new(
        charge_indicator: false,
        amount: "2",
        allowance_charge_reason: "discount",
        currency_id: "SAR",
        tax_category: ZATCA::UBL::CommonAggregateComponents::TaxCategory.new(
          tax_percent: "15"
        )
      )

      # ZATCA::UBL::CommonAggregateComponents::AllowanceCharge.new(
      #   charge_indicator: false,
      #   amount: 5,
      #   allowance_charge_reason: "discount",
      #   currency_id: "SAR"
      # )
    ]

    tax_totals = [
      ZATCA::UBL::CommonAggregateComponents::TaxTotal.new(
        tax_amount: "144.9",
        tax_subtotal_amount: "144.90",
        taxable_amount: "966.00",
        tax_category: ZATCA::UBL::CommonAggregateComponents::TaxCategory.new(
          tax_percent: "15.00"
        )
      ),

      ZATCA::UBL::CommonAggregateComponents::TaxTotal.new(
        tax_amount: "144.9"
      )
    ]

    legal_monetary_total = ZATCA::UBL::CommonAggregateComponents::LegalMonetaryTotal.new(
      line_extension_amount: "966.00",
      tax_exclusive_amount: "964.00",
      tax_inclusive_amount: "1108.90",
      allowance_total_amount: "2.00",
      prepaid_amount: "0.00",
      payable_amount: "1108.90"
    )

    invoice_lines = [
      ZATCA::UBL::CommonAggregateComponents::InvoiceLine.new(
        id: "1",
        invoiced_quantity: "44.000000",
        invoiced_quantity_unit_code: "PCE",
        line_extension_amount: "966.00",
        tax_total: ZATCA::UBL::CommonAggregateComponents::TaxTotal.new(
          tax_amount: "144.90",
          rounding_amount: "1110.90"
        ),
        item: ZATCA::UBL::CommonAggregateComponents::Item.new(
          name: "dsd"
        ),
        price: ZATCA::UBL::CommonAggregateComponents::Price.new(
          price_amount: "22.00",
          allowance_charge: ZATCA::UBL::CommonAggregateComponents::AllowanceCharge.new(
            charge_indicator: false,
            allowance_charge_reason: "discount",
            amount: "2.00",
            add_tax_category: false,
            add_id: false
          )
        )
      )
    ]

    currency_code = "SAR"

    ZATCA::UBL::Invoice.new(
      signature: signature,
      id: invoice_id,
      uuid: invoice_uuid,
      issue_date: issue_date,
      issue_time: issue_time,
      invoice_type_mask: invoice_type_mask,
      invoice_type_code_value: invoice_type_code_value,
      invoice_counter_value: invoice_counter_value,
      previous_invoice_hash: previous_invoice_hash,
      qr_code: qr_code,
      accounting_supplier_party: accounting_supplier_party,
      accounting_customer_party: accounting_customer_party,
      delivery: delivery,
      payment_means_code: payment_means_code,
      allowance_charges: allowance_charges,
      tax_totals: tax_totals,
      legal_monetary_total: legal_monetary_total,
      invoice_lines: invoice_lines,
      currency_code: currency_code
    )
  end

  context "simplified invoice" do
    it "should generate xml that matches ZATCA's" do
      invoice = construct_simplified_invoice
      builder = ZATCA::UBL::Builder.new(element: invoice)
      xml = builder.build

      zatca_xml = read_xml_fixture("simplified-invoice-signed.xml")

      expect(xml).to eq(zatca_xml)
    end
  end
end
