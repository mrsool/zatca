class ZATCA::UBL::CommonAggregateComponents::PartyIdentification < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  SCHEMA = Dry::Schema.Params do
    required(:id).filled(:string)
    required(:scheme_id).filled(:string)
  end

  def initialize(id:, scheme_id: "CRN")
    super()

    @id = id
    @scheme_id = scheme_id
  end

  def name
    "cac:PartyIdentification"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:ID", value: @id, attributes: {"schemeID" => @scheme_id})
    ]
  end
end
