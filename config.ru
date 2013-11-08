require 'rubygems'
require 'dragonfly'

app = Dragonfly[:images].configure_with(:imagemagick)

run app
