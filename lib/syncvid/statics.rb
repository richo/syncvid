require 'evma_httpserver'
class SyncVid::StaticServer < EventMachine::Connection

  include EventMachine::HttpServer

  attr_reader :routes
  def initialize(*args)
    initialize_routes!
    super(*args)
  end

  def process_http_request
    path = @http_path_info

    return not_found unless routes.include? path

    return send_response(@routes[path])
  end

  def initialize_routes!
    # Default route for index
    @routes = { "/" => "index.html" }
    Dir["public/**"].each  do |f|
      route = f.gsub /^public\//, "/"
      @routes[route] = f
    end
  end

private

  def send_response(file)
    EventMachine::DelegatedHttpResponse.new(self).tap do |res|
      res.status = 200
      res.content = File.open(file).read
      res.send_response
    end
  end

  def not_found
    EventMachine::DelegatedHttpResponse.new(self).tap do |res|
      res.status = 404
      res.content = "Not found"
      res.send_response
    end
  end

end
