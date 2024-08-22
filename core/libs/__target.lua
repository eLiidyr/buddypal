local function lib(bp)
    local o = {}

    -- Private Variables.
    local radius = assert(package.loadlib(string.format("%sbin/ranges.dll", bp.path):gsub('\\', '/'), "luaopen_IAttackReach"))()

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.
    o.getRadius = radius.GetActorAttackReach
    o.fromIndex = function(i)
        local num = tonumber
        if i and num(i) then
            return ((bp.__player.zone() * 4096) + (16777216 + num(i)))

        end
        return -1
    
    end

    o.fromID = function(i)
        local num = tonumber
        if i and num(i) then
            return (num(i) - ((bp.__player.zone() * 4096) + 16777216))

        end
        return -1
    
    end

    o.get = function(target)
        local bytarget  = windower.ffxi.get_mob_by_target
        local byname    = windower.ffxi.get_mob_by_name
        local byindex   = windower.ffxi.get_mob_by_index
        local byid      = windower.ffxi.get_mob_by_id
        local num       = tonumber
        local type      = type

        if type(target) == 'string' then
            local types = T{'t','bt','st','me','ft','ht','pet'}

            if types:contains(target) and bytarget(target) then
                return bytarget(target)

            elseif num(target) == nil and #target > 1 then

                if byname(target) then
                    return byname(target)

                end

            elseif num(target) ~= nil then
                local target = num(target)

                if byid(target) then
                    return byid(target)
    
                elseif byindex(target) then
                    return byindex(target)
    
                end                

            end

        elseif type(target) == 'number' then
                
            if byid(target) then
                return byid(target)

            elseif byindex(target) then
                return byindex(target)

            end

        elseif type(target) == 'table' then
            
            if target.mob and target.mob then
                return target.mob

            elseif target.id and byid(target.id) then
                return byid(target.id)

            elseif target.index and byindex(target.index) then
                return byindex(target.index)
                
            end

        end
        return false

    end

    o.isEnemy = function(target)
        local target = o.get(target)

        if target and target.spawn_type == 16 then
            return true

        end
        return false

    end

    o.isTrust = function(target)
        local target = o.get(target)

        if target and target.entity_type == 8 and target.spawn_type == 14 and target.charmed == true then
            return true

        end
        return false

    end

    o.isDead = function(target)
        local target = o.get(target)

        if target and target.status and S{2,3}:contains(target.status) then
            return true

        end
        return false

    end

    o.valid = function(target)
        local target = o.get(target)

        if target and type(target) == 'table' and target.distance ~= nil then
            local distance = bp.__distance.get(target)

            if distance > 35 then
                return false
            end

            if not target then
                return false
            end

            if target and target.hpp == 0 then
                return false
            end

            if target and T{2,3}:contains(target.status) then
                return false
            end

            if target and not target.valid_target then
                return false
            end

            if not o.isEnemy(target) and not bp.__party.isMember(target.name) then
                return false
            
            end
            return true

        end
        return false

    end

    o.canEngage = function(target)
        local target = o.get(target)

        if target and o.isEnemy(target) and not target.charmed and not o.isDead(target) and target.valid_target then
            local claimed = bp.__target.get(target.claim_id)

            if (not claimed or bp.__party.isMember(claimed.name) or bp.__buffs.active(603) or bp.__buffs.active(511) or bp.__buffs.active(257) or bp.__buffs.active(267)) then
                return true

            end

        end
        return false

    end

    o.castable = function(target, spell)
        local target = o.get(target)

        if target and spell then
            local spell = type(spell) == 'table' and spell or bp.__res.get(spell)

            if spell and spell.targets then

                for category in T(spell.targets):it() do

                    if category == 'Self' and target.name == bp.__player.name() then
                        return true

                    elseif category == 'Party' and bp.__party.isMember(target.name) then
                        return true

                    elseif category == 'Ally' and bp.__party.isMember(target.name) then
                        return true

                    elseif category == 'Player' and not target.is_npc then
                        return true

                    elseif category == 'NPC' and target.is_npc then
                        return true

                    elseif category == 'Enemy' and o.canEngage(target) then
                        return true

                    elseif category == 'Corpse' and not target.is_npc and T{2,3}:contains(target.status) then
                        return true

                    end

                end

            end

        end
        return false

    end

    o.findNearby = function(targets)
        local targets = S(targets)

        for target in targets:it() do
            local t = bp.__target.get(target)

            if t and bp.__distance.get(t) < 7 then
                return t

            end

        end
        return false

    end

    o.inRange = function(target)
        local player = bp.__player.get(true)
        local target = o.get(target)

        if player and target then
            local range = (o.getRadius(player.index) + (o.getRadius(target.index) - 0.35))
            local zdiff = math.abs(player.z - target.z)
            
            if bp.__distance.get(target) <= math.abs(range - zdiff) then
                return true

            elseif bp.__distance.get(target) <= (range - zdiff) then
                return true

            end

        end
        return false

    end

    o.inRadius = function(target, radius, b)
        local player = bp.__player.position()
        local target = o.get(target)
        local outer = (b == true)

        if player and target and type(target) == 'table' and target.x and target.y then
            local radius = (radius ^ 2) or (6.6 ^ 2)
            local a = ((player.x - target.x) ^ 2)
            local b = ((player.y - target.y) ^ 2)
                
            if ((a + b) > radius) and outer then
                return true

            elseif ((a + b) <= radius) then
                return true
                
            end

        end
        return false

    end

    -- Private Events.

    return o

end
return lib