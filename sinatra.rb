require 'sinatra'
require './trip.rb'

get '/' do
  erb :index
end

post '/form' do
  origin = params[:origin]
  destination = params[:destination] 
  output = bart_or_drive(origin,destination).to_s
  erb output
end

def bart_or_drive(origin,destination)
  new_trip = Trip.new(origin,destination)
  new_trip.comparison
end