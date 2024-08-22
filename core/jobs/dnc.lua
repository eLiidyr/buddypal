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

            -- TRANCE.
            if bp.core.get('trance') and bp.core.ready("Trance", 376) then
                bp.queue.add("Trance", player)

            end
            
            -- GRAND PAS.
            if bp.core.get('grand-pas') and bp.core.ready("Grand Pas", 507) then
                bp.queue.add("Grand Pas", player)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- NO FOOT RISE.
                if bp.core.get('no foot rise') and bp.core.ready("No Foot Rise") then
                    local merits = bp.__player.merits()

                    if merits and (6 - bp.__buffs.getFinishingMoves()) <= merits.no_foot_rise then
                        bp.queue.add("No Foot Rise", player)

                    end

                end

                -- STEPS.
                if bp.core.get('steps') then
                    local steps = bp.core.get('steps')
                    
                    if steps.enabled and bp.core.ready(steps.name) then

                        -- PRESTO.
                        if bp.core.get('presto') and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                            bp.queue.add("Presto", player)

                        end
                        bp.queue.add(steps.name, target)

                    end

                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- VIOLENT FLOURISH.
                    if bp.core.get('violent-flourish') and bp.core.ready("Violent Flourish") then
                        bp.queue.add("Violent Flourish", target)

                    end

                    -- REVERSE FLOURISH.
                    if bp.core.get('reverse-flourish') and bp.core.ready("Reverse Flourish") then
                        bp.queue.add("Reverse Flourish", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- NO FOOT RISE.
                if bp.core.get('no foot rise') and bp.core.ready("No Foot Rise") then
                    local merits = bp.__player.merits()

                    if merits and (6 - bp.__buffs.getFinishingMoves()) <= merits.no_foot_rise then
                        bp.queue.add("No Foot Rise", player)

                    end

                end

                -- STEPS.
                if bp.core.get('steps') then
                    local steps = bp.core.get('steps')
                    
                    if steps.enabled and bp.core.ready(steps.name) then

                        -- PRESTO.
                        if bp.core.get('presto') and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                            bp.queue.add("Presto", player)

                        end
                        bp.queue.add(steps.name, target)

                    end

                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- VIOLENT FLOURISH.
                    if bp.core.get('violent-flourish') and bp.core.ready("Violent Flourish") then
                        bp.queue.add("Violent Flourish", target)

                    end

                    -- REVERSE FLOURISH.
                    if bp.core.get('reverse-flourish') and bp.core.ready("Reverse Flourish") then
                        bp.queue.add("Reverse Flourish", player)

                    end

                end

            end

        end

        return self

    end

    function self:buff()

        if bp.core.get('buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- SABER DANCE.
                    if bp.core.get('saber-dance') and bp.core.ready("Saber Dance", {410,411}) then
                        bp.queue.add("Saber Dance", player)

                    end

                    -- SAMBAS.
                    if bp.core.get('sambas') then
                        local sambas = bp.core.get('sambas')
                        
                        if sambas.enabled and target and not bp.__buffs.active(411) then

                            if bp.core.ready(sambas.name, {368,369,370}) then
                                bp.queue.add(sambas.name, player)

                            end

                        end

                    end

                    if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                        if bp.core.get('melee-weaponskill') and bp.core.get('melee-weaponskill').enabled and bp.core.vitals.tp >= bp.core.get('melee-weaponskill').tp then

                            -- CLIMACTIC FLOURISH.
                            if bp.core.get('climactic-flourish') and bp.core.ready("Climactic Flourish", 443) then
                                bp.queue.add("Climactic Flourish", player)

                            end

                            -- STRIKING FLOURISH.
                            if bp.core.get('striking-flourish') and bp.core.ready("Striking Flourish", 468) and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Striking Flourish", player)

                            end

                            -- TERNARY FLOURISH.
                            if bp.core.get('ternary-flourish') and bp.core.ready("Ternary Flourish", 472) and (bp.__buffs.getFinishingMoves() > 2 or bp.__buffs.active(507)) then
                                bp.queue.add("Ternary Flourish", player)

                            end

                        else

                            -- BUILDING FLOURISH.
                            if bp.core.get('building-flourish') and bp.core.ready("Building Flourish", 375) then
                                bp.queue.add("Building Flourish", player)

                            end

                            -- WILD FLOURISH.
                            if bp.core.get('wild-flourish') and bp.core.ready("Wild Flourish") and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Wild Flourish", target)

                            end

                        end

                    end
                    

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- SABER DANCE.
                    if bp.core.get('saber-dance') and bp.core.ready("Saber Dance", {410,411}) then
                        bp.queue.add("Saber Dance", player)

                    end

                    -- SAMBAS.
                    if bp.core.get('sambas') then
                        local sambas = bp.core.get('sambas')
                        
                        if sambas.enabled and target and not bp.__buffs.active(411) then

                            if bp.core.ready(sambas.name, {368,369,370}) then
                                bp.queue.add(sambas.name, player)

                            end

                        end

                    end

                    if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                        if bp.core.get('melee-weaponskill') and bp.core.get('melee-weaponskill').enabled and bp.core.vitals.tp >= bp.core.get('melee-weaponskill').tp then

                            -- CLIMACTIC FLOURISH.
                            if bp.core.get('climactic-flourish') and bp.core.ready("Climactic Flourish", 443) then
                                bp.queue.add("Climactic Flourish", player)

                            end

                            -- STRIKING FLOURISH.
                            if bp.core.get('striking-flourish') and bp.core.ready("Striking Flourish", 468) and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
                                bp.queue.add("Striking Flourish", player)

                            end

                            -- TERNARY FLOURISH.
                            if bp.core.get('ternary-flourish') and bp.core.ready("Ternary Flourish", 472) and (bp.__buffs.getFinishingMoves() > 2 or bp.__buffs.active(507)) then
                                bp.queue.add("Ternary Flourish", player)

                            end

                        else

                            -- BUILDING FLOURISH.
                            if bp.core.get('building-flourish') and bp.core.ready("Building Flourish", 375) then
                                bp.queue.add("Building Flourish", player)

                            end

                            -- WILD FLOURISH.
                            if bp.core.get('wild-flourish') and bp.core.ready("Wild Flourish") and (bp.__buffs.getFinishingMoves() > 1 or bp.__buffs.active(507)) then
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
        local timer = bp.core.timer('enmity')

        if bp.core.get('hate') and bp.core.get('hate').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- FAN DANCE.
                if bp.core.get('fan-dance') and bp.core.ready("Fan Dance", {410,411}) then
                    bp.queue.add("Fan Dance", player)
                
                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- ANIMATED FLOURISH.
                    if bp.core.get('animated-flourish') and bp.core.ready("Animated Flourish") then
                        bp.queue.add("Animated Flourish", target)
                        timer:update()

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- FAN DANCE.
                if bp.core.get('fan-dance') and bp.core.ready("Fan Dance", {410,411}) then
                    bp.queue.add("Fan Dance", player)
                
                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.__buffs.active(507)) then

                    -- ANIMATED FLOURISH.
                    if bp.core.get('animated-flourish') and bp.core.ready("Animated Flourish") then
                        bp.queue.add("Animated Flourish", target)
                        timer:update()

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