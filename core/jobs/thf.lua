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

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if target then

                    -- BULLY.
                    if bp.core.get('bully') and bp.core.ready("Bully") then
                        bp.queue.add("Bully", target)
                    end

                    -- STEAL.
                    if bp.core.get('steal') and bp.core.ready("Steal") then
                        bp.queue.add("Steal", target)

                    -- MUG.
                    elseif bp.core.get('mug') and bp.core.ready("Mug") then
                        bp.queue.add("Mug", target)

                    -- DESPOIL.
                    elseif bp.core.get('despoil') and bp.core.ready("Despoil") then
                        bp.queue.add("Despoil", target)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if target then

                    -- BULLY.
                    if bp.core.get('bully') and bp.core.ready("Bully") then
                        bp.queue.add("Bully", target)
                    end

                    -- STEAL.
                    if bp.core.get('steal') and bp.core.ready("Steal") then
                        bp.queue.add("Steal", target)

                    -- MUG.
                    elseif bp.core.get('mug') and bp.core.ready("Mug") then
                        bp.queue.add("Mug", target)

                    -- DESPOIL.
                    elseif bp.core.get('despoil') and bp.core.ready("Despoil") then
                        bp.queue.add("Despoil", target)

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

                if bp.actions.canAct() and target then

                    -- CONSPIRATOR.
                    if bp.core.get('feint') and bp.core.ready("Conspirator", 462) then
                        bp.queue.add("Conspirator", player)

                    end

                    -- FEINT.
                    if bp.core.get('feint') and bp.core.ready("Feint", 343) then
                        bp.queue.add("Feint", player)

                    end

                    -- ASSASINS CHARGE.
                    if bp.core.get('assassins-charge') and bp.core.ready("Assassin's Charge", 342) then
                        bp.queue.add("Assassin's Charge", player)

                    end

                    -- SNEAK ATTACK.
                    if bp.core.get('sneak-attack') and bp.core.ready("Sneak Attack", 65) and bp.actions.isBehind(target) then

                        if bp.core.get('saws') and bp.core.vitals.tp >= bp.core.get('melee-weaponskill').tp then
                            bp.queue.add("Sneak Attack", player)
                            
                        elseif not bp.core.get('saws') then
                            bp.queue.add("Sneak Attack", player)

                        end

                    end

                    -- TRICK ATTACK.
                    if bp.core.get('trick-attack') and bp.core.ready("Trick Attack", 87) and bp.actions.isFacing(target) then
                        bp.queue.add("Trick Attack", player)

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