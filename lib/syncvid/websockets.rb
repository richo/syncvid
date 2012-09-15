require 'em-websocket'
module SyncVid
  $socketpool = Hash.new do |hash, k|
    hash[k] = ClientPool.new
  end

  WebSocketServer = Proc.new do |ws|

    ws.onopen do
      pool << ws
    end

    ws.onclose do
      pool.delete ws
    end

    ws.onerror do
      pool.delete ws
    end

    ws.onmessage do |msg|
      puts "Got #{msg}"
      pool.handle(msg)
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
