# encoding: utf-8
require "twitter"
require "bitly"
require "yajl/json_gem"
require "awesome_print"

class Announce

  def initialize(tw=nil,bit=nil)
    @tw = tw || twitter
    @bit = bit || bitly
    @hashtags = File.read(File.expand_path("../../hashtags.txt",__FILE__)).split("\n")
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

  def shorten(link)
    @bit.shorten(link).short_url
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

  def hashify(content, limit)
    message = ''
    words = content.split(" ")
    while words.count > 0
      word = words.shift
      if (message.size + word.size + 2) > limit
        message << ' …'
        words.clear
      else
        if @hashtags.include? word.downcase.gsub(/\.,!/,'')
          message << " ##{word}"
        else
          message << " #{word}"
        end
      end
    end
    message
  end

  def build_message(content,headers)
    payload = JSON.parse(content)
    name = payload['name']
    version = payload['version']
    authorization = Digest::SHA2.hexdigest(name + version + ENV['WEBHOOK_APIKEY'])
    if headers['Authorization'] != authorization
      #puts "unauthorized #{headers['Authorization']} != #{authorization}"
      return false
    else
      info = payload['info'].gsub(/\s+/,' ').gsub(/\A\s*/,'')
      if payload['source_code_uri'] and payload['source_code_uri']  != ''
        link = payload['source_code_uri']
      elsif payload['homepage_uri'] and payload['homepage_uri'] != ''
        link = payload['homepage_uri']
      else
        link = payload['project_uri']
      end
      url = shorten(link)
      limit = 140 - (8 + name.size + version.size + url.size)
      message = hashify(info,limit)
      "#{name} #{version} #{url}#{message}"
    end
  end

  def update_status(msg)
    if msg
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

end


