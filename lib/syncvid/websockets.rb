require 'em-websocket'
module SyncVid
  $socketpool = Hash.new do |hash, k|
    hash[k] = Array.new
  end

  WebSocketServer = Proc.new do |ws|

    ws.onopen do
      pool << ws
      ws.send("buttslol")
      # Do init stuff to get state in sync with anyone else
    end

    ws.onclose do
      pool.delete ws
    end

    ws.onerror do
      pool.delete ws
    end

    ws.onmessage do |msg|
      puts msg
    end
  end

  # Epic hack until we come up with a reasonable mechanism for what to do here
  def clientkey
    "buttslol"
  end

  def pool
    $socketpool[clientkey]
  end

end
