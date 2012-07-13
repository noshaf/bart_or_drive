require_relative './address.rb'

class User
  attr_reader :name, :addresses, :transit_tolerance_in_minutes
  def initialize(options)
    @name = options.fetch('name') { raise "There needs to be a name" }
    @addresses = []
    @transit_tolerance_in_minutes = options['transit_tolerance_in_minutes']
    add_address( options['addresses'] )
  end

  def add_address (address_options)
    address_options.each do |address_hash|
      @addresses << Address.new(address_hash['location_name'], address_hash['description'])
    end
  end

  def save!
    @db = Query::Database.new('database.db')
    @db.save!(self)
  end

end

