require 'simplecov'
# Simplecov.Start
require 'rspec'
require_relative '../address.rb'

describe Address do
  before(:each) do
    @address = Address.new({:work => "717 California St, SF CA"})
  end
  describe "#initialize" do

    it "makes an instance of address" do
      @address.should be_an_instance_of Address
    end

    it "has a name" do
      @address.name.should == :work
    end

    it "has a description" do
      @address.description.should == "717 California St, SF CA"
    end
  end
end