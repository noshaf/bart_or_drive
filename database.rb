module Query

  class Database

    def initialize(database)
      @db = SQLite3::Database.new "./#{database}"
      @db.results_as_hash = true
      @db.execute <<-SQL
      create table if NOT EXISTS users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(64),
      environmental_pref DOUBLE
      );
      SQL

      @db.execute <<-SQL
      create table if NOT EXISTS addresses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      location_name varchar(30),
      description VARCHAR,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(id),
      UNIQUE (user_id, location_name)
      );
      SQL
    end

    def get_user(user_name)

      query = "SELECT * FROM users WHERE name = ?"
      results = @db.execute(query, user_name)
      results[0].select! { |k,v| k == 'name' || k == 'environmental_pref'}
      results[0]["addresses"] = get_addresses(user_name)
      results[0]
    end

    def save! (user)
      save_user(user)
        user.addresses.each do |address|
          save_address(address, user.name)
        end
    end

    def save_user(user)
      query = "INSERT INTO users (name, environmental_pref) VALUES (?, ?)"
      @db.execute(query, user.name, user.environmental_pref)
    end

    def save_address(address, user_name)
      id = get_user_id_from_name(user_name)
      insert_address = "INSERT INTO addresses (location_name, description, user_id) VALUES (?, ?, ?)"
      begin
        @db.execute(insert_address, address.location_name, address.description, id)
      rescue
      end
    end

    private

    def get_user_id_from_name(user_name)
      @db.results_as_hash = false
      find_id = "SELECT id FROM users WHERE name = ? "
      user_id = @db.execute(find_id, user_name)
      @db.results_as_hash = true
      user_id
    end

    def get_addresses(user_name)
      find_addresses = "SELECT * FROM addresses WHERE user_id = ? "
      results = @db.execute(find_addresses, get_user_id_from_name(user_name))
      results.map! do |hsh|
        hsh.select! do |k,v|
          k == 'location_name' || k == 'description'
        end
      end
      results
    end

  end
end