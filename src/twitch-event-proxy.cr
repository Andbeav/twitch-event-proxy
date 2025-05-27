require "json"
require "kemal"
require "sqlite3"
require "./twitch-event-proxy/**"

get "/gui" do
  events = [] of Event

  Database.db do |conn|
    result_set = conn.query("select timestamp, detail from events order by timestamp desc")
    events.concat Event.from_rs(result_set)
  end

  render "src/twitch-event-proxy/views/gui.ecr"
end

post "/broadcast" do |env|
  message = env.params.json.to_json
  WebSocketManager.broadcast message
end

ws "/socket" do |socket|
  WebSocketManager.register socket

  socket.on_message do |message|
    Database.db do |conn|
      conn.exec "insert into events values (?, ?)", Time.utc, message
    end
    WebSocketManager.broadcast message
  end
end

Kemal.run
