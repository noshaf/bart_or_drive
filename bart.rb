module Query
  class Bart
    def initialize(options)
      @orig = options.fetch('orig') { raise ArgumentError, "requires origin station" }
      @dest = options.fetch('dest') { raise ArgumentError, "requires destination station" }
    end

    def base_url
      "http://api.bart.gov/api/sched.aspx?"
    end

    def url_params
      @options.collect do |key, value|
        "#{key}=#{value.gsub(' ', '+')}"
      end.join("&")
    end

    def co2
    end


  end
end