local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new('zoning')
    local towns     = S{26,48,50,53,70,71,80,87,94,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,252,256,257,280,281,284,251}
    local escha     = S{288,289,291,292,293}
    local jails     = S{131}

    do -- Setup default setting values.
        settings.disable_automation_on_zone = settings:default('disable_automation_on_zone', true)

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:save()
        bp.socket.sendSettings({['zoning']=settings:get()})

    end

    local function disable_addon()

        if settings.disable_automation_on_zone then
            bp.enabled = false

        end

    end

    -- Public Methods.
    o.isInJail = function()
        return jails:contains(bp.__player.zone())

    end

    o.isInTown = function()
        return towns:contains(bp.__player.zone())

    end

    o.isInEscha = function()
        return escha:contains(bp.__player.zone())

    end

    -- Private Events.
    o.events('zone change', disable_addon)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper