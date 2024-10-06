local function lib(bp)
    local o = {}

    -- Private Variables.
    local aggro   = T{}
    local timers  = T{}

    -- Public Variables.

    -- Private Methods.
    local function update(id, original)
        if not S{0x028}:contains(id) then return false end
        local parsed    = bp.packets.parse('incoming', original)
        local actor     = bp.__target.get(parsed['Actor'])
        local target    = bp.__target.get(parsed['Target 1 ID'])
        local claimed   = actor and bp.__target.get(actor.claim_id)
        local pet       = bp.__player.pet()
        
        if actor and target and S{1,6,7,8,11,12,13,14,15}:contains(parsed['Category']) and bp.__target.isEnemy(actor) then            
            
            if bp.__party.isMember(target.name) and (not claimed or bp.__party.isMember(claimed.name)) then
            
                if not aggro:contains(actor.id) then
                    aggro:insert(actor.id)

                end
                timers[actor.id] = os.time()

            elseif pet and pet.id == target.id and (not claimed or bp.__party.isMember(claimed.name)) then

                if not aggro:contains(actor.id) then
                    aggro:insert(actor.id)

                end
                timers[actor.id] = os.time()

            end

        end

    end

    local function remove()

        for id, index in aggro:it() do
            local target = bp.__target.get(id)

            if (not target or T{2,3}:contains(target.status) or bp.__distance.get(target) > 21 or target.status == 0 or not bp.__target.canEngage(target) or (os.time()-timers[id]) >= 5) then
                aggro:remove(index)
                timers[id] = nil

            end

        end

    end

    -- Public Methods.
    o.hasAggro = function()
        return (aggro:length() > 0) and true or false
    
    end

    o.getCount = function()
        return aggro:length()
    
    end

    o.getFirst = function()
        return aggro:first()
        
    end
    
    o.getAggro = function()
        return aggro:copy()
    
    end
    
    o.getList = function()
        local list = S{}

        for index in aggro:it() do
            local target = bp.__target.get(index)

            if target then
                list:add(target.name)
                
            end

        end
        return list

    end

    -- Private Events.
    bp.register('incoming chunk', update)
    bp.register('time change', remove)

    return o

end
return lib