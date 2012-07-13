require 'rspec'
require '../trip.rb'

describe Trip do

  before :each do
    @map1 = double
    @map2 = double
    Query::Maps.should_receive(:new).with(:origin => '1592 morgan ln Walnut Creek, CA',
                                          :destination => '717 california st SF',
                                          :mode => 'driving').and_return(@map1)
    Query::Maps.should_receive(:new).with(:origin => '1592 morgan ln Walnut Creek, CA',
                                          :destination => '717 california st SF',
                                          :mode => 'transit').and_return(@map2)
    @person = {}
    @person.stub(:transit_tolerance_in_minutes).and_return(30)
  end

  context "properties" do
    before(:each) do
      @map1.stub(:duration).and_return(5,4400,1805)
      @map2.stub(:duration).and_return(15,10,5)
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
      it 'calculates the driving time using Maps' do
        @trip.driving_time.should eq 5
      end
    end

    describe "#transit_time" do
      it 'calculates the transit time using Maps' do
        @trip.transit_time.should eq 15
      end
    end

    describe "#adjusted_driving_time" do
      it 'calculates the driving time with transit tolerance' do
        @trip.adjusted_driving_time.should == 1805
      end
    end
  end

  context "logic" do

    describe '#comparison' do
      it "returns transit when the adjusted transit time is shorter" do
        @map1.stub(:duration).and_return(5)
        @map2.stub(:duration).and_return(15)
        @trip = Trip.new('1592 morgan ln Walnut Creek, CA', '717 california st SF', @person)
        @trip.comparison.should match /Take Transit./
      end

      it "returns drive when the adjusted driving time is shorter" do
        @map1.stub(:duration).and_return(10)
        @map2.stub(:duration).and_return(4400)
        @trip = Trip.new('1592 morgan ln Walnut Creek, CA', '717 california st SF', @person)
        @trip.comparison.should match /Drive./
      end

      it "returns equal when they are equal" do
        @map1.stub(:duration).and_return(5)
        @map2.stub(:duration).and_return(1805)
        @trip = Trip.new('1592 morgan ln Walnut Creek, CA', '717 california st SF', @person)
        @trip.comparison.should match /Driving time and transit time are equal./
      end
    end
  end
end

