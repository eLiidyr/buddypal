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

            if bp.core.get('mighty-strikes') and bp.core.ready("Mighty Strikes", 44) then
                bp.queue.add("Mighty Strikes", player)

            end
            
            if bp.core.get('brazen-rush') and bp.core.ready("Brazen Rush", 490) then
                bp.queue.add("Brazen Rush", player)

            end

        end

        return self

    end

    function self:abilities()

        -- TOMAHAWK.
        if bp.core.get('job-abilities') and bp.actions.canAct() and bp.core.get('tomahawk') and bp.core.ready("Tomahawk") and bp.__inventory.canEquip("Throwing Tomahawk") and bp.targets.get('player') then
            bp.queue.add("Tomahawk", bp.targets.get('player'))
        
        end
        
        return self

    end

    function self:buff()

        if bp.core.get('buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- WARRIOR'S CHARGE.
                    if bp.core.get('warriors-charge') and bp.core.ready("Warrior's Charge", 340) and bp.__player.tp() >= bp.core.get('melee-weaponskill').tp then
                        bp.queue.add("Warrior's Charge", player)

                    end

                    -- BERSERK.
                    if bp.core.get('berserk') and not bp.core.get('tank-mode') and bp.core.ready("Berserk", 56) then
                        bp.queue.add("Berserk", player)

                        if bp.__buffs.active(57) then
                            bp.__buffs.cancel(57)

                        end

                    -- DEFENDER.
                    elseif bp.core.get('defender') and bp.core.get('tank-mode') and bp.core.ready("Defender", 57) then
                        bp.queue.add("Defender", player)

                        if bp.__buffs.active(56) then
                            bp.__buffs.cancel(56)

                        end

                    -- AGGRESSOR.
                    elseif bp.core.get('aggressor') and bp.core.ready("Aggressor", 58) then
                        bp.queue.add("Aggressor", player)

                    -- WARCRY.
                    elseif bp.core.get('warcry') and bp.core.ready("Warcry", {68,460}) then
                        bp.queue.add("Warcry", player)

                    -- RETALIATION.
                    elseif bp.core.get('retaliation') and bp.core.ready("Retaliation", 405) then
                        bp.queue.add("Retaliation", player)

                    -- RESTRAINT.
                    elseif bp.core.get('restraint') and bp.core.ready("Restraint", 435) then
                        bp.queue.add("Restraint", player)

                    -- BLOOD RAGE.
                    elseif bp.core.get('blood-rage') and bp.core.ready("Blood Rage", {68,460}) then
                        bp.queue.add("Blood Rage", player)

                    end

                end

            elseif player and player.status == 0 then
                

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

                -- PROVOKE.
                if bp.core.get('provoke') and bp.core.ready("Provoke") then
                    bp.queue.add("Provoke", target)
                    timer:update()

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- PROVOKE.
                if bp.core.get('provoke') and bp.core.ready("Provoke") then
                    bp.queue.add("Provoke", target)
                    timer:update()

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