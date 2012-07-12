require_relative './maps.rb'

class Trip
  attr_reader :origin, :destination
  def initialize(origin, destination, user)
    @origin = origin
    @destination = destination
    @user = user
    @transit_time = transit_time
    @driving_time = driving_time
  end

  def comparison
    if @transit_time < @driving_time
      "Take Transit."
    elsif @transit_time > @driving_time
      "Drive."
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
    time('driving') + (@user.environmental_pref*60)
  end
end
