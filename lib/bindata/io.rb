require 'bindata'

module BinData
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