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

            if bp.abilities.get('auto_mighty_strikes') and bp.core.ready("Mighty Strikes", 44) then
                bp.queue.add("Mighty Strikes", player)

            end
            
            if bp.abilities.get('auto_brazen_rush') and bp.core.ready("Brazen Rush", 490) then
                bp.queue.add("Brazen Rush", player)

            end

        end

        return self

    end

    function self:abilities()
        local target = bp.targets.get('player')

        -- TOMAHAWK.
        if target and bp.combat.get('auto_job_abilities') and bp.actions.canAct() and bp.abilities.get('auto_tomahawk') and bp.core.ready("Tomahawk") and bp.__inventory.canEquip("Throwing Tomahawk") then
            bp.queue.add("Tomahawk", target)
        
        end
        
        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- WARRIOR'S CHARGE.
                    if bp.abilities.get('auto_warriors_charge') and bp.core.ready("Warrior's Charge", 340) and bp.__player.tp() >= bp.core.get('auto_melee_weaponskill').tp then
                        bp.queue.add("Warrior's Charge", player)

                    end

                    -- BERSERK.
                    if bp.abilities.get('auto_berserk') and not bp.combat.get('auto_tank_mode') and bp.core.ready("Berserk", 56) then
                        bp.queue.add("Berserk", player)

                        if bp.__buffs.active(57) then
                            bp.__buffs.cancel(57)

                        end

                    -- DEFENDER.
                    elseif bp.abilities.get('auto_defender') and bp.combat.get('auto_tank_mode') and bp.core.ready("Defender", 57) then
                        bp.queue.add("Defender", player)

                        if bp.__buffs.active(56) then
                            bp.__buffs.cancel(56)

                        end

                    -- AGGRESSOR.
                    elseif bp.abilities.get('auto_aggressor') and bp.core.ready("Aggressor", 58) then
                        bp.queue.add("Aggressor", player)

                    -- WARCRY.
                    elseif bp.abilities.get('auto_warcry') and bp.core.ready("Warcry", {68,460}) then
                        bp.queue.add("Warcry", player)

                    -- RETALIATION.
                    elseif bp.abilities.get('auto_retaliation') and bp.core.ready("Retaliation", 405) then
                        bp.queue.add("Retaliation", player)

                    -- RESTRAINT.
                    elseif bp.abilities.get('auto_restraint') and bp.core.ready("Restraint", 435) then
                        bp.queue.add("Restraint", player)

                    -- BLOOD RAGE.
                    elseif bp.abilities.get('auto_blood_rage') and bp.core.ready("Blood Rage", {68,460}) then
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
        local enmity = bp.combat.get('auto_enmity_generation')

        if enmity and enmity.enabled and bp.core.timer('enmity'):ready() then
            local target = bp.targets.getCombatTarget()
            local player = bp.__player.get()

            if player and target then

                -- PROVOKE.
                if bp.abilities.get('auto_provoke') and bp.core.ready("Provoke") then
                    bp.queue.add("Provoke", target)
                    bp.core.timer('enmity'):update()

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