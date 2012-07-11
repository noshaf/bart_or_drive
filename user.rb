require_relative './address.rb'

class User
  attr_reader :name, :addresses, :environmental_pref
  def initialize(options)
    @name = options.fetch('name') { raise "There needs to be a name" }
    @addresses = []
    @environmental_pref = options['environmental_pref']
    add_address( options['addresses'] )
  end

  def add_address (address_options)
    address_options.each do |name,description|
      @addresses << Address.new(name,description)
    end
  end

  def save!
    Query::Database.save(self)
  end

end

