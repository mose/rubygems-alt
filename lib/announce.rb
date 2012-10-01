# encoding: utf-8
require "twitter"
require "bitly"
require "yajl/json_gem"

class Announce

  def initialize(tw=nil,bit=nil)
    @tw = tw || twitter
    @bit = bit || bitly
    #hashtagfile = File.join(ROOT_DIR,"hashtags.json")
  end

  def twitter
    Twitter::Client.new(
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
  end

  def bitly
    Bitly.use_api_version_3
    Bitly.new(ENV['BITLY_USER'], ENV['BITLY_APIKEY'])
  end

  def process(content,headers)
    #File.open(File.join(ROOT_DIR,'tmp','last'), 'w') { |f| f.write content }
    msg = build_message(content,headers)
    if msg
      update_status msg
    else
      401
    end
  end

  def build_message(content,headers)
    payload = JSON.parse(content)
    name = payload['name']
    version = payload['version']
    authorization = Digest::SHA2.hexdigest(name + version + ENV['WEBHOOK_APIKEY'])
    if headers['Authorization'] != authorization
      puts "unauthorized #{headers['Authorization']} != #{authorization}"
      return false
    else
      info = payload['info'].gsub(/\s+/,' ').gsub(/\A\s*/,'')
      url = @bit.shorten(payload['project_uri']).short_url
      hurl = ''
      if payload['homepage_uri'] and payload['homepage_uri'] != ''
        hurl = ' (' + @bit.shorten(payload['homepage_uri']).short_url + ')'
      end
      limit = 140 - (12 + name.size + version.size + url.size + hurl.size)
      if info.size > limit
        info = info[0..limit] + ' …'
      end
      "#{name} (#{version}) #{url} #{info}#{hurl}"
    end
  end

  def update_status(msg)
    print Time.now.strftime("[%Y-%m-%d %H:%M] ")
    puts msg
    begin
      @tw.update(msg)
      200
    rescue Exception => e
      puts e
      500
    end
  end

end


