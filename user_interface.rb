require './trip.rb'
require './database.rb'
require './user.rb'

class UserInterface
  def initialize
  @db = Query::Database.new('database.db')
  @menu_choice = ""
  @saved_addresses = []
  end

  def run
    welcome
    first_time
    while @menu_choice != "4"
      main_menu
    end
  end

  def welcome
    puts "\nWelcome to Bart vs Drive\n\n"
  end

  def first_time
    puts "Is this your first time using Bart vs Drive?"
    printf "Y/N: "
    first_time = gets.chomp.downcase
    case first_time
      when 'y'
        sign_up
      when 'n'
        login
      else
        puts "I did not understand that response, please try again"
        first_time
    end
  end

  def sign_up
    printf "\nThanks for installing me! What is your name? "
    user_name = gets.chomp
    puts "How many minutes are you willing to sacrifice to take public transit?"
    printf "(Earth <3 Public Transit...): "
    transit_tolerance_in_minutes = gets.chomp
    puts "Shame on you!" if transit_tolerance_in_minutes == "0"
    user_hash = {'name' => user_name, 'transit_tolerance_in_minutes' => transit_tolerance_in_minutes.to_f, 'addresses' => []}
    create_user(user_hash)
    puts "\nWelcome #{user_name}!"
  end

  def login
    all_users = @db.get_all_user_names
    puts "\nRegistered users:\n-------------------"
    puts all_users
    printf "\n\nWho are you?: "
    current_user = gets.chomp
    validate(current_user,all_users)
    user_hash = @db.get_user(current_user)
    create_user(user_hash)
    puts "\nWelcome back #{current_user}!"
  end

  def create_user(user_hash)
    @user = User.new(user_hash)
    @saved_addresses = @user.addresses.collect(&:location_name)
  end

  def validate(user_name,all_users)
    if !all_users.include?(user_name)
      "Whoops, I couldn't find that name, wanna try again?\n"
      login
    end
  end

  def main_menu
    puts "\nMain Menu\n\n"
    puts "1. Ask Bart vs Drive whether to Bart... or... Drive..."
    puts "2. Save an Address"
    puts "3. List Saved Addresses"
    puts "4. Exit"
    printf "What do you want to do?: "
    @menu_choice = gets.chomp
      case @menu_choice
        when "1"
          bart_or_drive
        when "2"
          save_an_address
        when "3"
          list_addresses
        when "4"
          puts "Goodbye!"
          @user.save!
      end
  end

  def bart_or_drive
    printf "Enter starting point: "
    origin = check_saved_addresses(gets.chomp)
    printf "Enter destination point: "
    destination = check_saved_addresses(gets.chomp)
    new_trip = Trip.new(origin,destination,@user)
    puts new_trip.comparison
  end

  def save_an_address
    printf "Enter the address you would like to save: "
    new_address = gets.chomp
    printf "Enter a name for this address: "
    new_location_name = gets.chomp
    address_hash = {'location_name' => new_location_name, 'description' => new_address}
    @user.add_address([address_hash])
    @saved_addresses = @user.addresses.collect(&:location_name)
  end

  def check_saved_addresses(input)
    if @saved_addresses.include?(input)
      address = @user.addresses.find { |hash| hash.location_name == input }
      address.description
    else
      input
    end
  end

  def list_addresses
      puts "\n#{"name".ljust(20," ")}address"
      puts "-"*40
    @user.addresses.each do |address|
      puts "#{address.location_name.ljust(20," ")}#{address.description}"
    end
  end

end

UserInterface.new.run