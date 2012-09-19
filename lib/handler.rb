require "eventmachine"
require "evma_httpserver"

class Handler < EM::Connection
  include EM::HttpServer

  def initialize(twit)
    @twit = twit
  end

  def process_http_request
    response = EM::DelegatedHttpResponse.new(self)
    operation = proc do
      @twit.process(@http_post_content)
      response.status = 200
      response.content = "ok"
    end
    callback = proc do
      response.send_response
    end
    EM.defer(operation, callback)
  end

end


