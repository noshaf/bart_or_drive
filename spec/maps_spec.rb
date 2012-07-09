require 'simplecov'
SimpleCov.start
require 'rspec'
require '../maps.rb'


describe "Maps" do

  before(:each) do
    @driving = Query::Maps.new("717 California Street, SF","24 Willie Mays Plaza, SF","driving")
    @transit = Query::Maps.new("Embarcadero BART","717 California Street, SF","transit")
  end

  describe "#initialize" do
    it "takes three arguments" do
      expect {
        @driving
      }.should_not raise_error(ArgumentError)
    end
  end

  # describe "#build_uri" do
  #   it "builds the query url from the arguments" do
  #     @driving.build_uri.to_s.should === "http://maps.googleapis.com/maps/api/directions/json?origin=717+California+Street,+SF&destination=24+Willie+Mays+Plaza,+SF&mode=driving&sensor=false"
  #     @transit.build_uri.to_s.should === "http://maps.googleapis.com/maps/api/directions/json?origin=Embarcadero+BART&destination=717+California+Street,+SF&mode=transit&sensor=false"
  #   end
  #
  #   it "returns an instance of URI" do
  #     @driving.should be_an_instance_of URI
  #     @transit.should be_an_instance_of URI
  #   end
  #
  # end


  describe "#duration" do
    it "returns the time the trip takes in seconds" do
      @transit.duration.should === 453
      @driving.duration.should === 498
    end
  end

end