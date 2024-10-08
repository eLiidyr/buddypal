local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings      = bp.__settings.new('targets')
    local display       = bp.__displays.new(settings)
    local targets       = {player=false, luopan=false, entrust=false}
    local template      = "<cs(200,200,200)${tdistance}cr>   {{ cs(200,200,200)${tspeed}cr }}   [ cs(200,200,200)0x${tindex}cr ]: cs(200,200,200)${tname}cr"
    local current_speed = nil

    do -- Handle Settings.
        settings.display        = settings:default('display',         {x=1, y=1, font=10})
        settings.share_target   = settings:default('share_target',    false)

    end

    -- Public Variables.

    -- Private Methods.
    local function getIndex(idx)
        local band = bit.band
        return string.format("%04x", band(idx, 0xffff))

    end

    local function getDistance(distance)
        return string.format("%05.2f", distance or 0)
    
    end

    local function getSpeed()
        return string.format("%03d%%", (bp.__player.status() == 5 or bp.__player.status() == 85) and (100 * (current_speed or bp.__player.speed()) / 2):round(2) or (100 * (current_speed or bp.__player.speed()) / 5):round(2))

    end

    local function onload()
        settings:save()
        template = template:gsub('cs[\(]([%d%,]+)[\)]', '\\cs(%1)'):gsub('cr', '\\cr')

        do -- Setup target display.
            display:pos(settings.display.x, settings.display.y)
            display:text(template)

            do -- Setup display values.
                display.tname       = "NONE"
                display.tindex      = getIndex(0)
                display.tdistance   = getDistance()
                display.tspeed      = getSpeed()

            end

        end
        bp.socket.sendSettings({['targets']=settings:get()})

    end

    local function onSet(target, sharing)
        targets.player = target

        if settings.share_target and target and sharing then
            bp.orders.send('r*', string.format('/ target sharing %s', target))
            return target

        end
        return false

    end

    local function updateDistance()
        local target = bp.__target.get('t')

        if target then
            display.tdistance = getDistance(bp.__distance.get(target))

        elseif display.tdistance ~= "000.00" then
            display.tdistance = getDistance()

        end
        display.tspeed = getSpeed()

    end

    local function target_change(index)
        local target = bp.__target.get(index)
        
        if target then
            display.tname = target.name
            display.tindex = getIndex(target.index)

        else

            if not targets.player then
                display.tname = "NONE"
                display.tindex = getIndex(0)

            elseif bp.__target.get(targets.player) then
                local target = bp.__target.get(targets.player)
                display.tname = target.name
                display.tindex = getIndex(target.index)

            end

        end

    end

    local function status_change(n, o)
        
        if n == 0 and o == 1 then
            targets.player = false

        end

    end

    local function update_targets(id, original)
        if not S{0x015}:contains(id) then
            return false
        end

        local t = bp.__target.get('t')

        if bp.__player.status() == 1 and not targets.player and t then
            o.set(t.id, true)

        end

        if targets.player and bp.__target.get(targets.player) then
            local target = bp.__target.get(targets.player)

            if (not bp.__target.valid(target) or bp.__distance.get(target) > 45 or bp.__target.isDead(target)) then
                o.set(false, false)

            end

        end
        updateDistance()

    end

    -- Public Methods.
    o.get = function(f)
        return targets[f] and bp.__target.get(targets[f]) or false
    
    end

    o.getCombatTarget = function()
        return (bp.__player.status() == 1) and bp.__player.target('t') or o.get('player')

    end
    
    o.set = function(target, sharing)
        local target = bp.__target.get(target)

        if target and target.index ~= bp.__player.index() and not bp.__party.isMember(target.name) then
            
            if bp.__target.valid(target) and bp.__target.canEngage(target) then
                return onSet(target.id, sharing)

            end

        elseif (not target or (target and target.index == bp.__player.index())) then
            return onSet(false, sharing)

        end

    end

    o.setSpeed = function(speed)
        current_speed = speed

    end

    -- Private Events.
    o.events('target change', target_change)
    o.events('outgoing chunk', update_targets)
    o.events('status change', status_change)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
    
        if command and command:lower() == 'target' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then
                
                if command == 'share_target' then
                    settings.share_target = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                elseif command == 'set' then
                    o.set(commands[1], true)

                elseif command == 'sharing' then
                    o.set(commands[1], false)

                end

            end
            settings:save()

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper