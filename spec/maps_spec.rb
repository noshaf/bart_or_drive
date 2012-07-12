require 'simplecov'
SimpleCov.start
require 'rspec'
require '../maps.rb'


describe "Maps" do

  before(:all) do
    @driving = Query::Maps.new({:origin => "717 California Street, SF", :destination => "24 Willie Mays Plaza, SF", :mode => "driving"})
    @transit = Query::Maps.new({:origin => "Embarcadero BART", :destination => "717 California Street, SF", :mode => "transit"})
  end

  describe "#initialize" do
    it "takes one argument" do
      expect {
        @driving
      }.should_not raise_error(ArgumentError)
    end
  end

  describe "#duration" do
    it "returns the time the trip takes in seconds" do
      @transit.duration.should === 453
      @driving.duration.should === 498
    end
  end

end