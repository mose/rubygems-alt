require "eventmachine"
require 'daemons'

ROOT_DIR = File.dirname(__FILE__)

Daemons.daemonize(
  :app_name => 'Rubygems-tweet',
  :dir_mode => :normal,
  :log_dir => File.join(ROOT_DIR,'logs'),
  :log_output => true,
  :dir => File.join(ROOT_DIR, 'tmp')
)

EM.run do
  Signal.trap('INT')  { EM.stop }
  Signal.trap('TERM') { EM.stop }
  EM.start_server( ENV['WEBHOOK_SERVER'], ENV['WEBHOOK_PORT'], Handler, Announce.new )
end
