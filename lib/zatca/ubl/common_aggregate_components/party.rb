class ZATCA::UBL::CommonAggregateComponents::Party < ZATCA::UBL::BaseComponent
  # Has:
  # PartyIdentification
  # PostalAddress
  # PartyTaxScheme
  # PartyLegalEntity
  def initialize(party_identification:, postal_address:, party_tax_scheme:, party_legal_entity:)
    super()

    @party_identification = party_identification
    @postal_address = postal_address
    @party_tax_scheme = party_tax_scheme
    @party_legal_entity = party_legal_entity
  end

  def name
    "cac:Party"
  end

  def elements
    [
      @party_identification,
      @postal_address,
      @party_tax_scheme,
      @party_legal_entity
    ]
  end
end
