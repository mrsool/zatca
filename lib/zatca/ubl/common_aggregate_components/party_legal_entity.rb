class ZATCA::UBL::CommonAggregateComponents::PartyLegalEntity < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  def initialize(registration_name:)
    super()

    @registration_name = registration_name
  end

  def name
    "cac:PartyLegalEntity"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.build(name: "cbc:RegistrationName", value: @registration_name)
    ]
  end
end
