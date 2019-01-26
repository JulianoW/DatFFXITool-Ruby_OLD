require_relative 'bindata/ffxi_items.rb'

#Example usage...

# ARMOR
file = File.new("armor1.DAT","rb")
a = []
# go through all bytes and rotate right 5 bytes
file.each_byte do |x|
    a << x.ror(5)
end

# read item into ffxi_armor
item_no = 0
item = FFXI_Armor.read(a[0xc00*(item_no)...0xc00*(item_no+1)].pack("C*"))

# update description
item.strings.description.assign "This is a custom description\nBoo-ya!\n\n:)"

# put item back into array
a[0xc00*(item_no)...0xc00*(item_no+1)] = item.to_binary_s.unpack("C*")

#rotate all items left 5
a.each_with_index do |x,i|
    a[i] = x.rol(5)
end

# write back to a file
out = File.open("109.DAT","w+b")
out.write(a.pack("C*"))
out.close

# WEAPON EXAMPLE

file = File.new("weapon.DAT","rb")
w = []
# go through all bytes and rotate right 5 bytes
file.each_byte do |x|
    w << x.ror(5)
end

# read item into ffxi_weapon
item_no = 4301  #Excalibur, ID 20685 - starting ID 16384 = 4031
item = FFXI_Weapon.read(w[0xc00*(item_no)...0xc00*(item_no+1)].pack("C*"))

#set blu job bit
item.jobs.blu = 1

# put item back into array
w[0xc00*(item_no)...0xc00*(item_no+1)] = item.to_binary_s.unpack("C*")

#rotate all items left 5
w.each_with_index do |x,i|
    w[i] = x.rol(5)
end

# write back to a file
out = File.open("108.DAT","w+b")
out.write(w.pack("C*"))
out.close