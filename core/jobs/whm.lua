local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        -- ONE-HOURS.
        if player and target and bp.core.get('one-hours') and bp.actions.canAct() then
            local benediction = bp.cures.getWeight()

            if bp.core.get('benediction') and bp.core.get('benediction').enabled and bp.core.ready("Benediction") and bp.__player.mpp() < bp.core.get('benediction').mpp and benediction.count >= bp.core.get('benediction').targets and benediction.weight >= bp.core.get('benediction').weight then
                bp.queue.add("Benediction", bp.__player.get())

            end
            
            if bp.core.get('asylum') and bp.core.ready("Asylum", 492) then
                bp.queue.add("Asylum", target)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- MARTYR.
                if bp.core.get('martyr') and bp.core.get('martyr').enabled and bp.core.ready("Martyr") then
                    local target = bp.core.getTarget(bp.core.get('martyr').target)
                    local hpp = bp.core.get('martyr').hpp

                    if target and bp.__player.hpp() >= 50 and target.hpp <= hpp and bp.__party.isMember(target.name) then
                        bp.queue.add("Martyr", target)

                    end

                end

                -- DEVOTION.
                if bp.core.get('devotion') and bp.core.get('devotion').enabled and bp.core.ready("Devotion") then
                    local target = bp.core.getTarget(bp.core.get('devotion').target)
                    local mpp = bp.core.get('devotion').mpp

                    if target and bp.__player.hpp() >= 50 and target.mpp <= mpp and bp.__party.isMember(target.name) then
                        bp.queue.add("Devotion", target)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.__target.get('t')

                -- MARTYR.
                if bp.core.get('martyr') and bp.core.get('martyr').enabled and bp.core.ready("Martyr") then
                    local target = bp.core.getTarget(bp.core.get('martyr').target)
                    local hpp = bp.core.get('martyr').hpp

                    if target and bp.__player.hpp() >= 50 and target.hpp <= hpp and bp.__party.isMember(target.name) then
                        bp.queue.add("Martyr", target)

                    end

                end

                -- DEVOTION.
                if bp.core.get('devotion') and bp.core.get('devotion').enabled and bp.core.ready("Devotion") then
                    local target = bp.core.getTarget(bp.core.get('devotion').target)
                    local mpp = bp.core.get('devotion').mpp

                    if target and bp.__player.hpp() >= 50 and target.mpp <= mpp and bp.__party.isMember(target.name) then
                        bp.queue.add("Devotion", target)

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

                if bp.actions.canAct() then

                    -- AFFLATUS SOLACE.
                    if bp.core.get('solace') and bp.core.ready("Afflatus Solace", 417) then
                        bp.queue.add("Afflatus Solace", player)

                    -- AFFLATUS MISEERY.
                    elseif bp.core.get('misery') and bp.core.ready("Afflatus Misery", {417,418}) then
                        bp.queue.add("Afflatus Misery", player)

                    -- SACROSANCTITY.
                    elseif bp.core.get('sacrosanctity') and bp.core.ready("Sacrosanctity", 477) and target then
                        bp.queue.add("Sacrosanctity", player)

                    end

                end

                if bp.actions.canCast() then
                    local boost = bp.core.get('boost')

                    -- RERAISE.
                    if bp.core.get('reraise') and not bp.__buffs.active(113) and not bp.queue.search("Reraise") then
                        local spent = bp.__player.jp().jp_spent

                        if bp.__player.hasSpell('Reraise IV') then
                            
                            if bp.core.ready("Reraise IV") then
                                bp.queue.add("Reraise IV", player)

                            end

                        elseif bp.__player.hasSpell('Reraise III') then 
                            
                            if bp.core.ready("Reraise III") then
                                bp.queue.add("Reraise III", player)

                            end

                        elseif bp.__player.hasSpell('Reraise II') then
                            
                            if bp.core.ready("Reraise II") then
                                bp.queue.add("Reraise II", player)

                            end

                        elseif bp.__player.hasSpell('Reraise') then
                            
                            if bp.core.ready("Reraise") then
                                bp.queue.add("Reraise", player)

                            end

                        end

                    end

                    -- BOOST.
                    if boost and boost.enabled and bp.core.isReady(boost.name) and bp.__res.get(boost.name) then
                        local spell = bp.__res.get(boost.name)
                        
                        if not bp.__buffs.hasWHMBoost() then
                            bp.queue.add(spell.en, player)

                        elseif bp.__buffs.hasWHMBoost() and not bp.__buffs.active(spell.status) then
                            bp.queue.add(spell.en, player)

                        end

                    end

                    -- AUSPICE.
                    if bp.core.get('auspice') and bp.core.ready("Auspice", 275) then
                        bp.queue.add("Auspice", player)
                        
                    -- BLINK.
                    elseif bp.core.get('auto_blink') and bp.core.ready("Blink", 36) and not bp.__buffs.hasShadows() then
                        bp.queue.add("Blink", player)

                    -- AQUAVEIL.
                    elseif bp.core.get('aquaveil') and bp.core.ready("Aquaveil", 39) then
                        bp.queue.add("Aquaveil", player)

                    -- STONESKIN.
                    elseif bp.core.get('auto_stoneskin') and bp.core.ready("Stoneskin", 37) then
                        bp.queue.add("Stoneskin", player)
                        
                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- AFFLATUS SOLACE.
                    if bp.core.get('solace') and bp.core.ready("Afflatus Solace", 417) then
                        bp.queue.add("Afflatus Solace", player)

                    -- AFFLATUS MISEERY.
                    elseif bp.core.get('misery') and bp.core.ready("Afflatus Misery", {417,418}) then
                        bp.queue.add("Afflatus Misery", player)

                    -- SACROSANCTITY.
                    elseif bp.core.get('sacrosanctity') and bp.core.ready("Sacrosanctity", 477) and target then
                        bp.queue.add("Sacrosanctity", player)

                    end

                end

                if bp.actions.canCast() then
                    local boost = bp.core.get('boost')

                    -- RERAISE.
                    if bp.core.get('reraise') and not bp.__buffs.active(113) and not bp.queue.search("Reraise") then
                        local spent = bp.__player.jp().jp_spent

                        if bp.__player.hasSpell('Reraise IV') then
                            
                            if bp.core.ready("Reraise IV") then
                                bp.queue.add("Reraise IV", player)

                            end

                        elseif bp.__player.hasSpell('Reraise III') then 
                            
                            if bp.core.ready("Reraise III") then
                                bp.queue.add("Reraise III", player)

                            end

                        elseif bp.__player.hasSpell('Reraise II') then
                            
                            if bp.core.ready("Reraise II") then
                                bp.queue.add("Reraise II", player)

                            end

                        elseif bp.__player.hasSpell('Reraise') then
                            
                            if bp.core.ready("Reraise") then
                                bp.queue.add("Reraise", player)

                            end

                        end

                    end

                    -- BOOST.
                    if boost and boost.enabled and bp.core.isReady(boost.name) and bp.__res.get(boost.name) then
                        local spell = bp.__res.get(boost.name)
                        
                        if not bp.__buffs.hasWHMBoost() then
                            bp.queue.add(spell.en, player)

                        elseif bp.__buffs.hasWHMBoost() and not bp.__buffs.active(spell.status) then
                            bp.queue.add(spell.en, player)

                        end

                    end
                        

                    -- AUSPICE.
                    if bp.core.get('auspice') and bp.core.ready("Auspice", 275) then
                        bp.queue.add("Auspice", player)
                        
                    -- BLINK.
                    elseif bp.core.get('auto_blink') and bp.core.ready("Blink", 36) and not bp.__buffs.hasShadows() then
                        bp.queue.add("Blink", player)

                    -- AQUAVEIL.
                    elseif bp.core.get('aquaveil') and bp.core.ready("Aquaveil", 39) then
                        bp.queue.add("Aquaveil", player)

                    -- STONESKIN.
                    elseif bp.core.get('auto_stoneskin') and bp.core.ready("Stoneskin", 37) then
                        bp.queue.add("Stoneskin", player)
                        
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
        local timer = bp.core.timer('enmity')

        if bp.core.get('auto_enmity_generation') and bp.core.get('auto_enmity_generation').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- FLASH.
                if bp.core.get('flash') and bp.core.ready("Flash") and bp.actions.canCast() then
                    bp.queue.add("Flash", target)
                    timer:update()

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- FLASH.
                if bp.core.get('flash') and bp.core.ready("Flash") and bp.actions.canCast() then
                    bp.queue.add("Flash", target)
                    timer:update()

                end

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('nuke-mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

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