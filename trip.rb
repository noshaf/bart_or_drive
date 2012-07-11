require_relative './maps.rb'

class Trip
  attr_reader :origin, :destination
  def initialize(origin, destination, user)
    @origin = origin
    @destination = destination
    @user = user
  end

  def comparison
    if transit_time < driving_time
      "Take Transit. It's #{(driving_time-transit_time)/60} minutes faster."
    elsif transit_time > driving_time
      "Drive. It's #{(transit_time-driving_time)/60} minutes faster."
    else
      "Driving time and transit time are equal."
    end
  end

  def time(mode)
    Query::Maps.new({:origin => @origin, :destination => @destination,:mode=> mode }).duration
  end

  def transit_time
    time('transit')
  end

  def driving_time
    time('driving') + @user.environmental_pref
  end
end
