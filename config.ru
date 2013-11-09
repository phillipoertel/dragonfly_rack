require 'dragonfly'
require 'rack/cache'

#use Rack::Cache,
#  :verbose     => false,
#  :metastore   => 'file:cache/rack/meta',
#  :entitystore => 'file:cache/rack/body'

app = Dragonfly[:images].configure_with(:imagemagick)

APP_ROOT = Pathname.new(File.dirname(__FILE__))

app.configure do |c|
	c.log = Logger.new(APP_ROOT.join('log/dragonfly_server.log'))

end

app.datastore.configure do |d|
  d.root_path = APP_ROOT.join('datastore') # defaults to /var/tmp/dragonfly
end

run app