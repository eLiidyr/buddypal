local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new('nukes')

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'nukes' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

            end

        end

    end)

    -- Class Specific Events.
    --o.onLoad = onload

    return o

end
return helper