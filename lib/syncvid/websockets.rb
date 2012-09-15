require 'em-websocket'
module SyncVid
  WebSocketServer = Proc.new do |ws|
    ws.onopen do
      $proxy.add(ws)
      ws.send("buttslol")
      # Do init stuff to get state in sync with anyone else
    end

    ws.onclose do
      $proxy.remove(ws)
    end

    ws.onerror do
      $proxy.remove(ws)
    end

    ws.onmessage do |msg|
      puts msg
    end
  end
end
