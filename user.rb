require_relative './address.rb'

class User
  attr_reader :name, :addresses, :environmental_pref
  def initialize(options)
    @name = options[:name]
    @addresses = []
    add_address(options[:addresses])
    @environmental_pref = options[:environmental_pref]
  end

  def add_address(address_options)
    address_options.each do |name,description|
      @addresses << Address.new({name => description})
    end
  end


end