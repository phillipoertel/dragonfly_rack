require 'ostruct'

class TileImageCropper

  # this is the size of the tile image
  CROP_DIMENSIONS = {
    width: 322,
    height: 144
  }

  def initialize(actual, current)
    @actual, @current, @crop_dimensions = actual, current
  end

  def crop!
    cmd = "convert #{cli_arguments} #{in_file} #{out_file}"
    `#{cmd}`
  end

  def cli_arguments
    "-resize #{scale}% -crop #{crop_width}x#{crop_height}#{left}#{top}"
  end

  private

    def in_file
      @actual.file
    end

    def out_file
      dir       = File.dirname(@actual.file)
      extension = File.extname(@actual.file)
      filename  = "#{File.basename(@actual.file, extension)}_cropped#{extension}"
      File.join(dir, filename)
    end

    def scale
      ((@current.width.to_f / @actual.width) * 100).round
    end

    def crop_width
      CROP_DIMENSIONS[:width]
    end

    def crop_height
      CROP_DIMENSIONS[:height]
    end

    def left
      stringify(@current.left * -1)
    end

    def top
      stringify(@current.top * -1)
    end

    # 400  => +400
    # -400 => -400
    def stringify(integer)
      sign = integer >= 0 ? '+' : '-'
      "#{sign}#{integer.abs}"
    end

end

__END__

# CONFIGURE THIS 
width  = 1155
height = 773
left   = -660
top    = -414
# END CONFIGURE THIS 

actual  = OpenStruct.new(width: 720, height: 482, file: "#{Dir.getwd}/image.jpg")
current = OpenStruct.new(width: width, height: height, left: left, top: top)

start = Time.now
TileImageCropper.new(actual, current).crop!
p Time.now - start
