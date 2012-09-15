module SyncVid
  class ClientPool

    ALLOWED_COMMANDS = "tell play pause"

    attr_reader :clients
    def initialize
      @clients = []
    end

    def <<(object)
      @clients << object
    end

    def delete(object)
      @clients.delete(object)
    end

#clientpool impleentation
    # Don't use send() since we accept arbitrary commands
    #

    def handle(msg)
      command, data = msg.split(":", 2)
      puts "handling for '#{command}', '#{data}'"
      case command
      when "TELL"

        @clients.each do |ws|
          ws.send("TELL:#{data}")
        end
      when "PLAY"
        @clients.each do |ws|
          ws.send("PLAY")
        end
      when "PAUSE"
        @clients.each do |ws|
          ws.send("PAUSE")
        end
      end
    end

  end
end
