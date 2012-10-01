require "eventmachine"
require "evma_httpserver"

class Handler < EM::Connection
  include EM::HttpServer

  def initialize(twit)
    @twit = twit
  end

  def process_http_request
    headers = Hash[ @http_headers.split(/\0/).map {|line| line.split(/:\s*/, 2) } ]
    response = EM::DelegatedHttpResponse.new(self)
    operation = proc do
      response.status = @twit.process(@http_post_content,headers)
      response.content = "ok"
    end
    callback = proc do
      response.send_response
    end
    EM.defer(operation, callback)
  end

end


