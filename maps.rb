require 'json'
require 'net/http'

module Query
  class Maps
    attr_reader :duration
    def initialize(options)
      default_options = {
        :sensor => "false"
      }
      @options = default_options.merge(options)
      @duration = trip_duration
    end

    private

    def build_uri
      URI("#{base_url}?#{url_params}")
    end

    def base_url
      "http://maps.googleapis.com/maps/api/directions/json"
    end

    def url_params
      @options.collect do |key, value|
        "#{key}=#{value.gsub(' ', '+')}"
      end.join("&")
    end

    def get_response
      Net::HTTP.get_response(build_uri)
    end

    def trip_duration
       json_response["routes"][0]["legs"][0]["duration"]["value"]

    end

    def json_response
      JSON.parse(get_response.body)
    end
  end
end