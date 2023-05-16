class ZATCA::UBL::CommonAggregateComponents::PostalAddress < ZATCA::UBL::BaseComponent
  attr_accessor :street_name,
    :additional_street_name,
    :building_number,
    :plot_identification,
    :city_subdivision_name,
    :city_name,
    :postal_zone,
    :country_subentity,
    :country

  SCHEMA = Dry::Schema.Params do
    required(:street_name).filled(:string)
    required(:additional_street_name).filled(:string)
    required(:building_number).filled(:string)
    required(:plot_identification).filled(:string)
    required(:city_subdivision_name).filled(:string)
    required(:city_name).filled(:string)
    required(:postal_zone).filled(:string)
    required(:country_subentity).filled(:string)
    required(:country_identification_code).filled(:string)
  end

  def initialize(
    street_name:, building_number:, plot_identification:,
    city_subdivision_name:, city_name:, postal_zone:, country_subentity:,
    additional_street_name: nil, country_identification_code: "SA"
  )
    @street_name = street_name
    @additional_street_name = additional_street_name
    @building_number = building_number
    @plot_identification = plot_identification
    @city_subdivision_name = city_subdivision_name
    @city_name = city_name
    @postal_zone = postal_zone
    @country_subentity = country_subentity
    @country_identification_code = country_identification_code
  end

  def name
    "cac:PostalAddress"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.build(name: "cbc:StreetName", value: @street_name),
      ZATCA::UBL::BaseComponent.build(name: "cbc:AdditionalStreetName", value: @additional_street_name),
      ZATCA::UBL::BaseComponent.build(name: "cbc:BuildingNumber", value: @building_number),
      ZATCA::UBL::BaseComponent.build(name: "cbc:PlotIdentification", value: @plot_identification),
      ZATCA::UBL::BaseComponent.build(name: "cbc:CitySubdivisionName", value: @city_subdivision_name),
      ZATCA::UBL::BaseComponent.build(name: "cbc:CityName", value: @city_name),
      ZATCA::UBL::BaseComponent.build(name: "cbc:PostalZone", value: @postal_zone),
      ZATCA::UBL::BaseComponent.build(name: "cbc:CountrySubentity", value: @country_subentity),
      ZATCA::UBL::BaseComponent.build(name: "cac:Country", elements: [
        ZATCA::UBL::BaseComponent.build(name: "cbc:IdentificationCode", value: @country_identification_code)
      ])
    ]
  end
end
