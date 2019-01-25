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

 

end