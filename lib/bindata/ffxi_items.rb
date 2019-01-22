require 'bindata'
require_relative 'position.rb'
require_relative 'ffxi_shared.rb'

class FFXI_Armor < BinData::Record
    # header: 14
    endian :little
    ffxi_item_header :header
    # armor: 30
    uint16 :level
    uint16 :slot
    uint16 :races
    uint32 :jobs
    uint16 :superior_lvl
    uint16 :shield_size
    uint8 :max_charges
    uint8 :casting_time
    uint16 :use_delay
    uint32 :reuse_delay
    uint16 :unknown2
    uint16 :ilevel
    uint32 :unknown3
    # starting at 44
    ffxi_item_string :strings
    ffxi_item_graphics :graphics
end

