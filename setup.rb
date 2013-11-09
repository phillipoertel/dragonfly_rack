require 'dragonfly'
require 'pathname'

require './crop'

APP_ROOT = Pathname.new(File.dirname(__FILE__))

app = Dragonfly[:images].configure_with(:imagemagick)

app.configure do |c| 

  c.url_host = 'http://localhost:3001'

  c.job :tile_crop do |image, crop_request|

    crop_args = TileImageCropper.new(image, crop_request).cli_arguments
    process(:convert, crop_args)
    encode :jpg
  end

  c.log = Logger.new(APP_ROOT.join('log/dragonfly_setup.log'))

end 

app.datastore.configure do |d|
  d.root_path = APP_ROOT.join('datastore').to_s # defaults to /var/tmp/dragonfly
end

def info(image, title) 
  puts "-- #{title} --"
  puts "landscape? #{image.landscape?}"
  puts "#{image.size} bytes"
  puts "#{image.width}x#{image.height}"
  puts "#{image.path} path"
  puts "#{image.url}"
end

# fetch remote image and save it
original_url = 'http://polpix.sueddeutsche.com/polopoly_fs/1.1813993.1383918879!/httpImage/image.jpg_gen/derivatives/560x315/image.jpg'
remote_image = app.fetch_url(original_url)
uid = app.store(remote_image)

# open saved image
image = app.fetch(uid)
info(image, 'original')
# these are the crop settings the user gave us
crop_request = OpenStruct.new(width: 560, height: 315, left: -50, top: 0)

cropped_image = image.tile_crop(image, crop_request)
info(cropped_image, 'cropped')