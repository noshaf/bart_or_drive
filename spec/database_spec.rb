require 'simplecov'
SimpleCov.start
require '../database.rb'
require 'rspec'

describe 'Database' do

  before :each do
    @db = Query::Database.new('./database_test.db')
    @test_db = SQLite3::Database.new './database_test.db'
    @user = double("user")
    @user.stub(:name).and_return('Jessie')
    @user.stub(:environmental_pref).and_return(30.0)
    @user.stub(:addresses).and_return([])
  end

  after :each do
    File.delete('./database_test.db')
  end

  describe "#get_user" do

    before :each do
      @address = double("address")
      @user.stub(:addresses).and_return([@address, @address])
      @address.stub(:location_name).and_return("Work", "Favorite Coffee Shop")
      @address.stub(:description).and_return("717 California st. SF CA", "201 Harrison St SF CA")
    end

    it "takes one argument" do
      expect {
      @db.get_user("Jess")
      }.should_not raise_error(ArgumentError)
    end

    it "gets a user id, environmental prefs, and addresses" do
      @db.save!(@user)
      @db.get_user("Jessie").should eq({'name' => 'Jessie','environmental_pref' => 30.0, 'addresses' => [{"location_name" => "Favorite Coffee Shop", "description" => "201 Harrison St SF CA"},{"location_name" => "Work", "description" => "717 California st. SF CA"}]})
    end
  end

  describe "#save!" do
    describe 'single addresses' do
      before :each do
        @address = double("address")
        @user.stub(:addresses).and_return([@address, @address])
        @address.stub(:location_name).and_return('home')
        @address.stub(:description).and_return('90 Divisadero St, SF, CA')
        @db.save!(@user)
      end

      it "adds a line to the address table" do
        results = @test_db.execute 'SELECT * FROM addresses'
        results.should_not eq []
      end

      it "has the correct user_id column when being added" do
        id = @test_db.execute "SELECT id FROM users WHERE name = 'Jessie'"
        results = @test_db.execute 'SELECT user_id FROM addresses'
        results.should eq id
      end

      it "should not save duplicate addresses" do
        @db.save!(@user)
        dupe_test = @test_db.execute 'SELECT location_name FROM addresses'
        dupe_test[1].should_not be
      end


      it "should really really not save duplicate addresses" do
        @db.save!(@user)
        @db.save!(@user)
        @db.save!(@user)
        @user.stub(:name).and_return("Michael")
        @db.save!(@user)
        dupe_test = @test_db.execute 'SELECT location_name FROM addresses'
        dupe_test.length.should eq 2
      end
    end

    describe 'multiple addresses' do
      before :each do
        @address = double("address")
        @user.stub(:addresses).and_return([@address, @address])
        @address.stub(:location_name).and_return("Work", "Favorite Coffee Shop")
        @address.stub(:description).and_return("717 California st. SF CA", "201 Harrison St SF CA")
      end

      it "creates a new line in the users table" do
        @db.save!(@user)
        results = @test_db.execute'SELECT * FROM users'
        results.should_not eq []
      end

      it "writes new user preferences to the db" do
        @db.save!(@user)
        @user.stub(:environmental_pref).and_return(40.0)
        @db.save!(@user)
        @test_db.execute("SELECT environmental_pref FROM users").first.first.should eq 40.0
      end

      it "adds multiple addresses for one user" do
        @db.save!(@user)
        find_id = "SELECT id FROM users WHERE name = ? "
        id = @test_db.execute(find_id, @user.name)
        get_addresses = "SELECT user_id FROM addresses WHERE user_id = ?"
        addresses = @test_db.execute(get_addresses, id)
        addresses.length.should eq 2
      end
    end

  end

  describe "#get_all_user_names" do
    it 'is kind of a self explanatory method' do
      @db.save!(@user)
      @user.stub(:name).and_return("Michael")
      @db.save!(@user)
      @db.get_all_user_names.should eq ["Jessie", "Michael"]
    end
  end
end
