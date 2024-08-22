local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local mounts = {}

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        mounts = T(S(T(bp.keyitems()):map(function(id) return (id ~= 3055 and bp.res.key_items[id] and bp.res.key_items[id].category == 'Mounts') and (bp.res.key_items[id].en:gsub("♪", ""):gsub(" companion", "")) or nil end)))
        math.randomseed(os.time())

    end

    local function getMounts()
        return T(S(T(bp.keyitems()):map(function(id) return (id ~= 3055 and bp.res.key_items[id] and bp.res.key_items[id].category == 'Mounts') and (bp.res.key_items[id].en:gsub("♪", ""):gsub(" companion", "")) or nil end)))

    end

    local function updateMounts(id, original)
        if not S{0x055}:contains(id) then return false end

        if bp.keyitems()[3055] then
            mounts = getMounts()

        end

    end

    -- Public Methods.
    o.mount = function()
        bp.cmd(string.format("%s", mounts[math.random(1, mounts:length())]))

    end

    o.unmount = function()
        bp.cmd('input /dismount')

    end

    -- Private Events.
    o.events('incoming chunk', updateMounts)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'mounts' then
            bp.cmd(string.format("%s", mounts[math.random(1, mounts:length())]))

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper