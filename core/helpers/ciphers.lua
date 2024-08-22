local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local ciphermap = {

        [10112] = 906,
        [10113] = 907,
        [10114] = 908,
        [10115] = 909,
        [10116] = 910,
        [10117] = 911,
        [10118] = 912,
        [10119] = 920,
        [10120] = 922,
        [10121] = 925,
        [10122] = 926,
        [10123] = 927,
        [10124] = 928,
        [10125] = 929,
        [10126] = 930,
        [10127] = 931,
        [10128] = 932,
        [10129] = 934,
        [10130] = 941,
        [10131] = 942,
        [10132] = 943,
        [10133] = 944,
        [10134] = 935,
        [10135] = 946,
        [10136] = 947,
        [10137] = 945,
        [10138] = 937,
        [10139] = 951,
        [10140] = 952,
        [10141] = 950,
        [10142] = 936,
        [10143] = 958,
        [10144] = 959,
        [10145] = 960,
        [10146] = 961,
        [10147] = 962,
        [10148] = 938,
        [10149] = 939,
        [10150] = 964,
        [10151] = 966,
        [10152] = 967,
        [10153] = 968,
        [10154] = 969,
        [10155] = 970,
        [10156] = 971,
        [10157] = 940,
        [10158] = 972,
        [10159] = 1009,
        [10160] = 1010,
        [10161] = 973,
        [10162] = 978,
        [10163] = 974,
        [10164] = 975,
        [10165] = 976,
        [10166] = 977,
        [10167] = 1014,
        [10168] = 1011,
        [10169] = 982,
        [10170] = 1012,
        [10171] = 1013,
        [10172] = 983,
        [10173] = 979,
        [10174] = 1016,
        [10175] = 984,
        [10176] = 985,
        [10177] = 1015,
        [10178] = 987,
        [10179] = 986,
        [10180] = 988,
        [10181] = 989,
        [10182] = 990,
        [10183] = 991,
        [10184] = 1017,
        [10185] = 997,
        [10186] = 1018,
        [10187] = 1019,
        [10188] = 992,
        [10189] = 993,
        [10190] = 994,
        [10191] = 995,
        [10192] = 996,
        [10193] = 999,
    }

    -- Public Variables.

    -- Private Methods.
    local function buildMenu (id)
        local cipher = o.get(id)

        if cipher then
            return {cipher, 0, 0, false}
        
        end
        return bp.__menus.done

    end

    -- Public Methods.
    o.get = function(id)
        return ciphermap[id]

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'ciphers' then
            local target = bp.__target.findNearby({"Gondebaud","Clarion Star","Wetata"})

            if target then
                local index, count, id, status, bag, res = bp.__inventory.findByName("Cipher:", 0)

                if index and status and status == 0 then
                    local cipher = o.get(id)

                    if cipher then
                    
                        bp.interact.trade(target, {{index, count}}, true, function(parsed, target)

                            if parsed['Menu ID'] == 437 then
                                bp.__menus.send(parsed, {buildMenu(id)})

                            else
                                bp.__menus.send(parsed, {bp.__menus.done})

                            end
                    
                        end)

                    end

                else
                    bp.toChat("You do not have any ciphers present in your inventory.", 150)
                
                end

            end

        end

    end)

    -- Class Specific Events.

    return o

end
return helper