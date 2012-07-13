require_relative './maps.rb'

class Trip
  attr_reader :origin, :destination, :driving_time, :transit_time
  def initialize(origin, destination)#, user)
    @origin = origin
    @destination = destination
    #@user = user
    @driving_time = time('driving')
    @transit_time = time('transit')
  end

  def comparison
    if adjusted_transit_time < adjusted_driving_time
      "Take Transit."
    elsif adjusted_transit_time > adjusted_driving_time
      "Drive."
    else
      "Driving time and transit time are equal."
    end
  end

  def time(mode)
    Query::Maps.new({:origin => @origin, :destination => @destination,:mode=> mode }).duration
  end

  def adjusted_driving_time
    @driving_time# + (@user.transit_tolerance_in_minutes*60)
  end

  def adjusted_transit_time
    @transit_time
  end
end
