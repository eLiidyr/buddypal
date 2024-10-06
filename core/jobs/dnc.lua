local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.combat.get('auto_one_hours') and bp.combat.get('auto_job_abilities') and bp.actions.canAct() then

            -- TRANCE.
            if bp.abilities.get('auto_trance') and bp.core.ready("Trance", 376) then
                bp.queue.add("Trance", player)

            end
            
            -- GRAND PAS.
            if bp.abilities.get('auto_grand_pas') and bp.core.ready("Grand Pas", 507) then
                bp.queue.add("Grand Pas", player)

            end

        end

        return self

    end

    function self:abilities()

        if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- NO FOOT RISE.
                if bp.abilities.get('auto_no_foot_rise') and bp.core.ready("No Foot Rise") then
                    local merits = bp.__player.merits()

                    if merits and (6 - bp.__buffs.getFinishingMoves()) <= merits.no_foot_rise then
                        bp.queue.add("No Foot Rise", player)

                    end

                end

                -- STEPS.
                if bp.abilities.get('auto_steps') then
                    local steps = bp.abilities.get('auto_steps')
                    
                    if steps.enabled and bp.core.ready(steps.name) then

                        -- PRESTO.
                        if bp.abilities.get('auto_presto') and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                            bp.queue.add("Presto", player)

                        end
                        bp.queue.add(steps.name, target)

                    end

                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- VIOLENT FLOURISH.
                    if bp.abilities.get('auto_violent_flourish') and bp.core.ready("Violent Flourish") then
                        bp.queue.add("Violent Flourish", target)

                    end

                    -- REVERSE FLOURISH.
                    if bp.abilities.get('auto_reverse_flourish') and bp.core.ready("Reverse Flourish") then
                        bp.queue.add("Reverse Flourish", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- NO FOOT RISE.
                if bp.abilities.get('auto_no_foot_rise') and bp.core.ready("No Foot Rise") then
                    local merits = bp.__player.merits()

                    if merits and (6 - bp.__buffs.getFinishingMoves()) <= merits.no_foot_rise then
                        bp.queue.add("No Foot Rise", player)

                    end

                end

                -- STEPS.
                if bp.abilities.get('auto_steps') then
                    local steps = bp.abilities.get('auto_steps')
                    
                    if steps.enabled and bp.core.ready(steps.name) then

                        -- PRESTO.
                        if bp.abilities.get('auto_presto') and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                            bp.queue.add("Presto", player)

                        end
                        bp.queue.add(steps.name, target)

                    end

                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- VIOLENT FLOURISH.
                    if bp.abilities.get('auto_violent_flourish') and bp.core.ready("Violent Flourish") then
                        bp.queue.add("Violent Flourish", target)

                    end

                    -- REVERSE FLOURISH.
                    if bp.abilities.get('auto_reverse_flourish') and bp.core.ready("Reverse Flourish") then
                        bp.queue.add("Reverse Flourish", player)

                    end

                end

            end

        end

        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() and bp.combat.get('auto_job_abilities') then

                    -- SABER DANCE.
                    if bp.abilities.get('auto_saber_dance') and bp.core.ready("Saber Dance", {410,411}) then
                        bp.queue.add("Saber Dance", player)

                    end

                    -- SAMBAS.
                    if bp.abilities.get('autosambas') then
                        local sambas = bp.abilities.get('auto_sambas')
                        
                        if sambas.enabled and target and not bp.__buffs.active(411) then

                            if bp.core.ready(sambas.name, {368,369,370}) then
                                bp.queue.add(sambas.name, player)

                            end

                        end

                    end

                    if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then
                        local aws = bp.combat.get('auto_melee_weaponskill')
                        local vitals = bp.__player.vitals()

                        if aws and vitals and aws.enabled and vitals.tp >= aws.tp then

                            -- CLIMACTIC FLOURISH.
                            if bp.abilities.get('auto_climactic_flourish') and bp.core.ready("Climactic Flourish", 443) then
                                bp.queue.add("Climactic Flourish", player)

                            end

                            -- STRIKING FLOURISH.
                            if bp.abilities.get('auto_striking_flourish') and bp.core.ready("Striking Flourish", 468) and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Striking Flourish", player)

                            end

                            -- TERNARY FLOURISH.
                            if bp.abilities.get('auto_ternary_flourish') and bp.core.ready("Ternary Flourish", 472) and (bp.__buffs.getFinishingMoves() > 2 or bp.__buffs.active(507)) then
                                bp.queue.add("Ternary Flourish", player)

                            end

                        else

                            -- BUILDING FLOURISH.
                            if bp.abilities.get('auto_building_flourish') and bp.core.ready("Building Flourish", 375) then
                                bp.queue.add("Building Flourish", player)

                            end

                            -- WILD FLOURISH.
                            if bp.abilities.get('auto_wild_flourish') and bp.core.ready("Wild Flourish") and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Wild Flourish", target)

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() and bp.combat.get('auto_job_abilities') then

                    -- SABER DANCE.
                    if bp.abilities.get('auto_saber_dance') and bp.core.ready("Saber Dance", {410,411}) then
                        bp.queue.add("Saber Dance", player)

                    end

                    -- SAMBAS.
                    if bp.abilities.get('autosambas') then
                        local sambas = bp.abilities.get('auto_sambas')
                        
                        if sambas.enabled and target and not bp.__buffs.active(411) then

                            if bp.core.ready(sambas.name, {368,369,370}) then
                                bp.queue.add(sambas.name, player)

                            end

                        end

                    end

                    if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then
                        local aws = bp.combat.get('auto_melee_weaponskill')
                        local vitals = bp.__player.vitals()

                        if aws and vitals and aws.enabled and vitals.tp >= aws.tp then

                            -- CLIMACTIC FLOURISH.
                            if bp.abilities.get('auto_climactic_flourish') and bp.core.ready("Climactic Flourish", 443) then
                                bp.queue.add("Climactic Flourish", player)

                            end

                            -- STRIKING FLOURISH.
                            if bp.abilities.get('auto_striking_flourish') and bp.core.ready("Striking Flourish", 468) and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Striking Flourish", player)

                            end

                            -- TERNARY FLOURISH.
                            if bp.abilities.get('auto_ternary_flourish') and bp.core.ready("Ternary Flourish", 472) and (bp.__buffs.getFinishingMoves() > 2 or bp.__buffs.active(507)) then
                                bp.queue.add("Ternary Flourish", player)

                            end

                        else

                            -- BUILDING FLOURISH.
                            if bp.abilities.get('auto_building_flourish') and bp.core.ready("Building Flourish", 375) then
                                bp.queue.add("Building Flourish", player)

                            end

                            -- WILD FLOURISH.
                            if bp.abilities.get('auto_wild_flourish') and bp.core.ready("Wild Flourish") and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Wild Flourish", target)

                            end

                        end

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
        local enmity = bp.combat.get('auto_enmity_generation')

        if enmity and enmity.enabled and bp.core.timer('enmity'):ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = (player.status == 1) and bp.__target.get('t') or bp.targets.get('player')

                -- FAN DANCE.
                if bp.abilities.get('auto_fan_dance') and bp.core.ready("Fan Dance", {410,411}) then
                    bp.queue.add("Fan Dance", player)
                
                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- ANIMATED FLOURISH.
                    if target and bp.abilities.get('auto_animated_flourish') and bp.core.ready("Animated Flourish") then
                        bp.queue.add("Animated Flourish", target)
                        bp.core.timer('enmity'):update()

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        return self

    end
    
    return self

end
return load