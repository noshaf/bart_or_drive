require 'simplecov'
require 'rspec'
require_relative '../user.rb'

describe User do
  before(:each) do
    @user = User.new({:name => "Shereef",
                      :addresses => {:home => "717 California St, SF", :work => "160 Spear St. SF"},
                      :environmental_pref => 30.0})
  end
  describe '#initialize' do

    it 'makes an instance of user' do
      @user.should be_an_instance_of User
    end

    it 'should have a users name' do
      @user.name.should == "Shereef"
    end

    it 'should have an address object array' do
      @user.addresses[0].should be_an_instance_of Address
      @user.addresses[0].name.should == :home
      @user.addresses[1].description.should == "160 Spear St. SF"
    end

    it 'should have a users environmental pref' do
      @user.environmental_pref.should == 30.0
    end
  end

  describe '#add_address' do

    it "should add another address to the user's address" do
      @user.addresses.should have(2).things
      @user.add_address({:dive_bar => "Bus Stop Bar"})
      dive_bar = @user.addresses.find {|add| add.name == :dive_bar}
      dive_bar.description.should == "Bus Stop Bar"
      dive_bar.should be_an_instance_of Address
      @user.addresses.should have(3).things
    end
  end
end
