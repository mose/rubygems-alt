require "twitter"
require "bitly"
require "yajl/json_gem"

class Announce

  def initialize
    @client = Twitter::Client.new(
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
    Bitly.use_api_version_3
    @bitly = Bitly.new(ENV['BITLY_USER'], ENV['BITLY_APIKEY'])
    #hashtagfile = File.join(ROOT_DIR,"hashtags.json")
  end

  def process(content)
    file.open(FILE.join(ROOT_DIR,'tmp','last'), 'w') do |f|
      f.write content
    end
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


