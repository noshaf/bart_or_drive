require './trip.rb'

def run
  puts "Welcome to Bart vs Drive"
  printf "Enter starting point: "
  origin = gets.chomp
  printf "Enter destination point:"
  destination = gets.chomp
  new_trip = Trip.new(origin,destination)
  puts new_trip.comparison
end

run