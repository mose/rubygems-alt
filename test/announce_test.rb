# encoding: utf-8
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
      @bit = Minitest::Mock.new
      @url = Minitest::Mock.new
      @a = Announce.new
      def @a.shorten(x); 'http://j.mp/xxxxxx'; end
      def @a.update_status(x); 200; end
      @headers = {'Authorization' => 'ffa00c92415a1de2229c660b04b84221e54860307a392ab5d92ad5ae942f277a' }
      @content = File.read(File.expand_path("../samples/webhook",__FILE__))
    end

    it "uses twitter library " do
      @a.twitter.class.name.must_equal "Twitter::Client"
    end

    it "uses bitly library " do
      @a.bitly.class.name.must_equal "Bitly::V3::Client"
    end

    it "shortens urls " do
      @url.expect(:short_url,'http://j.mp/xxxxxx')
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      short = @a.shorten "http://rubygems.org/gems/capistrano-node-deploy"
      short.must_equal 'http://j.mp/xxxxxx'
    end

    it "gets hashes replaced in " do
      @a.hashify('thing rails that',15).must_equal " thing #rails …"
    end

    it "processes things " do
      @a.process(@content,@headers).must_equal 200
    end

    it "read the announce correctly " do
      @url.expect(:short_url,'http://j.mp/xxxxxx')
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      result = @a.build_message(@content,@headers)
      result.must_include "capistrano-node-deploy "
      result.must_include " 1.0.9 "
      result.length.must_be :<=, 140
    end

    it "fails to accept invalid authorization key " do
      @url.expect(:short_url,'http://j.mp/xxxxxx')
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      @headers = {'Authorization' => 'ffa00c92415a1de2229c660b04b84221e54860307a392ab5d92ad5ae942f2xxx' }
      @a.build_message(@content,@headers).must_equal false
    end

    it "reads long announce right " do
      @url.expect(:short_url,'http://j.mp/xxxxxx')
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      @content = File.read(File.expand_path("../samples/webhook-long",__FILE__))
      result = @a.build_message(@content,@headers)
      result.length.must_be :<=, 140
      result[-1,1].must_equal '…'
    end

  end

end
