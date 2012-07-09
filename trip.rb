class Trip

  attr_reader :origin, :destination, :driving_time, :transit_time

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @driving_time = Maps.new({:origin => origin, :destination => destination,:mode=> 'driving'}).duration
    @transit_time = Maps.new({:origin => origin, :destination => destination,:mode=> 'transit'}).duration
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


end

class Maps
  def initialize(hash)
  end
end

