require 'eventmachine'
class MsgProxy
  def add(client)
    clients << client
  end

  def remove(client)
    clients.reject {|i| i == client}
  end

  def clients
    @clients ||= []
  end
end


module SyncVid extend self
  def start_server
    EventMachine.run do
      EventMachine.set_quantum 10

      EventMachine.start_server '0.0.0.0', 8000, StaticServer
      EventMachine::WebSocket.start(:host =>'0.0.0.0', :port => 8080, &WebSocketServer)
    end
  end
end
