local function lib(bp)
    local o = {}

    -- Private Variables.

    -- Public Variables.

    -- Private Methods.
    o.get = function(target)
        local t = (target and type(target) == 'table' and target.x and target.y and target.z) and target or bp.__target.get(target)
        local p = bp.__player.position()

        if p and t and p.x and p.y and p.z and t.x and t.y and t.z then
            return ((V{p.x, p.y, p.z*-1} - V{t.x, t.y, (t.z*-1)}):length())
        
        end
        return 65535

    end

    o.pet = function(target)
        local t = (target and target.x and target.y and target.z) and target or bp.__target.get(target)
        local p = bp.__target.get('pet')

        if p and t then
            return ((V{p.x, p.y, (p.z*-1)} - V{t.x, t.y, (t.z*-1)}):length())
        
        end
        return 65535

    end

    o.height = function(target)
        local abs = math.abs
        local player = bp.__player.get(true)

        if player and target and player.z and target.z then
            return abs(target.z - player.z)
        
        end
        return 65535

    end

    -- Public Methods.

    -- Private Events.

    return o

end
return lib