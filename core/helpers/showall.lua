local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings    = bp.__settings.new('showall')

    do -- Setup default setting values.
        settings.show_all_npcs      = settings:default('show_all_npcs',         false)
        settings.hide_other_players = settings:default('hide_other_players',    false)
        settings.disable_on_load    = settings:default('disable_on_load',       true)

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:save()

        if settings.disable_on_load then
            settings.hide_other_players = false
            settings.show_all_npcs      = false

        end
        bp.socket.sendSettings({['showall']=settings:get()})

    end

    local function handle(id, original)
        if not S{0x00e,0x00d}:contains(id) then return false end

        if id == 0x00e and settings.show_all_npcs then

            if (original:byte(0x21) == 2 or original:byte(0x21) == 6 or original:byte(0x21) == 7) then
                return original:sub(1, 32) .. '0' .. original:sub(34, 34) .. '0' .. original:sub(36, 41) .. '0' .. original:sub(43)

            end

        elseif id == 0x00d and settings.hide_other_players then
            local parsed = bp.packets.parse('incoming', original)
            local player = bp.__target.get(parsed['Player'])

            if player and not bp.__party.isMember(player.name, true) then
                parsed['Despawn'] = true
                return bp.packets.build(parsed)

            end

        end
    
    end

    -- Public Methods.

    -- Private Events.
    o.events('incoming chunk', handle)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
    
        if command and command:lower() == 'showall' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'show_all_npcs' then
                    settings.show_all_npcs = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                elseif command == 'hide_other_players' then
                    settings.hide_other_players = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                end

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper