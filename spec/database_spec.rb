require 'simplecov'
SimpleCov.start
require '../database'
require 'rspec'
require 'sqlite3'

describe 'Database' do

  before :each do
    @db = Query::Database.new('./database_test.db')
    @test_db = SQLite3::Database.new './database_test.db'
    @user = double("user")
    @user.stub(:name).and_return('Jessie')
    @user.stub(:environmental_pref).and_return(30.0)
  end

  after :each do
    File.delete('./database_test.db')
  end

  describe "#save_user" do

    it "creates a new line in the users table" do
      @db.save_user(@user)
      results = @test_db.execute'SELECT * FROM users'
      results.should_not eq []
    end
  end

  describe "#get_user" do

    it "takes one argument" do
      expect {
      @db.get_user("Jess")
      }.should_not raise_error(ArgumentError)
    end

    it "actually returns the right information" do
      @db.save_user(@user)
      @db.get_user(@user.name).should eq ({'name' => 'Jessie','environmental_pref' => 30})
    end

  end


  describe "#add_address" do

    before :each do
      @address = double("address")
      @address.stub(:location_name).and_return('home')
      @address.stub(:description).and_return('90 Divisadero St, SF, CA')
      @db.save_user(@user)
      @db.save_address(@address, "Jessie")
    end

    it "adds a line to the address table" do
      results = @test_db.execute 'SELECT * FROM addresses'
      results.should_not eq []
    end

    it "has a user_id column when being added" do
      results = @test_db.execute 'SELECT user_id FROM addresses'
      results[0].should_not be nil
    end

    it "has the correct user_id column when being added" do
      id = @test_db.execute "SELECT id FROM users WHERE name = 'Jessie'"
      results = @test_db.execute 'SELECT user_id FROM addresses'
      results.should eq id
    end

    it "should not save duplicate addresses" do
      @db.save_address(@address, "Jessie")
      dupe_test = @test_db.execute 'SELECT location_name FROM addresses'
      dupe_test[1].should_not be
    end


  end

end
