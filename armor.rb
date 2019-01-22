require_relative 'bindata.rb'
require 'chunky_png'

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
  ffxi_image :image
end

# rotate function, move to a different file for dealing w/ encryption
class Integer
  def ror(n)
    (self >> n | self << (8 - n) ) % 256
  end
  def rol(n)
    (self << n | self >> (8 - n) ) % 256
  end
    def blue()
      (self & 0xff000000) >> 24
    end

    def green()
      (self & 0x00ff0000) >> 16
    end

    def red()
      (self & 0x0000ff00) >> 8
    end

    def alpha()
      self & 0x000000ff
    end

    def semialpha()
      alpha = 255
      semialpha = self & 0x000000ff
      if (semialpha < 0x80) then
        alpha = 2 * semialpha
      end
      alpha
    end

    def unsemialpha()
		alpha = self & 0x000000ff
		semialpha = (alpha / 2.0).ceil
		semialpha
	end
	
    def rgba_hash()
      {"red" => self.red, "green" => self.green, "blue" => self.blue, "alpha" => self.alpha, "semialpha" => self.semialpha}
    end

    def bgra()
      bgra = []
      bgra << self.blue << self.green << self.red << self.semialpha
      bgra
    end
end

# test using a file
file = File.new("armor1.DAT","rb")
a = []
# go through all bytes and rotate right 5 bytes
file.each_byte do |x|
a << x.ror(5)
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



#convert this stuff to bindata format ;)

#extra stuff below temporary for my own benefit and debugging... 

remaining = a[701...1725].pack("C*").unpack("N*")
pixels = a[1725...1725+1024]
out = ChunkyPNG::Image.new(32,32,ChunkyPNG::Color::TRANSPARENT)

palette = []
remaining.each do |x|
palette << x.rgba_hash
end


pixels.each_with_index do |pixel,i|
x = (i % 32)
y = 32 - 1 - ((i - x) / 32)
#color = remaining[pixel]
out[x,y] = ChunkyPNG::Color.rgba(palette[pixel]["blue"],palette[pixel]["green"],palette[pixel]["red"],palette[pixel]["semialpha"])
end
out.save 'wat.png'

out.to_data_url.gsub("data:image/png;base64,","")  #base64
# dont do the gsub and we can then do
# ChunkyPNG::Image.from_data_url(out.to_data_url)
# to load images

out.palette #<-- sweet! 
Array(out.palette).index(out.pixels[120]) #for re-building the binary...

asdf = Armor.read(a[0...0xc00].pack("C*"))
#do stuff to asdf
x[0...0xc00] = asdf.to_binary_s.unpack("C*")
(0xc00).times do |y|
x[y] = x[y].rol(5)
end

out = File.open("109.DAT","w+b")
out.write(x.pack("C*"))
out.close


