require 'em-websocket'
module SyncVid
  $socketpool = Hash.new do |hash, k|
    hash[k] = ClientPool.new
  end

  WebSocketServer = Proc.new do |ws|

    ws.onopen do
    end

    ws.onclose do
      pool.delete ws
    end

    ws.onerror do
      pool.delete ws
    end

    ws.onmessage do |msg|
      puts "Got #{msg}"

      command, data = parse(msg)
      pool.handle(command, data)
    end
  end

  # Epic hack until we come up with a reasonable mechanism for what to do here
  def clientkey
    "buttslol"
  end

  def pool
    $socketpool[clientkey]
  end

  def parse(msg)
    return msg.split(":", 2)
  end

end
