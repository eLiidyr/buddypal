local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        return self

    end

    function self:abilities()

        if bp.core.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- QUICK DRAW.
                if bp.core.get('auto_quick_draw') and target then
                    local qd = bp.core.get('auto_quick_draw')
                    
                    if qd.enabled and bp.core.ready("Quick Draw") and bp.__inventory.getCount("Trump Card") > 0 then
                        bp.queue.add(qd.name, target)

                    end

                end

                -- RANDOM DEAL.
                if bp.core.get('auto_random_deal') and bp.core.ready("Random Deal") and target then
                    bp.queue.add("Random Deal", bp.__player.get())

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- QUICK DRAW.
                if bp.core.get('auto_quick_draw') and target then
                    local qd = bp.core.get('auto_quick_draw')
                    
                    if qd.enabled and bp.core.ready("Quick Draw") and bp.__inventory.getCount("Trump Card") > 0 then
                        bp.queue.add(qd.name, target)

                    end

                end

                -- RANDOM DEAL.
                if bp.core.get('auto_random_deal') and bp.core.ready("Random Deal") and target then
                    bp.queue.add("Random Deal", bp.__player.get())

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

                    -- TRIPLE SHOT
                    if bp.core.get('auto_triple_shot') and bp.core.ready("Triple Shot", 467) and target then
                        bp.queue.add("Triple Shot", player)

                    end

                    -- ROLLS.
                    if bp.core.get('rolls') and bp.core.get('rolls').enabled then

                        if bp.__buffs.active(309) and bp.core.ready("Fold") then
                            bp.queue.add("Fold", player)

                        else
                            
                            if bp.core.ready("Double-Up") and bp.__rolls.getMidroll() then
                                local rolling = bp.__rolls.getRolling()
                                local max = bp.core.get('auto_double_up') and bp.core.get('auto_double_up').max or 7

                                if rolling then

                                    if rolling.number < max then
                                        bp.queue.add("Double-Up", player)

                                    elseif bp.core.ready("Snake Eye", 357) and rolling.number >= 7 and rolling.number < 11 then
                                        bp.queue.add("Snake Eye", player)

                                    elseif bp.__buffs.active(357) then
                                        bp.queue.add("Double-Up", player)

                                    end

                                end

                            elseif bp.core.ready("Phantom Roll") and bp.__rolls.active():length() < bp.core.get('rolls').max then
                                local roll = bp.__rolls.getMissing()[1]

                                if roll and bp.core.ready(roll) then

                                    -- CROOKED CARDS.
                                    if bp.__rolls.active():length() == 0 and bp.core.get('auto_crooked_cards') and bp.core.ready("Crooked Cards", 601) then
                                        bp.queue.add("Crooked Cards", player)

                                    end
                                    bp.queue.add(roll, player)

                                end

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- TRIPLE SHOT
                    if bp.core.get('auto_triple_shot') and bp.core.ready("Triple Shot", 467) and target then
                        bp.queue.add("Triple Shot", player)

                    end

                    -- ROLLS.
                    if bp.core.get('rolls') and bp.core.get('rolls').enabled then

                        if bp.__buffs.active(309) and bp.core.ready("Fold") then
                            bp.queue.add("Fold", player)

                        else
                            
                            if bp.core.ready("Double-Up") and bp.__rolls.getMidroll() then
                                local rolling = bp.__rolls.getRolling()
                                local max = bp.core.get('auto_double_up') and bp.core.get('auto_double_up').max or 7

                                if rolling then

                                    if rolling.number < max then
                                        bp.queue.add("Double-Up", player)

                                    elseif bp.core.ready("Snake Eye", 357) and rolling.number >= 7 and rolling.number < 11 then
                                        bp.queue.add("Snake Eye", player)

                                    elseif bp.__buffs.active(357) then
                                        bp.queue.add("Double-Up", player)

                                    end

                                end

                            elseif bp.core.ready("Phantom Roll") and bp.__rolls.active():length() < 2 then
                                local roll = bp.__rolls.getMissing()[1]

                                if roll and bp.core.ready(roll) then

                                    -- CROOKED CARDS.
                                    if bp.__rolls.active():length() == 0 and bp.core.get('auto_crooked_cards') and bp.core.ready("Crooked Cards", 601) then
                                        bp.queue.add("Crooked Cards", player)

                                    end
                                    bp.queue.add(roll, player)

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
        return self

    end

    function self:enmity()
        return self

    end

    function self:nuke()
        return self

    end
    
    return self

end
return load