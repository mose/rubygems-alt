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

  describe "hamdles a short announce" do

    before do
      @tw = Minitest::Mock.new
      @bit = Minitest::Mock.new
      @url = Minitest::Mock.new
      @bit.expect(:shorten,@url,["http://rubygems.org/gems/capistrano-node-deploy"])
      @bit.expect(:shorten,@url,["http://github.com/loopj/capistrano-node-deploy"])
      @url.expect(:short_url,'http://bit.ly/xxxxxx')
      @url.expect(:short_url,'http://bit.ly/yyyyyy')
      @announce = Announce.new(@tw,@bit)
      @headers = {'Authorization' => '3a52d88183e7695d58aa110e0b8c06a18ee98ba050568c6d89648a3a779a4283' }
      @content = File.read(File.expand_path("../samples/webhook",__FILE__))
    end

    it "read the announce correctly" do
      @result = @announce.build_message(@content,@headers)
      @result.must_include "capistrano-node-deploy"
      @result.must_include " (1.0.9) "
      @result.length.must_be  :<=, 140
      @bit.verify
    end

    it "fails to accept invalid authorization key" do
      @headers = {'Authorization' => '3a52d88183e7695d58aa110e0b8c06a18ee98ba050568c6d89648a3a779a4211' }
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
