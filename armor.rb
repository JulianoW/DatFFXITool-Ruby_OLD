require_relative 'bindata.rb'

class Armor < BinData::Record
  # header: 14
  endian :little
  uint32 :id
  uint16 :flags
  uint16 :stacksize
  uint16 :itemtype
  uint16 :resource_id
  uint16 :validtargets
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
  string :string_1_padding, :length => 28
  string :name, :length => lambda {string_2_offset - 28 - string_1_offset}
  string :string_2_padding, :length => 4 # string 2
  string :string_3_padding, :length => 28
  string :log_singular, :length => lambda {string_4_offset - 28 - string_3_offset}
  string :string_4_padding, :length => 28
  string :log_plural, :length => lambda {string_5_offset - 28 - string_4_offset}
  string :string_5_padding, :length => 28
  string :description, :length => lambda {0x280 - 28 - string_5_offset - item_offset} 

  # still need to do the graphic portion
end

# rotate function, move to a different file for dealing w/ encryption
class Integer
  def rotate(n)
    (self >> n | self << (8 - n) ) % 256
  end
end

# test using a file
file = File.new("armor1.DAT","rb")
a = []
# go through all bytes and rotate right 5 bytes
file.each_byte do |x|
a << x.rotate(5)
end

# number of items = array size / 0xc00 (length of an item)
max = a.size / 0xc00
armor = []
offset = 0xc00

# add an Armor object for every item to the armor array
max.times do |x|
armor << Armor.read(a[offset*(x)...offset*(x+1)].pack("C*"))
end

# test output
puts armor[10]

# item attributes can be modified by using armor[x].attrib.assign "value"
# the REALLY cool thing is that you can fudge the string offsets (to give you more space)
# and it auto-updates the string length and pads with 0x00 :D

# a[0...640].pack("C*") == asdf.to_binary_s  #this should return true :) first 0x280 bytes match!




