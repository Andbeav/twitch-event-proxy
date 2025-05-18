class Database
  DB_URI = "sqlite3://./events.db"
  @@setup = false

  def self.preflight
    DB.open(DB_URI) do |conn|
      conn.exec "create table if not exists events (timestamp text, detail text)"
      @@setup = true
    end unless @@setup
  end

  def self.db(&block)
    preflight
    begin
      conn = DB.open(DB_URI)
      yield conn
    ensure
      conn.try &.close
    end
  end
end