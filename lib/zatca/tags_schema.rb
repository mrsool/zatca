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

    # Data types required for Phase 2 by 1 January 2023
    optional(:xml_invoice_hash).filled(:string)
    optional(:ecdsa_signature).filled(:string)
    optional(:ecdsa_public_key).filled(:string)
    optional(:ecdsa_stamp_signature).filled(:string)
  end
end
