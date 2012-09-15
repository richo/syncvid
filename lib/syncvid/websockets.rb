require 'em-websocket'
module SyncVid

  $socketpool = Hash.new do |hash, k|
    hash[k] = ClientPool.new
  end

  WebSocketServer = Proc.new do |ws|

    # No send(:include to be seen...
    hack_n_patch(ws)

    ws.onopen do
      ws.pool << ws
    end

    ws.onclose do
      ws.pool.delete ws
    end

    ws.onerror do
      ws.pool.delete ws
    end

    ws.onmessage do |msg|
      puts "Got #{msg}"
      command, data = msg.split(":", 2)

      ws.pool.handle(command, data)
    end
  end

  def parse(msg)
    return msg.split(":", 2)
  end

  def hack_n_patch(socket)
    def socket.pool
      # Nils will dump people in a sort of default channel. I'm unconvinced this
      # is a bad thing
      $socketpool[channel]
    end

    def socket.channel
      request["query"]["channel"]
    end
  end

end
