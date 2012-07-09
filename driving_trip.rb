class DrivingTrip

  attr_reader :origin, :destination, :time

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @time = Maps.new.duration
  end



end

class Maps
end