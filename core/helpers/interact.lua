local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local targets       = {}
    local interaction   = bp.newEvent()
    local messages      = {"./","Got it.","Ready","Lezgo",".","I'm Ready.","Let's go!",".//","got","ready","rdy","Let's gooooooooooooooo!","go","headin in","Heading in"}
    local random        = math.random(1, #messages)

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function generateMessage()

        if messages[random] then
            bp.cmd:schedule(1, string.format("input /p %s", messages[random]))

        end

    end

    targets['Rytaal'] = function(action)
        local actions = {}

        actions['tag'] = function(parsed)

            if not bp.__inventory.hasKeyItem(787) and parsed['Menu ID'] == 268 then

                if not bp.__inventory.hasKeyItem({762,763,764,765,766,878}) then
                    bp.__menus.send(parsed, {{1, 0, 0, false}})
                    bp.toChat("Requesting Key Item:", 170, "Imperial Army I.D. Tag", 217)
                    generateMessage()

                else
                    bp.__menus.send(parsed, {{0, 0, 0, false}})
                    bp.toChat("You already have:", 150, "Assault Orders", 217)

                end

            else

                if bp.__inventory.hasKeyItem(787) then
                    bp.toChat("You already have:", 150, "Imperial Army I.D. Tag", 217)

                end
                bp.__menus.send(parsed, {{0, 0, 0, false}})
    
            end

        end
        return actions[action]

    end

    targets['Sorrowful Sage'] = function(action)
        local actions = {}

        actions['orders'] = function(parsed)

            if not bp.__inventory.hasKeyItem(878) and bp.__inventory.hasKeyItem(787) and parsed['Menu ID'] == 278 then
                bp.__menus.send(parsed, {{817, 0, 0, false}})
                bp.toChat("Requesting Key Item:", 170, "Nyzul Isle Assault Orders", 217)
                generateMessage()
    
            else

                if bp.__inventory.hasKeyItem(878) then
                    bp.toChat("You already have:", 150, "Assault Orders", 217)

                elseif not bp.__inventory.hasKeyItem(787) then
                    bp.toChat("You do not have:", 150, "Imperial Army I.D. Tag", 217)

                end
                bp.__menus.send(parsed, {{0, 0, 0, false}})
    
            end

        end
        return actions[action]

    end

    local function buy(commands)
        
        if #commands > 0 then
            local action = commands[1] and table.remove(commands, 1):lower()
            local target = #commands > 0 and table.concat(commands, ' ')

            if action and target then

                for mob in T(bp.mob_array()):it() do

                    if mob.name:lower() == target then
                        target = mob
                        break
                        
                    end

                end

                if target and type(target) == 'table' and __targets[target.name] then
                    local act = targets[target.name](action)

                    if act and type(act) == 'function' then

                        o.poke(target, true, function(parsed)
                            act(parsed)
                        
                        end)

                    end

                end

            end

        end

    end

    -- Public Methods.
    o.poke = function(target, block, success)
        local target = bp.__target.get(target)

        if target and bp.__player.status() == 0 and bp.__distance.get(target) < 7 then
            
            if not interaction.active() then
                
                interaction.new('incoming chunk', function(id, original)
                    if not S{0x032,0x033,0x034}:contains(id) then return false end
                    local parsed = bp.packets.parse('incoming', original)

                    interaction.delete()
                    if parsed and target and parsed['NPC Index'] == target.index then

                        if success and type(success) == 'function' then
                            success(parsed, target)

                        end
                        return block and true or bp.packets.build(parsed)
                        
                    end

                end)

            end
            bp.actions.perform(target, 'interact', 0)

        end

    end

    o.trade = function(target, items, block, success)
        local target = bp.__target.get(target)

        if target and bp.__player.status() == 0 and bp.__distance.get(target) < 7 then
            
            if not interaction.active() then
                
                interaction.new('incoming chunk', function(id, original)
                    if not S{0x032,0x033,0x034}:contains(id) then return false end
                    local parsed = bp.packets.parse('incoming', original)

                    interaction.delete()
                    if parsed and target and parsed['NPC Index'] == target.index and success and type(success) == 'function' then
                        success(parsed, target)
                        return block and true or bp.packets.build(parsed)

                    end

                end)

            end

            if items and items[1] and type(items[1]) == 'table' then
                bp.actions.tradeItems(target, table.unpack(items))

            else
                bp.actions.tradeItems(target, items)

            end

        end

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'interact' then
            local command = commands[1] and table.remove(commands, 1):lower() or false
            
            if command then

                if command == 'poke' and #commands > 0 then
                    o.poke(commands[1], false)

                elseif command == 'buy' and #commands > 0 then
                    buy(commands)

                end

            elseif not command then
                local target = bp.__target.get('t')

                if target and target.id then
                    bp.orders.send('rr', bp.fmt('/ interact poke %d', target.id))
                
                end

            end

        end

    end)

    -- Class Specific Events.

    return o

end
return helper