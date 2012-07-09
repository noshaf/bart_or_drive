require 'rspec'
require './driving_trip.rb'

describe DrivingTrip do
  before :each do
    Maps.any_instance.stub(:duration).and_return(5)
    @trip = DrivingTrip.new('home', 'work')
  end

  describe '#initialize' do

    it 'should be an instance of driving trip' do
      @trip.should be_an_instance_of DrivingTrip
    end

    it 'should be initialized with an origin location' do
      @trip.origin.should_not be nil
      @trip.origin.should == 'home'
      #@trip.origin.should be
    end

    it 'should be initialized with a destination location' do
      @trip.destination.should_not be nil
      @trip.destination.should eq('work')
    end

    it 'creates a new instance of the map class' do
      @trip.time.should eq 5
    end
  end
end

describe Maps do

end