require_relative 'ffxi_graphics.rb'

module BinData
    class FFXI_Item_Header < BinData::Record
        # header: 14
        endian :little
        uint32 :id
        uint16 :flags
        uint16 :stacksize
        uint16 :itemtype
        uint16 :resource_id
        uint16 :validtargets
    end

    class FFXI_Item_String < BinData::Record
        endian :little

        position :item_offset
        uint32 :string_count # english = 5
        # technically should be looping the next 5 based on the above, or using an array?
        uint32 :string_1_offset
        uint32 :string_1_flag
        uint32 :string_2_offset
        uint32 :string_2_flag
        uint32 :string_3_offset
        uint32 :string_3_flag
        uint32 :string_4_offset
        uint32 :string_4_flag
        uint32 :string_5_offset
        uint32 :string_5_flag

        # for english (count = 5):
        # strings; 1 = name; 2 = unused; 3 = log singular; 4 = log plural; 5 = description

        # TO-DO: Try to handle this here.. When setting name, log_singular, log_plural, need to
        # check if they fit into length, otherwise, need to adjust offsets to allow for more space
        string :string_1_padding, :length => 28
        string :name, :length => lambda {string_2_offset - 28 - string_1_offset}
        string :string_2_padding, :length => 4 # string 2
        string :string_3_padding, :length => 28
        string :log_singular, :length => lambda {string_4_offset - 28 - string_3_offset}
        string :string_4_padding, :length => 28
        string :log_plural, :length => lambda {string_5_offset - 28 - string_4_offset}
        string :string_5_padding, :length => 28
        string :description, :length => lambda {0x280 - 28 - string_5_offset - item_offset}
    end

    class FFXI_Item_Graphics < BinData::Record
        endian :little

        uint32 :graphic_size
        uint8  :graphic_flag  #should be 0x91 0xa1 or 0xb1
        string :graphic_category, :length => 8  #need to right trim spaces
        string :graphic_id, :length => 8
        uint32 :graphic_buffer #idk, always equals 40
        int32 :graphic_width
        int32 :graphic_height
        uint16 :graphic_planes
        uint16 :graphic_bitcount
        uint32 :graphic_compression
        uint32 :graphic_image_size
        uint32 :graphic_h_res
        uint32 :graphic_v_res
        uint32 :graphic_used_colors
        uint32 :graphic_important_colors
		ffxi_icon :icon
    end

end