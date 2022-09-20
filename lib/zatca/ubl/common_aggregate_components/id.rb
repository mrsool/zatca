class ZATCA::UBL::CommonAggregateComponents::ID < ZATCA::UBL::BaseComponent
  attr_accessor :scheme_id, :id

  SCHEMA = Dry::Schema.Params do
    required(:id).filled(:string)
    required(:scheme_id).filled(:string)
  end

  def initialize(id:, scheme_id: "NAT")
    super()

    @id = id
    @scheme_id = scheme_id
    @name = "cac:ID"
    @attributes = {"schemeID" => @scheme_id}
    @value = @id
  end
end
