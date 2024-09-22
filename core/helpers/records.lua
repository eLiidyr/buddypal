local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local records = {}
    local current = {list={}, progress={}}
    local list    = {

        ['deeds']                   = {3779,3780,3781,3782,3783,3784,3785,3786,3787,3788},
        ['roe']                     = {3768,3769,3770,3771},
        ['vol1']                    = {3758,3760,3995,3998},
        ['vol2']                    = {3759,3760,3999},
        ['trove']                   = {3768,3769,3770,3771,3772,3776,3777,3778},
        ['vagary1']                 = {3400,3401,3402,3403,3404,3405,3406,3407},
        ['vagary2']                 = {879,880,881,882,883},
        ['foes']                    = {3789,3790,3791,3792,3793,3794,3795,3796,3797,3798,3799,3800,3801,3802,3803},

        -- NM's
        ['hugemaw harold']          = {817},
        ['bounding belinda']        = {818},
        ['prickly pitriv']          = {819},
        ['ironhorn baldurno']       = {820},
        ['sleepy mabel']            = {821},
        ['valkurm imperator']       = {822},
        ['serpopard ninlil']        = {823},
        ['abyssdiver']              = {824},
        ['intuila']                 = {825},
        ['emperor artho']           = {826},
        ['orcfeltrap']              = {827},
        ['lumber jill']             = {828},
        ['joyous green']            = {829},
        ['strix']                   = {830},
        ['warblade beak']           = {831},
        ['arke']                    = {832},
        ['largantua']               = {833},
        ['beist']                   = {834},
        ['jester malatrix']         = {835},
        ['cactrot veloz']           = {836},
        ['woodland mender']         = {837},
        ['sybaritic samantha']      = {854},
        ['keeper of heiligtum']     = {855},
        ['douma weapon']            = {856},
        ['king uropygid']           = {857},
        ['vedrfolnir']              = {858},
        ['immanibugard']            = {859},
        ['tiyanak']                 = {860},
        ['muut']                    = {861},
        ['camahueto']               = {862},
        ['voso']                    = {863},
        ['mephitas']                = {864},
        ['coca']                    = {865},
        ['ayapec']                  = {866},
        ['specter worm']            = {867},
        ['azrael']                  = {868},
        ['borealis shadow']         = {869},
        ['garbage gel']             = {891},
        ['bakunawa']                = {892},
        ['azure-toothed clawberry'] = {893},
        ['centurio xx-i']           = {898},
        ['kubool ja mhuufya']       = {896},
        ['vidmapire']               = {899},
        ['vermillion fishfly']      = {894},
        ['volatile cluster']        = {895},
        ['grand grenade']           = {897},
        ['sovereign behemoth']      = {914},
        ['hidhaegg']                = {915},
        ['tolba']                   = {916},
        ['carousing celine']        = {918},
        ['glazemane']               = {919},
        ['bambrox']                 = {920},
        ['thuban']                  = {921},
        ['sarama']                  = {922},
        ['shedu']                   = {923},
        ['tumult curator']          = {924},

    }

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()

    end

    local function update(id, original)

        if id == 0x111 then
            local parsed = bp.packets.parse('incoming', original)
    
            if parsed then
    
                for i=1, 30 do
                    table.insert(current.list, parsed[string.format('RoE Quest ID %s', i)])
                    table.insert(current.progress, parsed[string.format('RoE Quest Progress %s', i)])

                end
    
            end

        end

    end

    -- Public Methods.
    o.set = function(id)

        if bp and id and tonumber(id) ~= nil then
            bp.packets.inject(bp.packets.new('outgoing', 0x10C, {['RoE Quest']=tonumber(id)}))

        elseif bp and id and type(id) == 'table' then
            local delay = 0

            for _,v in ipairs(id) do
                
                coroutine.schedule(function()
                    bp.packets.inject(bp.packets.new('outgoing', 0x10C, {['RoE Quest']=tonumber(v)}))

                end, delay)
                delay = (delay + 2)

            end
            
        end

    end

    o.remove = function(value)

        if bp and value and tonumber(value) ~= nil then
            bp.packets.inject(bp.packets.new('outgoing', 0x10D, {['RoE Quest']=tonumber(value)}))

        elseif bp and value and type(value) == 'table' then
            local delay = 0

            for id, index in T(value) do
                
                bp.packets.inject:schedule((index * 1.5), function()
                    bp.packets.new('outgoing', 0x10D, {['RoE Quest']=id})
                
                end)

            end

        end

    end

    o.load = function(set)
        if not set then return end

        for records, name in T(list):it() do

            if name:startswith(set:lower()) then

                for id, index in T(records):it() do
                    o.set:schedule((index * 1.5), id)

                end
                break

            end

        end

    end

    o.unload = function(set)

        if bp and set then

            for records, name in T(list):it() do

                if name:startswith(set:lower()) then

                    for id, index in T(records):it() do
                        o.remove:schedule((index * 1.5), id)

                    end
                    break

                end

            end

        end

    end

    -- Private Events.
    --o.events('incoming chunk', update)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
        
        if bp and command and command:lower() == 'records' and #commands > 0 then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command == 'load' and #commands > 0 then
                o.load(table.concat(commands, ' '):lower())

            elseif command == 'unload' and #commands > 0 then
                o.unload(table.concat(commands, ' '):lower())

            elseif command == 'set' and commands[1] then
                o.set(commands[1])

            --elseif command == 'get' and commands[1] and tonumber(commands[1]) and records[tonumber(commands[1])] then
                --bp.popchat.pop(string.format("ROE NAME: \\cs(%s)%s\\cr", bp.colors.setting, records[tonumber(commands[1])]))

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper