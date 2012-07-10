require_relative './maps.rb'

class Trip

  attr_reader :origin, :destination, :driving_time, :transit_time

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @driving_time = time('driving')
    @transit_time = time('transit')
  end

  def comparison
    if @driving_time < @transit_time
      "Take BART."
    elsif @transit_time > @driving_time
      "Drive."
    else
      "Driving time and transit time are equal."
    end
  end

  def time(mode)
    Query::Maps.new({:origin => @origin, :destination => @destination,:mode=> mode }).duration
  end


end
