local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new('bubbles')
    local display   = bp.__displays.new(settings)
    local recast    = {indicolure=false, geocolure=false}
    local targets   = {entrust=false, geocolure=false}

    do -- Setup default setting values.

    end

    -- Public Variables.
    o.list = T(bp.res.spells):map(function(spell) return spell.type == "Geomancy" and spell.en or nil end)

    -- Private Methods.
    local function onload()

    end

    local function updateRecast(id, original)
        if not S{0x028}:contains(id) then
            return false
        
        end
        
        local parsed = bp.packets.parse('incoming', original)
        local id = parsed['Param']

        if parsed and parsed['Category'] == 4 and bp.res.spells[id] then
            local spell = bp.res.spells[id]

            if bp.buffs.get('auto_indicolure') and spell.en == bp.buffs.get('auto_indicolure').name then
                recast.indicolure = false

            elseif bp.buffs.get('auto_geocolure') and spell.en == bp.buffs.get('auto_geocolure').name then
                recast.geocolure = false

            end

        end

    end

    local function outgoing(id, original)
        if not S{0x01a}:contains(id) then
            return false
        
        end

        local parsed = bp.packets.parse('outgoing', original)
        local id = parsed['Param']
        
        if parsed and bp.res.spells[id] then
            local spell = bp.res.spells[id]
            
            if spell.en:startswith("Geo-") then
                local intended = bp.__target.get(parsed['Target'])

                if S{'Self','Party'}:equals(spell.targets) and bp.__target.isEnemy(intended) then
                    parsed['Target'] = bp.__player.id()
                    parsed['Target Index'] = bp.__player.index()
                    return bp.packets.build(parsed)
                    
                elseif S{'Enemy'}:equals(spell.targets) and not bp.__target.isEnemy(intended) then
                    local target = bp.__target.get(bp.targets.get('player')) -- UPDATE.

                    if target then
                        parsed['Target'] = target.id
                        parsed['Target Index'] = target.index
                        return bp.packets.build(parsed)

                    end

                end

            end

        end

    end

    -- Public Methods.

    -- Private Events.
    o.events('incoming chunk', updateRecast)
    o.events('outgoing chunk', outgoing)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper