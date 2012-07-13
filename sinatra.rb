require 'sinatra'
require './trip.rb'


database = [
  {'name' => "Ryan", :transit_tolerance_in_minutes => 0, 'addresses' => [{:location_name => 'home', :description => 'Embarcadero Bart SF'},
                                                                         {:location_name => 'moms', :description => 'Muraccis Curry SF'}]},
  {'name' => "Mike", :transit_tolerance_in_minutes => 0, 'addresses' => [{:location_name => 'home', :description => '717 California St SF'},
                                                                         {:location_name => 'work', :description => 'Montgomery Bart SF'}]
  }
]

get '/' do
  erb :index
end

post '/form' do
  origin = params[:origin]
  destination = params[:destination]
  output = bart_or_drive(origin,destination).to_s
  erb output
end

get '/edit_user/:user_name' do |user_name|
  output = ""
  database.each do |user|
    if user['name'] == user_name
      addresses = ""
      user['addresses'].each do |address|
        addresses << "<option value='#{address[:description]}'>#{address[:location_name]}</option>"
      end
      output << "<select id='origin_addresses' multiple='multiple'>
                  #{addresses}
                </select>"
      output << "<select id='destination_addresses' multiple='multiple'>
                  #{addresses}
                </select>"
    end
  end
  output
end


def bart_or_drive(origin,destination)
  new_trip = Trip.new(origin,destination)
  new_trip.comparison
end