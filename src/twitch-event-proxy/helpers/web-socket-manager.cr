class WebSocketManager
  SOCKETS = [] of HTTP::WebSocket

  def self.register(socket : HTTP::WebSocket)
    SOCKETS << socket

    socket.on_close { delete socket }
  end

  def self.delete(socket : HTTP::WebSocket)
    SOCKETS.delete socket
  end

  def self.broadcast(message : String)
    SOCKETS.each { |socket| socket.send message }
  end
end
