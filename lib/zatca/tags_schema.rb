require "dry-schema"

module ZATCA
  TagsSchema = Dry::Schema.Params do
    required(:seller_name).filled(:string)
    required(:vat_registration_number).filled(:string)

    required(:timestamp).filled([:date_time, :string])

    # Using strings to avoid any floating point approximations, we're not doing
    # any calculations with these values, it's for display purposes only. A
    # string is a good fit.
    required(:invoice_total).filled(:string)
    required(:vat_total).filled(:string)

    # TODO: Data types required by 1 January 2023
    # - Hash of XML Invoice
    # - ECDSA signature
    # - ECDSA public key
    # - ECDSA signature of the cryptographic stamp’s public key by ZATCA’s technical CA
  end
end
