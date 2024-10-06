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
        settings.follow_speed           = settings:default('follow_speed',          1.50)   -- Set the enhanced follow speed value.
        settings.follow_distance        = settings:default('follow_distance',       2)      -- Minimum distance before it will attempt to walk towards it's target.
        settings.minimum_zone_range     = settings:default('minimum_zone_range',    7)      -- Minimum range a player must be to trigger an injected zoneline.
        settings.follow_zone_delay      = settings:default('follow_zone_delay',     15)     -- Minimum delay after zoning before triggering auto-follow.
        settings.continuous_following   = settings:default('continuous_following',  true)   -- Continue to follow even after status changes, and zoning.
        settings.enhanced_follow_speed  = settings:default('enhanced_follow_speed', true)   -- Makes followers have enhanced speed regardless of their base speed.

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:save():update()

        -- Create timers.
        o.timer('prerender', 0.25)
        o.timer('timeout', 1)

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
        local distance = (settings.follow_distance > 1) and settings.follow_distance or 1

        if target and coords and bp.__distance.get({x=coords[1], y=coords[2], z=coords[3]}) > 0.75 then
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
        local data = commands:concat(""):split('+')

        if data and data:length() == 2 then
            local coords = bp.parse(data[1])
            local zone = tonumber(data[2])

            if not bp.__player.isZoning() and zone and coords and coords.x and coords.y and coords.z and bp.__player.zone() == zone and bp.__distance.get(coords) < 7 then
                bp.actions.move(coords.x, coords.y, coords.z)

                do
                    history.zone    = bp.__player.zone()
                    history.coords  = coords
                    history.target  = follow_target

                end

            end

        end

    end

    local function handleZonelines(id, original)
        if not S{0x05e}:contains(id) then
            return false
        
        end

        if follow_target and follow_target == bp.__player.id() then
            
            coroutine.schedule(function()

                if not bp.__player.isZoning() then
                    bp.orders.send('p*', string.format('/ follow set-following %s', bp.__player.id()))

                end
            
            end, settings.follow_zone_delay + 2)
            bp.orders.send('p*', string.format('/ follow new-zone %s', string.format("%s+%s", bp.stringify(bp.__player.position()), bp.__player.zone())))

        end

    end

    local function handleFollowing(id, original)
        local prerender = o.timer('prerender')
        local timeout = o.timer('timeout')

        if prerender:ready() and follow_target then

            if follow_target == bp.__player.id() then

                if settings.enhanced_follow_speed then
                    local speed = bp.api.getPlayerSpeed(bp.__player.index())
                    bp.orders.send('p*', string.format('/ follow new-coords %s', bp.__player.coords():append((speed or 5.0) * settings.follow_speed):concat("+")))
                    bp.targets.setSpeed(speed)

                else
                    bp.orders.send('p*', string.format('/ follow new-coords %s', bp.__player.coords():concat("+")))

                end

            else

                if settings.enhanced_follow_speed and follow_speed and bp.api.getPlayerSpeed(bp.__player.index()) and follow_speed > bp.api.getPlayerSpeed(bp.__player.index()) then
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
    o.events('unload', cancelFollow)
    o.events('prerender', handleFollowing)
    o.events('status change', handleStatus)
    o.events('outgoing chunk', handleZonelines)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and command == 'follow' then

            if settings[commands[1]] ~= nil then
                settings:fromClient(commands)

            else

                local command = commands[1] and table.remove(commands, 1):lower()

                if command then

                    if command == 'set-following' and #commands > 0 then
                        setFollow(commands)

                    elseif command == 'stop-following' then
                        cancelFollow(true)

                    elseif command == 'new-coords' and #commands > 0 then
                        updateFollowing(commands)

                    elseif command == 'new-zone' and #commands > 0 then
                        zonePlayer(commands)

                    elseif command == 'initiate-follow' then
                        request()
                        
                    end

                end

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper