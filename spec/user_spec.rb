require 'simplecov'
require 'rspec'
require_relative '../user.rb'
require_relative '../database.rb'

describe User do
  before(:each) do
    @user = User.new({'name' => "Shereef",
                      'addresses' => [{"location_name" => "Favorite Coffee Shop", "description" => "201 Harrison St SF CA"},
                                      {"location_name" => "Work", "description" => "717 California st. SF CA"}],
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
      @user.addresses.collect(&:location_name).sort.should == ["Favorite Coffee Shop", "Work"]
    end

    it 'assigns the description for the address' do
      @user.addresses.last.description.should == "717 California st. SF CA"
    end

    it 'should have a users environmental pref' do
      @user.environmental_pref.should == 30.0
    end
  end

  describe '#add_address' do
    it 'increases the number of addresses' do
      expect {
        @user.add_address([{"location_name" => "Favorite Lunch Spot", "description" => "Muracci's Japanese Curry & Grill, SF"}])
      }.to change(@user.addresses, :count).by(1)
    end

    it "should add another address to the user's address" do
      @user.add_address([{"location_name" => "Favorite Lunch Spot", "description" => "Muracci's Japanese Curry & Grill, SF"}])
      dive_bar = @user.addresses.find {|add| add.location_name == "Favorite Lunch Spot"}
      dive_bar.description.should == "Muracci's Japanese Curry & Grill, SF"
    end
  end

  describe '#save!' do

    it "saves the user by sending it to the database object" do
      @db = Query::Database.new("test.db")
      Query::Database.stub!(:new).and_return(@db)
      @user.add_address([{"location_name" => "sin city", "description" => "Las Vegas"}])
      @user.save!
      test_db = SQLite3::Database.new("test.db")
      test_db.results_as_hash = true
      results = test_db.execute( "SELECT users.*, addresses.* FROM addresses JOIN users ON users.id=addresses.user_id WHERE users.name='Shereef'")
      locations = results.collect {|row| row['description']}
      locations.include?("Las Vegas").should be true
    end


  end
end
