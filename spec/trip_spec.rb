require 'rspec'
require '../trip.rb'

describe Trip do

  before :each do
    map1 = double
    map2 = double
    Query::Maps.should_receive!(:new).with(:origin => '1592 morgan ln Walnut Creek, CA',
                                          :destination => '717 california st SF',
                                          :mode => 'driving').and_return(map1)
    Query::Maps.should_receive!(:new).with(:origin => '1592 morgan ln Walnut Creek, CA',
                                          :destination => '717 california st SF',
                                          :mode => 'transit').and_return(map2)
    map1.stub(:duration).and_return(5)
    map2.stub(:duration).and_return(15)
    @person = {}
    @person.stub(:environmental_pref).and_return(30)
    @trip = Trip.new('1592 morgan ln Walnut Creek, CA', '717 california st SF', @person)
  end

  describe '#initialize' do

    it 'should be an instance of transit trip' do
      @trip.should be_an_instance_of Trip
    end

    it 'should be initialized with an origin location' do
      @trip.origin.should == '1592 morgan ln Walnut Creek, CA'
    end

    it 'should be initialized with a destination location' do
      @trip.destination.should eq('717 california st SF')
    end
  end

  describe "#driving_time" do
    it 'calculates the driving time based on environmental prefs' do
      @trip.driving_time.should eq 1805
    end
  end

  describe "#transit_time" do
    it 'initializes a transit time variable' do
      Query::Maps.any_instance.stub(:trip_duration).and_return(5,15)
      @trip.transit_time.should eq 5
      @trip.transit_time.should eq 15
    end
  end


  describe '#comparison' do

    it 'compares driving time and transit time' do
      @trip.comparison.should match /Take Transit./
    end
  end

end

