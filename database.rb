module Query

  class Database

    def initialize(database)
      @db = SQLite3::Database.new "./#{database}"

      @db.execute <<-SQL
      create table if NOT EXISTS users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(64),
      environmental_prefs DOUBLE,
      created_at DATETIME,
      updated_at DATETIME
      );
      SQL

      @db.execute <<-SQL
      create table if NOT EXISTS addresses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name varchar(30),
      description VARCHAR,
      created_at DATEIME,
      updated_at DATETIME,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(id)
      );
      SQL

    end

    def get_user(user_name)
      @db.results_as_hash = true
      query = "SELECT * FROM users WHERE name = ?"
      results = @db.execute(query, user_name)
      results[0].select { |k,v| k == 'name' || k == 'environmental_prefs'}
    end

    def save_user(user)
      query = "INSERT INTO users (name, environmental_prefs) VALUES (?, ?)"
      @db.execute(query, user.name, user.environmental_prefs)
    end
  end

end