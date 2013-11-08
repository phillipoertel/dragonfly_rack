require 'dragonfly'
require 'rack/cache'

use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:cache/rack/meta',
  :entitystore => 'file:cache/rack/body'

run Dragonfly[:images].configure_with(:imagemagick)