module Query

  class Database

    def initialize(database)
      @db = SQLite3::Database.new "./#{database}"

      @db.execute <<-SQL
      create table if NOT EXISTS users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(64),
      environmental_pref DOUBLE,
      created_at DATETIME,
      updated_at DATETIME
      );
      SQL

      @db.execute <<-SQL
      create table if NOT EXISTS addresses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      location_name varchar(30),
      description VARCHAR,
      created_at DATETIME,
      updated_at DATETIME,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(id),
      UNIQUE (user_id, location_name)
      );
      SQL

    end

    def get_user(user_name)
      @db.results_as_hash = true
      query = "SELECT * FROM users WHERE name = ?"
      results = @db.execute(query, user_name)
      results[0].select { |k,v| k == 'name' || k == 'environmental_pref'}
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
      find_id = "SELECT id FROM users WHERE name = ? "
      id = @db.execute(find_id, user_name)
      insert_address = "INSERT INTO addresses (location_name, description, user_id) VALUES (?, ?, ?)"
      begin
        @db.execute(insert_address, address.location_name, address.description, id)
      rescue
      end
    end

  end

end