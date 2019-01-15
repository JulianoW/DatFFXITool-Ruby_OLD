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


  