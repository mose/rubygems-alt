require 'minitest/autorun'
require_relative 'helpers.rb'
require_relative '../lib/announce.rb'

describe Announce do
  include TestHelpers

  before do
    TestHelpers::load_env
  end

  describe "starts smoothly" do

    it "initialize Annoucne class with proper instance variables" do
      announce = Announce.new
      announce.instance_variables.must_include :@tw
      announce.instance_variables.must_include :@bit
      announce.instance_variables.must_include :@hashtags
    end

  end

  describe "handles a short announce" do

    before do
      @tw = Minitest::Mock.new
      @bit = Minitest::Mock.new
      @url = Minitest::Mock.new
      @url.expect(:short_url,'http://j.mp/xxxxxx')
      @url.expect(:short_url,'http://j.mp/yyyyyy')
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      @bit.expect(:shorten,@url,["http://github.com/loopj/capistrano-node-deploy"])
      @announce = Announce.new(@tw,@bit)
      @a = Announce.new
      @headers = {'Authorization' => 'ffa00c92415a1de2229c660b04b84221e54860307a392ab5d92ad5ae942f277a' }
      @content = File.read(File.expand_path("../samples/webhook",__FILE__))
    end

    it "uses twitter library" do
      @a.twitter.class.name.must_equal "Twitter::Client"
    end

    it "uses bitly library" do
      @a.bitly.class.name.must_equal "Bitly::V3::Client"
    end

    it "shortens urls" do
      short = @announce.shorten "http://rubygems.org/gems/capistrano-node-deploy"
      short.must_equal 'http://j.mp/xxxxxx'
    end

    it "read the announce correctly" do
      @result = @announce.build_message(@content,@headers)
      @result.must_include "capistrano-node-deploy"
      @result.must_include " (1.0.9) "
      @result.length.must_be  :<=, 140
      @bit.verify
    end

    it "fails to accept invalid authorization key" do
      @headers = {'Authorization' => 'ffa00c92415a1de2229c660b04b84221e54860307a392ab5d92ad5ae942f277a' }
      @result = @announce.build_message(@content,@headers)
      @announce.build_message(@content,@headers).must_equal false
    end

    it "reads long announce right" do
      @content = File.read(File.expand_path("../samples/webhook-long",__FILE__))
      @result = @announce.build_message(@content,@headers)
      @result.length.must_equal 140
      @bit.verify
    end

  end

end
