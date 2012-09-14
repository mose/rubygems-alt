require "eventmachine"
require "evma_httpserver"
require "twitter"
require "bitly"
require "yajl/json_gem"

class Twitit

  def initialize
    @client = Twitter::Client.new(
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
    Bitly.use_api_version_3
    @bitly = Bitly.new(ENV['BITLY_USER'], ENV['BITLY_APIKEY'])
  end

  def process(content)
    payload = JSON.parse(content)
    name = payload['name']
    version = payload['version']
    info = payload['info'].gsub(/\s+/,' ').gsub(/\A\s*/,'')
    url = @bitly.shorten(payload['project_uri']).short_url
    hurl = ''
    if payload['homepage_uri'] and payload['homepage_uri'] != ''
      hurl = ' (' + @bitly.shorten(payload['homepage_uri']).short_url + ')'
    end
    limit = 140 - (14 + name.size + version.size + url.size + hurl.size)
    if info.size > limit
      info = info[0..limit] + ' ...'
    end
    msg = "#{name} (#{version}) #{url} #{info}#{hurl}"
    p msg
    begin
      @client.update(msg)
    rescue Exception => e
      puts e
    end
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
