require 'rspec'
require '../trip.rb'

describe Trip do

  describe '#initialize' do

    before :each do
       Query::Maps.any_instance.stub(:trip_duration).and_return(5)
       @trip = Trip.new('home', 'work')
     end

    it 'should be an instance of transit trip' do
      @trip.should be_an_instance_of Trip
    end

    it 'should be initialized with an origin location' do
      @trip.origin.should == 'home'
    end

    it 'should be initialized with a destination location' do
      @trip.destination.should eq('work')
    end

    it 'initializes a driving time variable' do
      @trip.driving_time.should eq 5
    end

    it 'initializes a transit time variable' do
      @trip.transit_time.should eq 5
    end
  end

  describe '#comparison' do

    before :each do
       Query::Maps.any_instance.stub(:trip_duration).and_return(5)
       # Trip.any_instance.stub(:time).with('transit') { 5 } # .and_return(5)
       # Trip.any_instance.stub(:time).with('driving') { 9 } # .and_return(9)
       @trip = Trip.new('home', 'work')
     end

    it 'compares driving time and transit time' do
      @trip.comparison.should eq 'Driving time and transit time are equal.'
    end

  end

end

