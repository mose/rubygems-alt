require 'rr'

class MiniTest::Unit::TestCase
    include RR::Adapters::MiniTest
end

module TestHelpers

  def self.load_env
    File.open(File.expand_path('../../config',__FILE__), 'r') do |f|
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
