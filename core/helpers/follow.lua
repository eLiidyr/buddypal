local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings      = bp.__settings.new('follow')
    local history       = {zone=false, coords=false}
    local timers        = {loop=0, reset=0}
    local follow_target = nil
    local follow_speed  = nil

    -- Store Follow target information
    local follow_target = false

    do -- Setup default setting values.
        settings.follow_speed           = settings:default('follow_speed',          1.50)   -- .
        settings.follow_distance        = settings:default('follow_distance',       2)      -- Minimum distance before it will attempt to walk towards it's target.
        settings.minimum_zone_range     = settings:default('minimum_zone_range',    7)      -- Minimum range a player must be to trigger an injected zoneline.
        settings.follow_zone_delay      = settings:default('follow_zone_delay',     7)      -- Minimum delay after zoning before triggering auto-follow.
        settings.continuous_following   = settings:default('continuous_following',  true)   -- Continue to follow even after status changes, and zoning.
        settings.enhanced_follow_speed  = settings:default('enhanced_follow_speed', true)   -- .

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        o.timer('prerender', 0.5)
        o.timer('timeout', 1)
        settings:save()
        bp.socket.sendSettings({['follow']=settings:get()})

    end

    local function request()
        bp.orders.send('p', string.format('/ follow set-following %s', bp.__player.id()))

    end

    local function setFollow(commands)
        local target = bp.__target.get(commands[1])

        if target and bp.__distance.get(target) <= 20 then
            o.timer('timeout'):update()

            do
                follow_target   = target.id
                history.zone    = bp.__player.zone()
                history.target  = target

            end

        end

    end

    local function cancelFollow(b)
        follow_target = false
        bp.run(false)

        if b then
            history.target = false
        
        end

    end

    local function updateFollowing(commands)
        if not follow_target then
            return
        end

        local target = bp.__target.get(follow_target)
        local coords = commands:concat(""):split("+")
        local pspeed = tonumber(coords[4]) or bp.api.getPlayerSpeed(bp.__player.index()) or 5

        if target and bp.__distance.get(target) > settings.follow_distance then
            bp.actions.move(coords[1], coords[2], coords[3])

            do
                history.zone      = bp.__player.zone()
                history.coords    = coords
                history.target    = target

            end
            follow_speed = pspeed
            bp.targets.setSpeed(pspeed)

        else
            bp.run(false)
        
        end
        o.timer('timeout'):update()

    end

    local function zonePlayer(commands)
        local data = commands:concat(" "):split("+")
        local zone = bp.__player.zone()

        if #data > 0 and history.zone and history.coords and history.zone == zone then
            local coords = {x=history.coords[1], y=history.coords[2], z=history.coords[3]}

            if bp.__distance.get(coords) <= settings.minimum_zone_range then
                local inject = {}

                for i=1, #data do
                    local split = data[i]:split(":")

                    if #split > 0 and split[1] and split[2] and split[1] ~= "" and split[2] ~= "" then
                        inject[split[1]] = split[2]

                    end

                end
                bp.packets.inject(bp.packets.new('outgoing', 0x05e, inject))

                do
                    history.zone      = bp.__player.zone()
                    history.coords    = coords
                    history.target    = follow_target

                end

            end

        end

    end

    local function handleZonelines(id, original)
        if (not S{0x05E}:contains(id) or not follow_target) then
            return false
        end

        local parsed = bp.packets.parse('outgoing', original)
        
        if parsed then

            if follow_target and follow_target == bp.__player.id() then
                local update;

                for k, v in pairs({['Zone Line']=parsed['Zone Line'], ['MH Door Menu']=parsed['MH Door Menu'], ['Type']=parsed['Type']}) do
                    update = string.format("%s%s:%s+", update or "", k, v)

                end
                bp.orders.send('p*', string.format('/ follow new-zone %s', update))

                -- Send a new request after zoning.
                coroutine.schedule(function()
                    bp.orders.send('p*', string.format('/ follow set-following %s', bp.__player.id()))
                
                end, settings.follow_zone_delay)

            end

        end

    end

    local function handleFollowing(id, original)
        local prerender = o.timer('prerender')
        local timeout = o.timer('timeout')

        if prerender:ready() and follow_target then

            if follow_target == bp.__player.id() then

                if settings.enhanced_follow_speed then
                    local speed = bp.api.getPlayerSpeed(bp.__player.index())
                    bp.orders.send('p*', string.format('/ follow new-coords %s', bp.__player.coords():append(speed * settings.follow_speed):concat("+")))
                    bp.targets.setSpeed(speed)

                else
                    bp.orders.send('p*', string.format('/ follow new-coords %s', bp.__player.coords():concat("+")))

                end

            else

                if settings.enhanced_follow_speed and follow_speed and follow_speed > bp.api.getPlayerSpeed(bp.__player.index()) then
                    bp.api.setPlayerSpeed(bp.__player.index(), follow_speed)
        
                end
                
                if timeout:ready() then
                    return cancelFollow()                

                end

            end
            prerender:update()

        end

    end

    local function handleStatus(n, o)

        if (S{1,2,3,4,38,39,40,41,42,43,44,47}):contains(n) and follow_target then
            cancelFollow()

        elseif n == 0 and o == 1 and settings.alwaysfollow and bp.__player.id() == history.target then
            local target = bp.__target.get(history.target)

            if target and bp.__distance.get(target) <= settings.follow_distance then
                bp.orders.send('p', string.format('/ follow set-following %s', target.id))

            end

        end

    end

    -- Public Methods.

    -- Private Events.
    o.events('prerender', handleFollowing)
    o.events('status change', handleStatus)
    o.events('outgoing chunk', handleZonelines)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'follow' then
            local command = commands[1] and table.remove(commands, 1):lower() or false
            
            if command then

                if command == 'set-following' and #commands > 0 then
                    setFollow(commands)

                elseif command == 'stop-following' then
                    cancelFollow(true)

                elseif command == 'new-coords' and #commands > 0 then
                    updateFollowing(commands)

                elseif command == 'new-zone' and #commands > 0 then
                    zonePlayer(commands)

                elseif command == 'follow_distance' and commands[1] and tonumber(commands[1]) then
                    settings.follow_distance = tonumber(commands[1])

                elseif command == 'minimum_zone_range' and commands[1] and tonumber(commands[1]) then
                    settings.minimum_zone_range = tonumber(commands[1])

                elseif command == 'follow_zone_delay' and commands[1] and tonumber(commands[1]) then
                    settings.follow_zone_delay = tonumber(commands[1])

                elseif command == 'continuous_following' then
                    settings.continuous_following = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                elseif command == 'initiate-follow' then
                    request()

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