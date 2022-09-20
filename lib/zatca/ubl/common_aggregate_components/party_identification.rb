class ZATCA::UBL::CommonAggregateComponents::PartyIdentification < ZATCA::UBL::BaseComponent
  attr_reader :scheme_id, :id

  SCHEMA = Dry::Schema.Params do
    required(:id).filled(:string)
    required(:scheme_id).filled(:string)
  end

  def initialize(id:, scheme_id: "NAT")
    super()

    @id = id
    @scheme_id = scheme_id

    @name = "cac:PartyIdentification"
    @elements = [
      ZATCA::UBL::CommonAggregateComponents::ID.new(id: @id, scheme_id: @scheme_id)
    ]
  end
end
