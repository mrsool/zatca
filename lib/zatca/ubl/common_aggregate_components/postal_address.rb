class ZATCA::UBL::CommonAggregateComponents::PostalAddress
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
    required(:country).value(type?: ZATCA::UBL::CommonAggregateComponents::Country)
  end

  def initialize(
    street_name:, additional_street_name:, building_number:,
    plot_identification:, city_subdivision_name:, city_name:, postal_zone:,
    country_subentity:, country:
  )
    @street_name = street_name
    @additional_street_name = additional_street_name
    @building_number = building_number
    @plot_identification = plot_identification
    @city_subdivision_name = city_subdivision_name
    @city_name = city_name
    @postal_zone = postal_zone
    @country_subentity = country_subentity
    @country = country
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:StreetName", value: @street_name),
      ZATCA::UBL::BaseComponent.new(name: "cbc:AdditionalStreetName", value: @additional_street_name),
      ZATCA::UBL::BaseComponent.new(name: "cbc:BuildingNumber", value: @building_number),
      ZATCA::UBL::BaseComponent.new(name: "cbc:PlotIdentification", value: @plot_identification),
      ZATCA::UBL::BaseComponent.new(name: "cbc:CitySubdivisionName", value: @city_subdivision_name),
      ZATCA::UBL::BaseComponent.new(name: "cbc:CityName", value: @city_name),
      ZATCA::UBL::BaseComponent.new(name: "cbc:PostalZone", value: @postal_zone),
      ZATCA::UBL::BaseComponent.new(name: "cbc:CountrySubentity", value: @country_subentity),
      @country
    ]
  end
end
