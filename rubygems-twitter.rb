require "eventmachine"
require "evma_httpserver"
require "twitter"
require "yajl/json_gem"

class Twitit

  def initialize
    @client = Twitter::Client.new(
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
  end

  def process(content)
    payload = JSON.parse(content)
    name = payload['name']
    version = payload['version']
    info = payload['info']
    url = payload['project_uri']
    hurl = payload['homepage_uri']
    limit = 140 - (36 + name.size + version.size)
    if info.size > limit
      info = info[0..limit] + ' ...'
    end
    msg = "#{name} (#{version}) #{url} #{info} (#{hurl})"
    p msg
    @client.update(msg)
  end

end

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
      puts @http_request_method
      response.send_response
    end
    EM.defer(operation, callback)
  end

end

@twit = Twitit.new
EM.run do
  Signal.trap('INT')  { EM.stop }
  Signal.trap('TERM') { EM.stop }
  EM.start_server( ENV['WEBHOOK_SERVER'], ENV['WEBHOOK_PORT'], Handler, @twit )
end
