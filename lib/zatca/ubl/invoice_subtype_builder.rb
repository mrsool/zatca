module ZATCA::UBL::InvoiceSubtypeBuilder
  extend self

  # Builds the invoice subtype code based on the provided parameters.
  #
  # @param simplified [Boolean] Specifies whether the invoice is a simplified tax invoice.
  # @param third_party [Boolean] Specifies whether the invoice is a third-party invoice transaction.
  # @param nominal [Boolean] Specifies whether the invoice is a nominal invoice transaction.
  # @param exports [Boolean] Specifies whether the invoice is an exports invoice transaction.
  # @param summary [Boolean] Specifies whether the invoice is a summary invoice transaction.
  # @param self_billed [Boolean] Specifies whether the invoice is a self-billed invoice.
  # @return [String] The generated invoice subtype code.
  #
  # @example
  #   InvoiceSubtypeBuilder.build(
  #     simplified: true,
  #     third_party: false,
  #     nominal: true,
  #     exports: false,
  #     summary: false,
  #     self_billed: true
  #   )
  #   # => "0201001"
  #
  #   InvoiceSubtypeBuilder.build(
  #     simplified: false,
  #     third_party: true,
  #     nominal: true,
  #     exports: true,
  #     summary: true,
  #     self_billed: false
  #   )
  #   # => "0101110"
  #
  def build(
    simplified:,
    third_party:,
    nominal:,
    exports:,
    summary:,
    self_billed:
  )
    subtype_prefix = simplified ? "02" : "01"

    values = [third_party, nominal, exports, summary, self_billed]
    values = values.map { |v| v ? "1" : "0" }

    subtype_prefix + values.join
  end
end
