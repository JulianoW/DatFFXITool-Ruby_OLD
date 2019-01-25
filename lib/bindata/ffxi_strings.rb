module BinData

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

        def get_name
            name.unpack("A*").first
        end

        def get_singular
            log_singular.unpack("A*").first
        end

        def get_plural
            log_plural.unpack("A*").first
        end

        def get_description
            description.unpack("A*").first
        end

        def name_length
            string_2_offset - 28 - string_1_offset
        end

        def log_singular_length
            string_4_offset - 28 - string_3_offset
        end

        def log_plural_length
            string_5_offset - 28 - string_4_offset
        end

        def set_name(_name)
            while _name.length >= name_length
                # need to increase name length by 4 until false
                # do it by increasing string 2 offset
                string_2_offset.assign string_2_offset + 4
                string_3_offset.assign string_3_offset + 4
                string_4_offset.assign string_4_offset + 4
                string_5_offset.assign string_5_offset + 4
            end
            name.assign _name
        end
        
        def set_singular(_singular)
            while _singular.length >= log_singular_length
                # need to increase name length by 4 until false
                # do it by increasing string 2 offset
                string_4_offset.assign string_4_offset + 4
                string_5_offset.assign string_5_offset + 4
            end
            log_singular.assign _singular
        end

        def set_plural(_plural)
            while _plural.length >= log_plural_length
                # need to increase name length by 4 until false
                # do it by increasing string 2 offset
                string_5_offset.assign string_5_offset + 4
            end
            log_plural.assign _plural
        end

    end
end