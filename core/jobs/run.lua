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

        if player and target and bp.core.get('one-hours') and bp.actions.canAct() then

            if bp.core.get('elemental-sforzo') and bp.core.ready("Elemental Sforzo", 522) and target then
                bp.queue.add("Elemental Sforzo", player)

            end
            
            if bp.core.get('odyllic-subterfuge') and bp.core.ready("Odyllic Subterfuge", 509) and target then
                bp.queue.add("Odyllic Subterfuge", target)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- VIVACIOUS PULSE.
                if bp.core.get('vivacious-pulse') and bp.core.get('vivacious-pulse').enabled and bp.core.ready("Vivacious Pulse") then

                    if bp.__runes.get():contains("Tenebrae") then
                                
                        if bp.__player.hpp() <= bp.core.get('vivacious-pulse').hpp and bp.__player.mpp() <= bp.core.get('vivacious-pulse').mpp then
                            bp.queue.add("Vivacious Pulse", player)
                        end

                    else

                        if bp.__player.hpp() <= bp.core.get('vivacious-pulse').hpp then
                            bp.queue.add("Vivacious Pulse", player)
                        end

                    end
                    
                end

                -- RAYKE.
                if bp.core.get('rayke') and bp.core.ready("Rayke", {536,571}) and not bp.queue.search({"Rayke","Gambit"}) and bp.__runes.count() == 3 and target then
                    bp.queue.add("Rayke", target)

                -- GAMBIT.
                elseif bp.core.get('gambit') and bp.core.ready("Rayke", {536,571}) and not bp.queue.search({"Rayke","Gambit"}) and bp.__runes.count() == 3 and target then
                    bp.queue.add("Gambit", target)

                end

                -- SWIPE. NEEDS UPDATE!!
                if bp.core.get('swipe') and bp.core.ready("Swipe") and not bp.queue.search({"Swipe","Lunge"}) and bp.__runes.count() > 0 and (not bp.core.get('mb') or bp.core.get('mb') and not bp.core.get('mb').enabled) and target then
                    bp.queue.add("Swipe", target)

                -- LUNGE. NEEDS UPDATE!!
                elseif bp.core.get('lunge') and bp.core.ready("Lunge") and not bp.queue.search({"Swipe","Lunge"}) and bp.__runes.count() == 3 and (not bp.core.get('mb') or bp.core.get('mb') and not bp.core.get('mb').enabled) and target then
                    bp.queue.add("Lunge", target)

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- VIVACIOUS PULSE.
                if bp.core.get('vivacious-pulse') and bp.core.get('vivacious-pulse').enabled and bp.core.ready("Vivacious Pulse") then

                    if bp.__runes.get():contains("Tenebrae") then
                                
                        if bp.__player.hpp() <= bp.core.get('vivacious-pulse').hpp and bp.__player.mpp() <= bp.core.get('vivacious-pulse').mpp then
                            bp.queue.add("Vivacious Pulse", player)
                        end

                    else

                        if bp.__player.hpp() <= bp.core.get('vivacious-pulse').hpp then
                            bp.queue.add("Vivacious Pulse", player)
                        end

                    end
                    
                end

                -- RAYKE.
                if bp.core.get('rayke') and bp.core.ready("Rayke", {536,571}) and not bp.queue.search({"Rayke","Gambit"}) and bp.__runes.count() == 3 and target then
                    bp.queue.add("Rayke", target)

                -- GAMBIT.
                elseif bp.core.get('gambit') and bp.core.ready("Rayke", {536,571}) and not bp.queue.search({"Rayke","Gambit"}) and bp.__runes.count() == 3 and target then
                    bp.queue.add("Gambit", target)

                end

                -- SWIPE. NEEDS UPDATE!!
                if bp.core.get('swipe') and bp.core.ready("Swipe") and not bp.queue.search({"Swipe","Lunge"}) and bp.__runes.count() > 0 and (not bp.core.get('mb') or bp.core.get('mb') and not bp.core.get('mb').enabled) and target then
                    bp.queue.add("Swipe", target)

                -- LUNGE. NEEDS UPDATE!!
                elseif bp.core.get('lunge') and bp.core.ready("Lunge") and not bp.queue.search({"Swipe","Lunge"}) and bp.__runes.count() == 3 and (not bp.core.get('mb') or bp.core.get('mb') and not bp.core.get('mb').enabled) and target then
                    bp.queue.add("Lunge", target)

                end

            end

        end

        return self

    end

    function self:buff()
        local player = bp.__player.get()

        if bp.core.get('buffing') then

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- RUNES.
                    if bp.core.get('runes') and bp.core.ready("Ignis") and bp.__runes.count() < bp.__runes.max() then
                        local runes = bp.__runes.missing()

                        if runes:length() > 0 then

                            for i=1, runes:length() do
                                bp.queue.add(runes[i], bp.__player.get())
                                break

                            end

                        end

                    end

                    -- SWORDPLAY.
                    if bp.core.get('swordplay') and bp.core.ready("Swordplay", 532) and target then
                        bp.queue.add("Swordplay", bp.__player.get())

                    end

                    -- BATTUTA.
                    if bp.core.get('battuta') and bp.core.ready("Battuta", 570) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Battuta", bp.__player.get())

                    end

                    -- VALIANCE.
                    if bp.core.get('valiance') and bp.core.ready("Valiance", {535,537}) and not bp.queue.search({"Valiance","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Valiance", bp.__player.get())

                    end

                    -- VALLATION.
                    if bp.core.get('vallation') and bp.core.ready("Vallation", {531,537}) and not bp.queue.search({"Vallation","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Vallation", bp.__player.get())

                    end

                    -- LIEMENT.
                    if bp.core.get('liement') and bp.core.ready("Liement", {531,535,537}) and not bp.queue.search({"Valiance","Vallation","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Liement", bp.__player.get())

                    end

                    -- PFLUG.
                    if bp.core.get('pflug') and bp.core.ready("Pflug", 535) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Pflug", bp.__player.get())

                    end

                    -- EMBOLDEN.
                    if bp.core.get('embolden') and bp.core.get('embolden').enabled and bp.core.ready("Embolden", 534) and target then
                        local spell = bp.__res.get(bp.core.get('embolden').name)

                        if spell and bp.core.ready(spell.en, spell.status) and bp.actions.canCast() then
                            bp.queue.add("Embolden", bp.__player.get())
                            bp.queue.add(spell, bp.__player.get())

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.core.ready("Crusade", 289) and target then
                        bp.queue.add("Crusade", player)

                    end

                    -- TEMPER.
                    if bp.core.get('temper') and bp.core.ready("Temper", 432) and target then
                        bp.queue.add("Temper", player)
                    
                    -- PHALANX.
                    elseif bp.core.get('phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", player)
                        
                    -- REFRESH.
                    elseif bp.core.get('refresh') and bp.core.ready("Refresh", {43,187,188}) then
                        bp.queue.add("Refresh", player)

                    -- REGEN.
                    elseif bp.core.get('regen') and not bp.__buffs.active(42) then

                        if bp.__player.mlvl() >= 99 and bp.core.ready("Regen IV") then
                            bp.queue.add("Regen IV", player)

                        elseif bp.__player.mlvl() >= 70 and bp.__player.mlvl() < 99 and bp.core.ready("Regen III") then
                            bp.queue.add("Regen III", player)

                        elseif bp.__player.mlvl() >= 48 and bp.__player.mlvl() < 70 and bp.core.ready("Regen II") then
                            bp.queue.add("Regen II", player)

                        elseif bp.__player.mlvl() < 48 and bp.core.ready("Regen") then
                            bp.queue.add("Regen", player)

                        end

                    -- SPIKES.
                    elseif bp.core.get('spikes') and bp.core.get('spikes').enabled and not bp.__buffs.hasSpikes() then
                        local spikes = bp.__res.get(bp.core.get('spikes').name)

                        if spikes and bp.core.ready(spikes.en) then
                            bp.queue.add(spikes.en, player)

                        end
                        
                    -- BLINK.
                    elseif bp.core.get('blink') and bp.core.ready("Blink", 36) and not bp.__buffs.hasShadows() then
                        bp.queue.add("Blink", player)

                    -- AQUAVEIL.
                    elseif bp.core.get('aquaveil') and bp.core.ready("Aquaveil", 39) then
                        bp.queue.add("Aquaveil", player)

                    -- STONESKIN.
                    elseif bp.core.get('stoneskin') and bp.core.ready("Stoneskin", 37) then
                        bp.queue.add("Stoneskin", player)
                        
                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- RUNES.
                    if bp.core.get('runes') and bp.core.ready("Ignis") and bp.__runes.count() < bp.__runes.max() then
                        local runes = bp.__runes.missing()

                        if runes:length() > 0 then

                            for i=1, runes:length() do
                                bp.queue.add(runes[i], player)
                                break

                            end

                        end

                    end

                    -- SWORDPLAY.
                    if bp.core.get('swordplay') and bp.core.ready("Swordplay", 532) and target then
                        bp.queue.add("Swordplay", player)

                    end

                    -- BATTUTA.
                    if bp.core.get('battuta') and bp.core.ready("Battuta", 570) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Battuta", player)

                    end

                    -- VALIANCE.
                    if bp.core.get('valiance') and bp.core.ready("Valiance", {535,537}) and not bp.queue.search({"Valiance","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Valiance", player)

                    end

                    -- VALLATION.
                    if bp.core.get('vallation') and bp.core.ready("Vallation", {531,537}) and not bp.queue.search({"Vallation","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Vallation", player)

                    end

                    -- LIEMENT.
                    if bp.core.get('liement') and bp.core.ready("Liement", {531,535,537}) and not bp.queue.search({"Valiance","Vallation","Liement"}) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Liement", player)

                    end

                    -- PFLUG.
                    if bp.core.get('pflug') and bp.core.ready("Pflug", 535) and bp.__runes.count() == 3 and target then
                        bp.queue.add("Pflug", player)

                    end

                    -- EMBOLDEN.
                    if bp.core.get('embolden') and bp.core.get('embolden').enabled and bp.core.ready("Embolden", 534) and target then
                        local spell = bp.__res.get(bp.core.get('embolden').name)

                        if spell and bp.core.ready(spell.en, spell.status) and bp.actions.canCast() then
                            bp.queue.add("Embolden", player)
                            bp.queue.add(spell, player)

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.core.ready("Crusade", 289) and target then
                        bp.queue.add("Crusade", player)

                    end

                    -- TEMPER.
                    if bp.core.get('temper') and bp.core.ready("Temper", 432) and target then
                        bp.queue.add("Temper", player)
                    
                    -- PHALANX.
                    elseif bp.core.get('phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", player)
                        
                    -- REFRESH.
                    elseif bp.core.get('refresh') and bp.core.ready("Refresh", {43,187,188}) then
                        bp.queue.add("Refresh", player)

                    -- REGEN.
                    elseif bp.core.get('regen') and not bp.__buffs.active(42) then

                        if bp.__player.mlvl() >= 99 and bp.core.ready("Regen IV") then
                            bp.queue.add("Regen IV", player)

                        elseif bp.__player.mlvl() >= 70 and bp.__player.mlvl() < 99 and bp.core.ready("Regen III") then
                            bp.queue.add("Regen III", player)

                        elseif bp.__player.mlvl() >= 48 and bp.__player.mlvl() < 70 and bp.core.ready("Regen II") then
                            bp.queue.add("Regen II", player)

                        elseif bp.__player.mlvl() < 48 and bp.core.ready("Regen") then
                            bp.queue.add("Regen", player)

                        end

                    -- SPIKES.
                    elseif bp.core.get('spikes') and bp.core.get('spikes').enabled and not bp.__buffs.hasSpikes() then
                        local spikes = bp.__res.get(bp.core.get('spikes').name)

                        if spikes and bp.core.ready(spikes.en) then
                            bp.queue.add(spikes.en, player)
                            
                        end
                        
                    -- BLINK.
                    elseif bp.core.get('blink') and bp.core.ready("Blink", 36) and not bp.__buffs.hasShadows() then
                        bp.queue.add("Blink", player)

                    -- AQUAVEIL.
                    elseif bp.core.get('aquaveil') and bp.core.ready("Aquaveil", 39) then
                        bp.queue.add("Aquaveil", player)

                    -- STONESKIN.
                    elseif bp.core.get('stoneskin') and bp.core.ready("Stoneskin", 37) then
                        bp.queue.add("Stoneskin", player)
                        
                    end

                end

            end

        end

        return self

    end

    function self:debuff()
        return self

    end

    function self:enmity()
        local timer = bp.core.timer('enmity')

        if bp.core.get('hate') and bp.core.get('hate').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.core.get('flash') and bp.core.ready("Flash") then
                        bp.queue.add("Flash", target)
                        timer:update()

                    -- FOIL.
                    elseif bp.core.get('foil') and bp.core.ready("Foil") then
                        bp.queue.add("Foil", target)
                        timer:update()

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.core.get('flash') and bp.core.ready("Flash") then
                        bp.queue.add("Flash", target)
                        timer:update()

                    -- FOIL.
                    elseif bp.core.get('foil') and bp.core.ready("Foil") then
                        bp.queue.add("Foil", target)
                        timer:update()

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('nuke-mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.ready(spell) then
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load