require 'bindata'

module BinData
  class Position < BinData::BasePrimitive
    #-----------------------------------------------------------
    # Returns the current position / byte # in the input stream
    # 
    # Example:
    # 
    # class ABCD < BinData::Record
    #   position :start_pos
    #   string :data, length: 5
    #   position :mid_pos
    #   string :data2, length: 5
    #   position :end_pos
    # end
    # 
    # :start_pos is 0
    # :mid_pos is 5
    # :end_pos is 10
    # 
    #-----------------------------------------------------------
    private

    def value_to_binary_string(val)
      # no value in binary
      ""
    end

    def read_and_return_value(io)
      # value is the position in the io stream
      io.position
    end

    def sensible_default
      0
    end
	
	class FFXI_Image < BinData::BasePrimitive
    #-----------------------------------------------------------
    # Handle Graphics
    # 
    # Example:
    #  to write after done
	#
    #-----------------------------------------------------------
      
	  default_parameters length: 32, width: 32
	  
	  def value_to_binary_string(value)
		#have to_data_url, need to load and create bytes for palette and then for pixels
		length = eval_parameter(:length)
		width = eval_parameter(:width)
		
		# build bytes for image
		bytes = []
		
		# Load image from value (base64 encoded png)
		# ** TO DO: Check if value starts w/ "data:image/png;base64,"; if not, add it **
		img = ChunkyPNG::Image.from_data_url(value)
		img.palette.each do |x|
			bytes << x.red << x.green << x.blue << x.unsemialpha
		end
		
		# pad to 1024 with 0's
		while bytes.length != 1024 do
			bytes << 0
		end
		
		#flip image, just the way its stored
		img.flip!
		#for each pixel, add the byte corresponding to the index in the palette of the color
		img.pixels.each do |x|
			bytes << Array(img.palette).index(x)
		end
		
		# Should probably do a check here to make sure we're not writing more than 1024 pixels... 
		# This -might- be relevant to other graphics... but we're probably only doing icons which 
		# should all be 32x32 so I think it's ok.
		
		# pad to 2370 with 0's
		while bytes.length != 2370 do
			bytes << 0
		end
		
		# last byte is an FF
		bytes << 0xFF
		
		return bytes.pack("C*") #pack
	  end

	  def read_and_return_value(io)
		#read 1024 bytes for palette
		length = eval_parameter(:length)
		width = eval_parameter(:width)
		#first 
		input_palette = io.readbytes(1024).unpack("N*")
		pixels = io.readbytes(length*width).unpack("C*") #assuming 32x32... need to get length/width
		
		palette = []
		# add rgba hash to a new palette array ... is this really necessary? 
		# couldn't i juse use palette[pixel].red, etc., below? test tomorrow too tired now
		input_palette.each do |x|
			palette << x.rgba_hash
		end
		
		# create output "file"
		out = ChunkyPNG::Image.new(width,length,ChunkyPNG::Color::TRANSPARENT) #again, set lxw
		pixels.each_with_index do |pixel,i|
			x = (i % width)
			y = length - 1 - ((i - x) / 32)
			#color = remaining[pixel]
			out[x,y] = ChunkyPNG::Color.rgba(palette[pixel]["red"],palette[pixel]["green"],palette[pixel]["blue"],palette[pixel]["semialpha"])
		end
		# return data_url, same as base64 encoded string
		return out.to_data_url
		
	  end

	  def sensible_default
		0
	  end

	end
	
  end

  module IO
    module Common
      module SeekableStream
        #add position method to get the io stream position
        def position
          @raw_io.pos
        end
      end
    end
  end
end


  