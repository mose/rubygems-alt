require 'minitest/autorun'
require_relative 'helpers.rb'
require_relative '../lib/announce.rb'

describe Announce do
  include TestHelpers

  before do
    TestHelpers::load_env
  end

  describe "starts smoothly" do

    it "initialize twitter and bitly handler" do
      announce = Announce.new
      announce.instance_variables.must_include :@tw
      announce.instance_variables.must_include :@bit
    end

  end

  describe "hamdles the webhook" do

    before do
      stub(Announce).twitter { Twitter.new }
      stub(Announce).bitly { Bitly.new }
      stub(Bitly).shorten { Uri.new }
      @announce = Announce.new
      @content = File.read(File.expand_path("../samples/webhook",__FILE__))
      @result = @announce.build_message(@content)
    end

    it "should have proper methods declared" do

    end

    it "gets the name right" do
      @result.must_include "capistrano-node-deploy"
    end

    it "gets the version right" do
      @result.must_include " (1.0.9) "
    end

    it "is less than 140 characters" do
      @result.length.must_be  :<, 140
    end

  end

end
