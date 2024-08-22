local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new('assist')
    local display   = bp.__displays.new(settings)
    local template  = "Assist: cs(200,200,200)${name}cr"

    do -- Setup default setting values.
        settings.display                = settings:default('display',               {x=1, y=1, font=10})
        settings.assist_target          = settings:default('assist_target',         "")
        settings.engage_when_assisting  = settings:default('engage_when_assisting', false)
        settings.minimum_enemy_range    = settings:default('minimum_enemy_range',   4)
        settings.minimum_engage_range   = settings:default('minimum_engage_range',  7)
        settings.disengage_range        = settings:default('disengage_range',       17)

    end

    -- Public Variables.
    local function onload()
        settings:save()
        template = template:gsub('cs[\(]([%d%,]+)[\)]', '\\cs(%1)'):gsub('cr', '\\cr')

        -- Build Timers
        o.timer('check-rate', 1)

        do -- Setup assist display.
            display:pos(settings.display.x, settings.display.y)
            display:text(string.format(" %s", template))

            do -- Setup display values.
                display.name = o.hasTarget() and settings.assist_target or 'None'

            end

        end
        bp.socket.sendSettings({['assist']=settings:get()})

    end

    -- Private Methods.
    local function assist(id, original)
        local timer = o.timer('check-rate')

        if timer and timer:ready() then
            local ally = bp.__target.get(settings.assist_target)

            if ally and ally.target_index > 0 and ally.status == 1 and bp.__distance.get(ally) <= 25 then

                if bp.__player.status() == 0 then
                    local target = bp.__target.get(ally.target_index)
                    
                    if target and bp.__target.canEngage(target) then
                        bp.targets.set(target)

                        if settings.engage_when_assisting and not bp.__buffs.isWeak() and bp.__distance.get(ally) <= settings.minimum_engage_range and bp.__distance.get(target) <= settings.minimum_enemy_range then
                            bp.actions.engage(target)

                        end

                    end

                elseif bp.__player.status() == 1 and bp.__target.get('t') and bp.__target.get('t').index ~= ally.target_index then
                    bp.actions.switchTarget(ally.target_index)

                end

            elseif ally and ally.status == 0 and bp.__player.status() == 1 and bp.__distance.get(ally) <= settings.disengage_range then
                bp.actions.disengage()

            end
            timer:update()

        end

    end

    local function combat(id, original)
        if (not S{0x028}:contains(id) or not o.hasTarget() or not bp.__player.status == 0) then return false end
        local parsed = bp.packets.parse('incoming', original)

        if parsed and S{1,6,7,8,12,13,14,15}:contains(parsed['Category']) then
            local actor     = bp.__target.get(parsed['Actor'])
            local target    = bp.__target.get(parsed['Target 1 ID'])

            if actor and target and bp.__party.isMember(actor.name, true) and bp.__target.isEnemy(target) and actor.name == settings.assist_target then
                local ally = bp.__target.get(settings.assist_target)

                if ally and ally.status == 1 and bp.__distance.get(ally) <= 25 then

                    if bp.__player.status() == 0 then
                        local target = bp.__target.get(target)
                            
                        if target and bp.__target.canEngage(target) then
                            --bp.target.set(target)

                            if settings.engage_when_assisting and not bp.__buffs.isWeak() and bp.__distance.get(ally) <= settings.minimum_engage_range and bp.__distance.get(target) <= settings.minimum_enemy_range then
                                bp.actions.engage(target)

                            end

                        end

                    elseif bp.__player.status() == 1 and bp.__target.get('t') and bp.__target.get('t').index ~= ally.target_index then
                        bp.actions.switchTarget(ally.target_index)

                    end

                elseif ally and ally.status == 0 and bp.__player.status() == 1 and bp.__distance.get(ally) < settings.disengage_range then
                    bp.actions.disengage()

                end

            end

        end

    end

    -- Public Methods.
    o.setAssisting = function(target)
        local target = bp.__target.get(target) or bp.__target.get('t')

        if target and bp.__party.isMember(target.name, true) and target.id ~= bp.__player.id() then
            settings.assist_target = target.name
            display.name = target.name

        else
            settings.assist_target = ''
            display.name = "None"

        end
    
    end
    
    o.getAssisting = function()
        return bp.__target.get(settings.assist_target)
    
    end

    o.clear = function()
        settings.assist_target = ''
        display.name = "None"

    end

    o.hasTarget = function()
        return #settings.assist_target > 0

    end

    -- Private Events.
    o.events('prerender', assist)
    o.events('incoming chunk', combat)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'assist' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if ('engage_when_assisting'):startswith(command) and #commands > 0 then
                    settings.engage_when_assisting = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                elseif ('set'):startswith(command) then
                    o.setAssisting(commands[1])

                elseif ('clear'):startswith(command) then
                    o.clear()

                elseif ('minimum_enemy_range'):startswith(command) and commands[1] and tonumber(commands[1]) then
                    settings.minimum_enemy_range = tonumber(commands[1])

                elseif ('minimum_engage_range'):startswith(command) and commands[1] and tonumber(commands[1]) then
                    settings.minimum_engage_range = tonumber(commands[1])

                elseif ('disengage_range'):startswith(command) and commands[1] and tonumber(commands[1]) then
                    settings.disengage_range = tonumber(commands[1])

                end
                settings:save()

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper