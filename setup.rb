require 'dragonfly'
require './crop'


app = Dragonfly[:images].configure_with(:imagemagick)
app.configure do |c| 

  c.url_host = 'http://localhost:3001'

  c.job :tile_crop do |image, crop_request|

    crop_args = TileImageCropper.new(image, crop_request).cli_arguments
    process(:convert, crop_args)
    encode :jpg
  end

end 

def info(image, title) 
  puts "-- #{title} --"
  puts "landscape? #{image.landscape?}"
  puts "#{image.size} bytes"
  puts "#{image.width}x#{image.height}"
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
crop_request = OpenStruct.new(width: 560, height: 315, left: -100, top: 0)

cropped = image.tile_crop(image, crop_request)
info(cropped, 'cropped')