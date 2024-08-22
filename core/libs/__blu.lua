local function lib(bp)
    local o = {}

    -- Private Variables.
    local spells = nil

    -- Public Variables.
    o.diffusion_spells = S{"Cocoon","Metallic Body","Refueling","Feather Barrier","Momento Mori","Zephyr Mantle","Warm-Up","Triumphant Roar","Amplification","Saline Coat","Reactor Cool","Exuviation","Plasma Charge","Animating Wail","Regenration","Battery Charge","Magic Barrier","Fantod","Occultation","Barrier Tusk","Harden Shell","Nature's Medatation","Orcish Counterstance","Carcharian Verve","Pyric Bulwark","Mighty Guard"}
    o.buff_spells = S(T(bp.res.spells):map(function(spell) return (spell and spell.type and spell.status and spell.targets and spell.type == 'BlueMagic' and not T(spell.targets):contains('Enemy')) and spell.en or nil end))

    -- Private Methods.
    local function update(id, original)
        if not S{0x063}:contains(id) then return false end
        local parsed = bp.packets.parse('incoming', original)

        if parsed['Order'] == 10 and (bp.__player.mjob() or bp.__player.sjob()) then
            spells = o.getSpellSet(true)

        end

    end

    -- Public Methods.
    o.getSpells = function()
        if not spells then spells = o.getSpellSet(true) end
        return spells

    end

    o.getSpellSet = function(b)

        if b then

            if bp.__player.mjob() == 'BLU' then
                return S(T(bp.__player.jobdata().spells):map(function(id) return (id ~= 512 and bp.res.spells[id]) and bp.res.spells[id].en or nil end))
            
            elseif bp.__player.sjob() == 'BLU' then
                return S(T(bp.__player.jobdata(true).spells):map(function(id) return (id ~= 512 and bp.res.spells[id]) and bp.res.spells[id].en or nil end))

            end

        else
            
            if bp.__player.mjob() == 'BLU' then
                return S(T(bp.__player.jobdata().spells):filter(function(id) return id ~= 512 end))
            
            elseif bp.__player.sjob() == 'BLU' then
                return S(T(bp.__player.jobdata(true).spells):filter(function(id) return id ~= 512 end))

            end

        end

    end

    o.hasHateSpells = function(spells)
        return o.getSpellSet():filter(function(id) return bp.res.spells[id] and T(spells):contains(bp.res.spells[id].en) end)

    end

    o.getAllBuffs = function()
        return o.buff_spells

    end

    o.getCurrentBuffs = function()
        
        return T(o.getSpells():filter(function(name)
            local spell = bp.__res.get(name)

            if spell and spell.status and not T(spell.targets):contains('Enemy') then
                return name

            end

        end))

    end

    -- Private Events.

    return o

end
return lib