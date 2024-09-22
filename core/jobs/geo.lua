local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    local handleBOG = function()

        if not bp.__player.pet() and bp.core.get('auto_job_abilities') and bp.core.get('blaze-of-glory') and bp.core.isReady("Blaze of Glory") and not bp.queue.search({"Bolster","Blaze of Glory"}) and not bp.__buffs.active({513,569}) and (not bp.core.get('auto_one_hours') or (bp.core.get('auto_one_hours') and not bp.core.isReady("Bolster"))) and bp.actions.canAct() then
            bp.queue.add("Blaze of Glory", bp.__player.get())

        end

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.core.get('auto_one_hours') and bp.actions.canAct() then

            -- BOLSTER.
            if bp.core.isReady("Bolster") and bp.core.get('geocolure') and bp.core.get('auto_buffing') and bp.actions.canCast() and not bp.__player.pet() then
                bp.queue.add("Bolster", player)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()
            local pet = bp.__player.pet()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if pet and not T{2,3}:contains(pet.status) then
                        
                    -- FULL CIRCLE.
                    if bp.core.get('auto_full_circle') and bp.core.get('auto_full_circle').enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") then

                        if (bp.__bubbles.canRecast(true) or bp.core.distance(pet) > bp.core.get('auto_full_circle').distance) then
                            bp.queue.add("Full Circle", player)

                        end

                    end

                    -- ECLIPTIC / LASTING.
                    if bp.core.get('auto_ecliptic_attrition') and bp.core.isReady("Ecliptic Attrition") and not bp.queue.search({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.__buffs.active({513,515,516}) and (not bp.core.get('auto_one_hours') or bp.core.get('auto_one_hours') and not bp.core.isReady("Bolster")) then
                        bp.queue.add("Ecliptic Attrition", player)

                    elseif bp.core.get('auto_lasting_emanation') and bp.core.isReady("Lasting Emanation") and not bp.queue.search({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.__buffs.active({513,515,516}) then
                        bp.queue.add("Lasting Emanation", player)

                    end

                    -- RADIAL / MENDING.
                    if bp.core.get('auto_radial_arcana') and bp.core.get('auto_radial_arcana').enabled and bp.core.isReady("Radial Arcana") and not bp.queue.search({"Radial Arcana","Mending Halation"}) and bp.__player.mpp() < bp.core.get('auto_radial_arcana').mpp and not bp.__buffs.active({513,515,516,569}) then
                        bp.queue.add("Radial Arcana", player)

                    elseif bp.core.get('auto_mending_halation') and bp.core.get('auto_mending_halation').enabled and bp.core.isReady("Mending Halation") and not bp.queue.search({"Radial Arcana","Mending Halation"}) and bp.__player.hpp() < bp.core.get('auto_mending_halation').hpp and not bp.__buffs.active({513,515,516,569}) then
                        bp.queue.add("Mending Halation", player)

                    end

                    -- LIFE CYCLE.
                    if bp.core.get('auto_life_cycle') and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.__player.hpp() > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.__buffs.active({513,515,516,569})) then
                        bp.queue.add("Life Cycle", player)

                    end

                    -- DEMATERIALIZE.
                    if bp.core.get('dematerialize') and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.__buffs.active({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.__buffs.active({513,515,516,569})) then
                        bp.queue.add("Dematerialize", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if pet and not T{2,3}:contains(pet.status) then
                        
                    -- FULL CIRCLE.
                    if bp.core.get('auto_full_circle') and bp.core.get('auto_full_circle').enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") then

                        if (bp.__bubbles.canRecast(true) or bp.core.distance(pet) > bp.core.get('auto_full_circle').distance) then
                            bp.queue.add("Full Circle", player)

                        end

                    end

                    -- ECLIPTIC / LASTING.
                    if bp.core.get('auto_ecliptic_attrition') and bp.core.isReady("Ecliptic Attrition") and not bp.queue.search({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.__buffs.active({513,515,516}) and (not bp.core.get('auto_one_hours') or bp.core.get('auto_one_hours') and not bp.core.isReady("Bolster")) then
                        bp.queue.add("Ecliptic Attrition", player)

                    elseif bp.core.get('auto_lasting_emanation') and bp.core.isReady("Lasting Emanation") and not bp.queue.search({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.__buffs.active({513,515,516}) then
                        bp.queue.add("Lasting Emanation", player)

                    end

                    -- RADIAL / MENDING.
                    if bp.core.get('auto_radial_arcana') and bp.core.get('auto_radial_arcana').enabled and bp.core.isReady("Radial Arcana") and not bp.queue.search({"Radial Arcana","Mending Halation"}) and bp.__player.mpp() < bp.core.get('auto_radial_arcana').mpp and not bp.__buffs.active({513,515,516,569}) then
                        bp.queue.add("Radial Arcana", player)

                    elseif bp.core.get('auto_mending_halation') and bp.core.get('auto_mending_halation').enabled and bp.core.isReady("Mending Halation") and not bp.queue.search({"Radial Arcana","Mending Halation"}) and bp.__player.hpp() < bp.core.get('auto_mending_halation').hpp and not bp.__buffs.active({513,515,516,569}) then
                        bp.queue.add("Mending Halation", player)

                    end

                    -- LIFE CYCLE.
                    if bp.core.get('auto_life_cycle') and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.__player.hpp() > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.__buffs.active({513,515,516,569})) then
                        bp.queue.add("Life Cycle", player)

                    end

                    -- DEMATERIALIZE.
                    if bp.core.get('dematerialize') and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.__buffs.active({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.__buffs.active({513,515,516,569})) then
                        bp.queue.add("Dematerialize", player)

                    end

                end

            end

        end

        return self

    end

    function self:buff()

        if bp.core.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canCast() then

                    if bp.core.get('bubbles') and bp.core.get('bubbles').enabled then
                        local indicolure    = bp.__res.get(bp.bubbles.getIndicolure())
                        local geocolure     = bp.__res.get(bp.bubbles.getGeocolure())
                        local entrust       = bp.__res.get(bp.bubbles.getEntrust())
                        local pet           = bp.__player.pet()

                        -- INDICOLURE BUFFS.
                        if bp.core.get('indicolure') and bp.core.isReady(indicolure) and not bp.core.inQueue(indicolure) and (not bp.__buffs.active(612) or bp.__bubbles.canRecast()) then
                            bp.queue.add(indicolure, player)

                        -- GEOCOLURE BUFFS.
                        elseif bp.core.get('geocolure') and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and not pet and target then
                            local gtarget = bp.__target.get(bp.bubbles.target())

                            if S{'Enemy'}:equals(geocolure.targets) then

                                if (gtarget or target) then

                                    handleBOG()
                                    if (bp.__target.isEnemy(gtarget, false) or bp.__party.isMember(target.name, false)) then
                                        bp.queue.add(geocolure, gtarget or target)

                                    else
                                        bp.queue.add(geocolure, player)

                                    end

                                elseif not gtarget then
                                    handleBOG()
                                    bp.queue.add(geocolure, target)

                                end

                            elseif S{'Self','Party'}:equals(geocolure.targets) then

                                if gtarget then

                                    handleBOG()
                                    if bp.__party.isMember(gtarget.name, false) then
                                        bp.queue.add(geocolure, gtarget)

                                    else
                                        bp.queue.add(geocolure, player)

                                    end

                                elseif not gtarget then
                                    handleBOG()
                                    bp.queue.add(geocolure, player)

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif bp.core.get('entrust') and bp.actions.canAct() and target and bp.bubbles.target(true) then
                            local member = bp.__party.getMember(bp.bubbles.target(true))

                            if member and entrust then
                            
                                if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                    bp.queue.add("Entrust", player)
                                    
                                elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                    bp.queue.add(entrust, member)

                                end

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canCast() then

                    if bp.core.get('bubbles') and bp.core.get('bubbles').enabled then
                        local indicolure    = bp.__res.get(bp.bubbles.getIndicolure())
                        local geocolure     = bp.__res.get(bp.bubbles.getGeocolure())
                        local entrust       = bp.__res.get(bp.bubbles.getEntrust())
                        local pet           = bp.__player.pet()

                        -- INDICOLURE BUFFS.
                        if bp.core.get('indicolure') and bp.core.isReady(indicolure) and not bp.core.inQueue(indicolure) and (not bp.__buffs.active(612) or bp.__bubbles.canRecast()) then
                            bp.queue.add(indicolure, player)

                        -- GEOCOLURE BUFFS.
                        elseif bp.core.get('geocolure') and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and not pet and target then
                            local gtarget = bp.__target.get(bp.bubbles.target())

                            if S{'Enemy'}:equals(geocolure.targets) then

                                if (gtarget or target) then

                                    handleBOG()
                                    if (bp.__target.isEnemy(gtarget, false) or bp.__party.isMember(target, false)) then
                                        bp.queue.add(geocolure, gtarget or target)

                                    else
                                        bp.queue.add(geocolure, player)

                                    end

                                elseif not gtarget then
                                    handleBOG()
                                    bp.queue.add(geocolure, target)

                                end

                            elseif S{'Self','Party'}:equals(geocolure.targets) then

                                if gtarget then

                                    handleBOG()
                                    if bp.__party.isMember(gtarget.name, false) then
                                        bp.queue.add(geocolure, gtarget)

                                    else
                                        bp.queue.add(geocolure, player)

                                    end

                                elseif not gtarget then
                                    handleBOG()
                                    bp.queue.add(geocolure, player)

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif bp.core.get('entrust') and bp.actions.canAct() and target and bp.bubbles.target(true) then
                            local member = bp.__party.getMember(bp.bubbles.target(true))

                            if member and entrust then
                            
                                if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                    bp.queue.add("Entrust", player)
                                    
                                elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                    bp.queue.add(entrust, member)

                                end

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()

        if bp.debuffs.enabled() and bp.actions.canCast() then
            bp.debuffs.cast()

        end

        return self

    end

    function self:enmity()
        return self

    end

    function self:nuke()

        if bp.core.get('auto_nuke_mode') and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.isReady(spell) and not bp.core.inQueue(spell) then
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load