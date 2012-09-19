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
      announce.instance_variables.must_include :@client
      announce.instance_variables.must_include :@bitly
    end

  end

  describe "hamdles the webhook" do

    before do
      @announce = Announce.new
      skip
    end

  end

end
