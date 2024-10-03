local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local methods   = {}
    local busy      = false

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        o.timer('event-delay', 1)

    end

    local function unregister(events)
        
        for id in S(events):it() do
            bp.unregister(id)
        
        end
        events = nil

    end

    methods['sparks'] = function(commands)
        if busy then return end
        local events    = {}
        local person    = bp.__target.findNearby({'Rolandienne','Isakoth','Fhelm Jobeizat','Eternal Flame'})
        local timer     = o.timer('event-delay')
        local perform   = false
        if not person then return end

        local function error(p, l)
            if p then bp.__menus.send(p, {bp.__menus.done}, 0) end
            bp.toChat(l, 123)
            unregister(events)
            busy = false

        end

        bp.__currency.get(1, "Sparks of Eminence", function(currency, amount)
            bp.toChat("You have", 170, tostring(amount), 217, "Sparks of Eminence; dumping points with", 170, person.name, 217, "now.", 170)
            local amount = amount

            -- Create menu handler.
            events.menus = bp.register('incoming chunk', function(id, original)
                if not S{0x032,0x034}:contains(id) then return false end
                local parsed = bp.packets.parse('incoming', original)
                local target = bp.__target.get(parsed['NPC'])
                local available = bp.__inventory.getSpace()

                perform = true
                if parsed and target and S{26,5081}:contains(parsed['Menu ID']) then
                    local limit = parsed['Menu Parameters']:sub(21, 24):unpack('I')

                    if limit < 2755 then
                        error(parsed, "Weekly limit has been reached.")

                    elseif available == 0 then
                        error(parsed, "Check inventory space and try again.")
    
                    else
                        amount = (limit < amount) and limit or amount

                        if math.floor(amount / 2755) >= available then
                            local n = available

                            for i=1, n do
                                local time = (1 + (i * 0.15))
    
                                if amount >= 2755 then
                                    bp.__menus.send(parsed, {{9, 41, 0, true}}, time)
                                    amount = (amount - 2755)
    
                                end
    
                                if (i >= n or amount < 2755) then
                                    bp.__menus.send(parsed, {bp.__menus.done}, (time + 1), function() perform = false end)
                                    break

                                end
    
                            end

                        elseif math.floor(amount / 2755) < available then
                            local n = math.floor(amount / 2755)

                            for i=1, n do
                                local time = (1 + (i * 0.15))
    
                                if amount >= 2755 then
                                    bp.__menus.send(parsed, {{9, 41, 0, true}}, time)
                                    amount = (amount - 2755)
    
                                end
    
                                if (i >= n or amount < 2755) then
                                    bp.__menus.send(parsed, {bp.__menus.done}, (time + 1), function() perform = false end)
                                    break

                                end
    
                            end

                        else
                            error(parsed, "Check inventory and try again.")

                        end

                    end
                    return true

                else
                    error(parsed, "Error handling target menu.")

                end

            end)

            -- Create loop event to interact target.
            events.loop = bp.register('time change', function()
                local timer = timer

                if timer:ready() and bp.__player.status() == 0 and not perform then
                    local bag, index, id, status = bp.__inventory.findItem("Acheron")

                    if bag and status and status == 0 then
                        timer:update(bp.__inventory.sellItems({"Acheron Shield"}) + 2)

                    else

                        if amount >= 2755 then
                            local space = bp.__inventory.hasSpace()

                            if space and person and bp.__distance.get(person) < 7 then
                                bp.__actions.perform(person, 'interact', 0)
    
                            elseif not space and bag and status and status == 0 then
                                timer:update(bp.__inventory.sellItems({"Acheron Shield"}) + 2)
    
                            elseif not space then
                                error(false, "You do not have enough inventory space; event ended.")
    
                            end

                        elseif amount < 2755 then
                            timer:update(bp.__inventory.sellItems({"Acheron Shield"}) + 2)
                            error(false, "You do not have enough sparks; event ended.")

                        end

                    end

                end
            
            end)

        end)
        busy = true

    end

    methods['accolades'] = function(commands)
        if busy then return end
        local events    = {}
        local person    = bp.__target.findNearby({'Urbiolaine','Igsli','Teldro-Kesdrodo','Yonolala','Nunaarl Bthtrogg'})
        local perform   = false
        local timer     = o.timer('event-delay')
        if not person then return end

        local function error(p, l)
            if p then bp.__menus.send(p, {bp.__menus.done}, 0) end
            bp.toChat(l, 123)
            unregister(events)
            busy = false

        end

        bp.__currency.get(1, "Unity Accolades", function(currency, amount)
            bp.toChat("You have", 170, tostring(amount), 217, "Unity Accolades; dumping points with", 170, person.name, 217, "now.", 170)
            local amount = amount

            -- Create menu handler.
            events.menus = bp.register('incoming chunk', function(id, original)
                if not S{0x032,0x034}:contains(id) then return false end
                local parsed = bp.packets.parse('incoming', original)
                local target = bp.__target.get(parsed['NPC'])
                local available = bp.__inventory.getSpace()

                perform = true
                if parsed and target and S{598,5149}:contains(parsed['Menu ID']) then
                    local limit = parsed['Menu Parameters']:sub(9, 12):unpack('I')

                    if limit < 10 then
                        error(parsed, "Weekly limit has been reached.")

                    elseif available == 0 then
                        error(parsed, "Check inventory space and try again.")
    
                    else

                        local purchase  = math.floor(amount / 10) <= math.floor(amount / 10) and math.floor(amount / 10) or math.floor(amount / 10)
                        local option    = purchase and math.floor((8580+math.floor(8192*(purchase-1)))%65536) or false
                        local unknown   = purchase and math.floor((8580+math.floor(8192*(purchase-1)))/65536) or false

                        if purchase and math.floor(purchase / 99) > available then
                            purchase    = math.floor(available * 99)
                            option      = purchase and math.floor((8580+math.floor(8192*(purchase-1)))%65536) or false
                            unknown     = purchase and math.floor((8580+math.floor(8192*(purchase-1)))/65536) or false
                        
                        end

                        if option and unknown then
                            bp.__menus.send(parsed, {{387, 0, 0, true}, {option, unknown, 0, true}, bp.__menus.done}, 1, function() perform = false end)
                            amount = (amount - (purchase * 10))


                        else
                            bp.__menus.send(parsed, {bp.__menus.done}, 0, function() perform = false end)

                        end

                    end
                    return true

                else
                    error(parsed, "Error handling target menu.")

                end

            end)

            -- Create loop event to interact target.
            events.loop = bp.register('time change', function()
                local timer = timer

                if timer:ready() and bp.__player.status() == 0 and not perform then
                    local bag, index, id, status = bp.__inventory.findItem("Prize")

                    if bag and status and status == 0 then
                        timer:update(bp.__inventory.sellItems({"Prize Powder"}) + 2)

                    else

                        if amount >= 10 then
                            local space = bp.__inventory.hasSpace()

                            if space and person and bp.__distance.get(person) < 7 then
                                bp.__actions.perform(person, 'interact', 0)
    
                            elseif not space and bag and status and status == 0 then
                                timer:update(bp.__inventory.sellItems({"Prize Powder"}) + 2)
    
                            elseif not space then
                                error(false, "You do not have enough inventory space; event ended.")
    
                            end

                        elseif amount < 10 then
                            timer:update(bp.__inventory.sellItems({"Prize Powder"}) + 2)
                            error(false, "You do not have enough accolades; event ended.")

                        end

                    end

                end
            
            end)

        end)
        busy = true

    end

    methods['scrolls'] = function(commands)
        if busy then return end
        local timer     = o.timer('event-delay')
        local scrolls   = bp.__inventory.findScrolls()

        if scrolls and #scrolls > 0 then

            local function useScrolls()

                if #scrolls > 0 then
                    local spell = bp.__res.get(scrolls[1].res.en)

                    if spell and not bp.__player.hasSpell(spell.id) then
                        local scroll = table.remove(scrolls, 1)
                        
                        if scroll and scroll.status == 0 then
                            bp.actions.useItem(scroll.index, bp.__player.get(), 0)
                            useScrolls:schedule(scroll.res.cast_time + 1.5)

                        elseif scroll and scroll.status ~= 0 then
                            table.remove(scrolls, 1)
                            useScrolls:schedule(0.5)

                        end
                    
                    elseif spell and bp.__player.hasSpell(spell.id) then
                        table.remove(scrolls, 1)
                        useScrolls:schedule(0.5)

                    end

                elseif #scrolls == 0 then
                    bp.toChat("All scrolls have been used; event ended.", 123)

                end

            end
            useScrolls()

        end

    end

    methods['items'] = function(commands)
        if busy then return end
        local timer     = o.timer('event-delay')
        local items     = {}
        local count     = 0

        if commands and #commands > 0 then
            local name = commands:concat(' ')

            for item, index in T(bp.items(0)):it() do

                if type(item) == 'table' and item.id and item.status and item.status == 0 and bp.res.items[item.id] and bp.res.items[item.id].flags then
                    
                    if bp.res.items[item.id].flags:contains('Usable') and bp.res.items[item.id].en:lower():startswith(name:lower()) then
                        table.insert(items, {index=index, count=item.count, status=item.status, bag=0, res=bp.res.items[item.id]})
                        count = (count + item.count)

                    end

                end

            end

            if count > 0 then
                local function useItems()
                    
                    if not bp.__inventory.hasSpace() then
                        return bp.toChat("No enough inventory space; event ended.", 123)
                    
                    end
    
                    if count > 0 then
                        bp.actions.useItem(items[1].index, bp.__player.get(), 0)
                        useItems:schedule(items[1].res.cast_time + 1.5)
                        count = (count - 1)
    
                    elseif count == 0 then
                        bp.toChat("No more usable items found; event ended.", 123)
    
                    end
    
                end
                useItems()

            else
                bp.toChat("No usable items found; event ended.", 123)
    
            end

        end

    end

    -- Public Methods.
    o.doEvent = function(n, ...)
        local e = nil
        
        if e and type(e) == 'function' then
            methods[n](T{...})

        end

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'do' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command and methods[command] then
                methods[command](commands)

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper