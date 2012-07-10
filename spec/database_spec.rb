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
    @user.stub(:environmental_prefs).and_return(30.0)
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
      @db.get_user(@user.name).should eq ({'name' => 'Jessie','environmental_prefs' => 30})
    end

  end

end
