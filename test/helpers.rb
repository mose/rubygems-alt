require 'minitest/ci'
require 'simplecov'
SimpleCov.start

module TestHelpers

  def self.load_env
    File.open(File.expand_path('../../config.defaults',__FILE__), 'r') do |f|
      while line = f.gets
        line.gsub(/^\s*export\s+([^= ]*)\s*=['"]?([^'"\n]*)['"]?$/) { |l| ENV[$1] = $2 }
      end
    end
  end

end

if $0 == __FILE__
  TestHelpers::load_env
  puts ENV.inspect
end

MiniTest::Ci.auto_clean = false
