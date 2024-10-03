local function lib(bp)
    local o = {}

    -- Private Variables.
    local enabled   = false
    local menudata  = {id=nil, option=nil}

    -- Public Variables.
    o.done = {0, 16384, 0, false}

    -- Private Methods.
    local function getOption(id, original)
        if not S{0x05b}:contains(id) then return false end
        local parsed = bp.packets.parse('outgoing', original)

        if parsed['Option Index'] then
            menudata.option = parsed['Option Index']

        end

    end

    local function update(id, original)
        if not S{0x032,0x033,0x034,0x03c,0x05c} then return false end

        if S{0x032,0x033,0x034}:contains(id) then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['Menu ID'] then
                menudata.id = parsed['Menu ID']

            end

        end

        if id == 0x034 and enabled then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['NPC'] then
                local target = bp.__target.get(parsed['NPC'])
                local params = { parsed['Menu Parameters']:unpack('C32') }

                if target and params then
                    local updated = {}

                    -- Unlock Coalitions.
                    if target.name == "Task Delegator" then

                        for i,v in ipairs(params) do
                            
                            if (i < 2 or i > 4) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(150)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Field Manual.
                    elseif target.name == "Field Manual" then

                        for i,v in ipairs(params) do
                            
                            if (i < 2 or i > 25) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(255)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Unlock Sparks.
                    elseif S{'Rolandienne','Isakoth','Fhelm Jobeizat','Eternal Flame'}:contains(target.name) then
            
                        for i,v in ipairs(params) do
                            
                            if (i < 9 or i > 20) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(255)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Unlock Delve Items.
                    elseif target.name == "Forri-Porri" then

                        for i,v in ipairs(params) do
                            
                            if (i < 6 or i > 9) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(255)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Unlock High-Tier Battlefields.
                    elseif (target.name == "Raving Opossum" or target.name == "Trisvain" or target.name == "Mimble-Pimble") then

                        for i,v in ipairs(params) do
                            
                            if (i < 4 or i > 9) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(255)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Ruspix.
                    elseif target.name == 'Ruspix' then

                        for i,v in ipairs(params) do
                            
                            if (i < 4 or i > 9) then
                                updated[i] = ('C'):pack(params[i])
                            else
                                updated[i] = ('C'):pack(255)
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    -- Unlock Nation Items.
                    elseif (target.name:match('I.M.') or target.name:match('T.K.')) then
                        
                        for i,v in ipairs(params) do
                            
                            if (i < 3 or i > 11) then
                                updated[i] = ('C'):pack(params[i])
                            
                            elseif i == 3 then
                                updated[i] = ('C'):pack(255)
                            
                            elseif i == 4 then
                                updated[i] = ('C'):pack(255)
                            
                            elseif i == 5 then
                                updated[i] = ('C'):pack(255)
                            
                            elseif i == 6 then
                                updated[i] = ('C'):pack(255)
                            
                            elseif i == 7 then
                                updated[i] = ('C'):pack(255)
                                
                            elseif i == 8 then
                                updated[i] = ('C'):pack(255)
                                
                            elseif i == 9 then
                                updated[i] = ('C'):pack(182)
                                
                            elseif i == 10 then
                                updated[i] = ('C'):pack(255)
                                
                            elseif i == 11 then
                                updated[i] = ('C'):pack(255)
                                
                            end
                            
                        end
                        parsed['Menu Parameters'] = table.concat(updated, '')
                        return bp.packets.build(parsed)

                    end

                end

            end

        elseif id == 0x03c and enabled then
            local parsed = bp.packets.parse('incoming', original)

            if parsed['Craft Skill 1'] then

                for i=1, 25 do
                    local s = string.format('Craft Skill %s', i)
                    local r = string.format('Craft Rank %s', i)

                    if parsed[s] then
                        parsed[s] = 0
                        parsed[r] = 0

                    end
                
                end
                return bp.packets.build(parsed)

            end

        elseif id == 0x05c and enabled then
            local parsed = bp.packets.parse('incoming', original)
            local update = {}

            -- Aurix.
            if S{3007}:contains(menudata.id) and bp.__player.zone() == 243 then

                if menudata.option == 2 then
                    local params = { parsed['Menu Parameters']:unpack('C32') }

                    for i,v in ipairs(params) do
                        update[i] = ('C'):pack(255)
                        
                    end
                    parsed['Menu Parameters'] = table.concat(update, '')
                    return bp.packets.build(parsed)

                elseif menudata.option == 3 then
                    local params = { parsed['Menu Parameters']:unpack('H16') }

                    for i,v in ipairs(params) do
                        update[i] = ('H'):pack(65535)
                        
                    end
                    parsed['Menu Parameters'] = table.concat(update, '')
                    return bp.packets.build(parsed)

                elseif menudata.option == 4 then
                    local params = { parsed['Menu Parameters']:unpack('H16') }

                    for i,v in ipairs(params) do
                        update[i] = ('H'):pack(65535)
                        
                    end
                    parsed['Menu Parameters'] = table.concat(update, '')
                    return bp.packets.build(parsed)

                elseif menudata.option == 5 then
                    local params = { parsed['Menu Parameters']:unpack('H16') }

                    for i,v in ipairs(params) do
                        update[i] = ('H'):pack(65535)
                        
                    end
                    parsed['Menu Parameters'] = table.concat(update, '')
                    return bp.packets.build(parsed)

                elseif menudata.option == 28 then
                    local params = { parsed['Menu Parameters']:unpack('I8') }

                    for i,v in ipairs(params) do
                        update[i] = ('I'):pack(8)
                        
                    end
                    parsed['Menu Parameters'] = table.concat(update, '')
                    return bp.packets.build(parsed)

                end

            end

        end

    end

    -- Public Methods.
    o.send = function(parsed, options, delay, success)
        local delay = (delay or 0)

        if bp and parsed and options and type(options) == 'table' then
            coroutine.schedule(function()

                for option, index in T(options):it() do
                    local option = T(option)

                    coroutine.schedule(function()
                        bp.packets.inject(bp.packets.new('outgoing', 0x05b, {
                            ['Menu ID']             = parsed['Menu ID'],
                            ['Zone']                = parsed['Zone'],
                            ['Target Index']        = parsed['NPC Index'],
                            ['Target']              = parsed['NPC'],
                            ['Option Index']        = option[1],
                            ['_unknown1']           = option[2],
                            ['_unknown2']           = option[3],
                            ['Automated Message']   = option[4]
            
                        }))
            
                        if success and type(success) == 'function' and index == options:length() then
                            coroutine.schedule(function()
                                success(parsed, options)
                            
                            end, 0.35)
            
                        end

                    end, (index * 0.25))

                end
            
            end, delay)

        end

    end

    o.target = function(target, menu, options, delay, success)
        local delay = (delay or 0)

        if bp and target and menu and options and target.index and target.id and type(options) == 'table' then
            coroutine.schedule(function()

                for option, index in T(options):it() do
                    local option = T(option)

                    coroutine.schedule(function()
                        bp.packets.inject(bp.packets.new('outgoing', 0x05b, {
                            ['Menu ID']             = menu,
                            ['Zone']                = bp.__info.zone(),
                            ['Target Index']        = target.index,
                            ['Target']              = target.id,
                            ['Option Index']        = option[1],
                            ['_unknown1']           = option[2],
                            ['_unknown2']           = option[3],
                            ['Automated Message']   = option[4]
            
                        }))
            
                        if success and type(success) == 'function' and index == options:length() then
                            coroutine.schedule(function()
                                success(parsed, options)
                            
                            end, 0.35)
            
                        end

                    end, (index * 0.25))

                end
            
            end, delay)

        end

    end

    -- Private Events.
    bp.register('incoming chunk', update)
    bp.register('outgoing chunk', getOption)
    bp.register('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and command == 'menus' then
            enabled = (enabled ~= true) and true or false
            bp.toChat("Menus:", 170, tostring(enabled):upper(), 217)

        end
    
    end)

    return o

end
return lib