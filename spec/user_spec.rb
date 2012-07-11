require 'simplecov'
require 'rspec'
require_relative '../user.rb'
#require_relative '../database.rb'

describe User do
  before(:each) do
    @user = User.new({'name' => "Shereef",
                      'addresses' => {'home' => "717 California St, SF", 'work' => "160 Spear St. SF"},
                      'environmental_pref' => 30.0})
  end
  describe '#initialize' do

    it 'makes an instance of user' do
      @user.should be_an_instance_of User
    end

    it 'should have a users name' do
      @user.name.should == "Shereef"
    end

    it 'should have an address object array' do
      @user.addresses.collect(&:name).sort.should == ['home', 'work']
    end

    it 'assigns the description for the address' do
      @user.addresses.last.description.should == "160 Spear St. SF"
    end

    it 'should have a users environmental pref' do
      @user.environmental_pref.should == 30.0
    end
  end

  describe '#add_address' do
    it 'increases the number of addresses' do
      expect {
        @user.add_address({'dive_bar' => "Bus Stop Bar"})
      }.to change(@user.addresses, :count).by(1)
    end

    it "should add another address to the user's address" do
      @user.add_address({'dive_bar' => "Bus Stop Bar"})
      dive_bar = @user.addresses.find {|add| add.name == 'dive_bar'}
      dive_bar.description.should == "Bus Stop Bar"
    end
  end

  describe '#save!' do

    it "saves the user by sending it to the database object"
      @user.add_address({'sin_city' => "Las Vegas"})
      @user.save!
      @db = Query::Database.new("test.db")
      @db.results_as_hash = true
      results = @db.execute( "SELECT users.* addresses.* FROM addresses JOIN users ON users.id=addresses.user_id WHERE users.name='Shereef'")
      locations = results.collect {|row| row[description]}
      locations.include?("Las Vegas").should be true
    end


  end
end
