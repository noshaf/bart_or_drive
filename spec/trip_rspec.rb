require 'rspec'
require '../trip.rb'

describe Trip do

  before :each do
     Query::Maps.any_instance.stub(:trip_duration).and_return(5)
     @person = {}
     @person.stub(:environmental_pref).and_return(30)
     @trip = Trip.new('home', 'work', @person)
  end

  describe '#initialize' do

    it 'should be an instance of transit trip' do
      @trip.should be_an_instance_of Trip
    end

    it 'should be initialized with an origin location' do
      @trip.origin.should == 'home'
    end

    it 'should be initialized with a destination location' do
      @trip.destination.should eq('work')
    end
  end

  describe "#driving_time" do
    it 'calculates the driving time based on environmental prefs' do
      @trip.driving_time.should eq 1805
    end
  end

  describe "#transit_time" do
    it 'initializes a transit time variable' do
      @trip.transit_time.should eq 5
    end
  end


  describe '#comparison' do

    it 'compares driving time and transit time' do
      @trip.comparison.should match /Take Transit./
    end
  end

end

