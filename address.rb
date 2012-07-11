class Address
  attr_reader :location_name, :description
  def initialize(location_name,description)
    @location_name = location_name
    @description = description
  end

end