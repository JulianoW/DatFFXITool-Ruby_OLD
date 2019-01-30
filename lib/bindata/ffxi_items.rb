require 'bindata'
require_relative 'position.rb'
require_relative 'ffxi_strings.rb'
require_relative 'ffxi_shared.rb'
require_relative 'ffxi_graphics.rb'

class FFXI_Item_Header < BinData::Record
    # header: 14
    endian :little
    uint32 :id
    ffxi_item_flags :flags
    uint16 :stacksize
    uint16 :itemtype
    uint16 :resource_id
    uint16 :validtargets
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

class FFXI_Armor < BinData::Record
    endian :little
    
    ffxi_item_header :header
    
    uint16 :level
    ffxi_item_slot :slot
    uint16 :races
    ffxi_jobs :jobs
    uint16 :superior_lvl
    
    uint16 :shield_size
    
    uint8 :max_charges
    uint8 :casting_time
    uint16 :use_delay
    uint32 :reuse_delay
    uint16 :unknown2
    uint16 :ilevel
    uint32 :unknown3
    
    ffxi_item_string :strings
    ffxi_item_graphics :graphics
end

class FFXI_Weapon < BinData::Record
    endian :little
    
    ffxi_item_header :header
    
    uint16 :level
    ffxi_item_slot :slot
    uint16 :races
    ffxi_jobs :jobs
    uint16 :superior_lvl
    
    uint16 :unknown4
    uint16 :damage
    uint16 :delay
    uint16 :dps
    uint8 :skill
    uint8 :jug_size
    uint32 :unknown1

    uint8 :max_charges
    uint8 :casting_time
    uint16 :use_delay
    uint32 :reuse_delay
    uint16 :unknown2
    uint16 :ilevel
    uint32 :unknown3
    
    ffxi_item_string :strings
    ffxi_item_graphics :graphics
end