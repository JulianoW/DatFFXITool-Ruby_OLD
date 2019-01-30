module BinData
    
    class FFXI_Jobs < BinData::Record
        bit1 :pld
        bit1 :thf
        bit1 :rdm
        bit1 :blm
        bit1 :whm
        bit1 :mnk
        bit1 :war
        bit1 :zero

        bit1 :smn
        bit1 :drg
        bit1 :nin
        bit1 :sam
        bit1 :rng
        bit1 :brd
        bit1 :bst
        bit1 :drk
       
        bit1 :mon
        bit1 :run
        bit1 :geo
        bit1 :sch
        bit1 :dnc
        bit1 :pup
        bit1 :cor
        bit1 :blu

        bit1 :job_31
        bit1 :job_30
        bit1 :job_29
        bit1 :job_28
        bit1 :job_27
        bit1 :job_26
        bit1 :job_25
        bit1 :job_24 
    end

    class FFXI_Item_Flags < BinData::Record
        bit1 :scroll
        bit1 :no_auction
        bit1 :inscribable
        bit1 :can_send_pol
        bit1 :mog_garden
        bit1 :mystery_box
        bit1 :flag01
        bit1 :wall_hanging
        
        bit1 :rare
        bit1 :no_trade_pc
        bit1 :no_delivery
        bit1 :no_sale
        bit1 :can_equip
        bit1 :can_trade_npc
        bit1 :can_use
        bit1 :linkshell
    end

    class FFXI_Item_Slot < BinData::Record
        #currently hardcoding slots... seems best way to do it?
        SLOTS = {
            "none" => 0x0000,
            "main" => 0x0001,
            "sub" => 0x0002,
            "range" => 0x0004,
            "ammo" => 0x0008,
            "head" => 0x0010,
            "body" => 0x0020,
            "hands" => 0x0040,
            "legs" => 0x0080,
            "feet" => 0x0100,
            "neck" => 0x0200,
            "waist" => 0x0400,
            "lear" => 0x0800,
            "rear" => 0x1000,
            "lring" => 0x2000,
            "rring" => 0x4000,
            "back" => 0x8000,
            #sets
            "ears" => 0x1800,
            "rings" => 0x6000,
            "all" => 0xFFFF
        }
        endian :little
        uint16 :slot

        def get_slot
           SLOTS.key(slot)
        end

        def set_slot(_slot)
            # Get hex value of provided slot (lowcased)
            value = SLOTS[_slot.downcase]
            if value.nil?
                slot.assign 0x0000 # if value doesn't exist, return 0 (not equippable)
                # should probably raise some kind of error? log error?
            else
                slot.assign value # otherwise, just return the value from the SLOTS hash
            end
        end
    end

    # To-do:
    # Item Type
    # Race
    # Skill
    # Valid Target/s
    # Element (maybe? might be part of string element icon)

    # When getting around to other portions (abilities): 
    # AbilityType
end