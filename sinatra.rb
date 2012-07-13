require 'sinatra'
require './trip.rb'


database = [
  {'name' => "Ryan", :transit_tolerance_in_minutes => 0, 'addresses' => [{:location_name => 'home', :description => 'Embarcadero Bart'}]},
  {'name' => "Mike", :transit_tolerance_in_minutes => 0, 'addresses' => [{:location_name => 'home', :description => '717 California St SF'},
                                                             {:location_name => 'work', :description => 'Montgomery Bart'}]
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
    output = user['addresses'].to_s if user['name'] == user_name
  end
  output
end


def bart_or_drive(origin,destination)
  new_trip = Trip.new(origin,destination)
  new_trip.comparison
end