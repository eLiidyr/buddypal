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