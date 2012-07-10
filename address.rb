class Address
  attr_reader :name, :description
  def initialize(options)
    @name = options.keys[0]
    @description = options.values[0]
  end

end