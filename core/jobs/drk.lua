local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local target = bp.targets.getCombatTarget()
        local player = bp.__player.get()

        if player and bp.combat.get('auto_one_hours') and bp.combat.get('auto_job_abilities') and bp.actions.canAct() and player.status == 1 then
            local target = bp.__target.get('t') or nil

            if target and bp.abilities.get('auto_blood_weapon') and bp.core.ready("Blood Weapon", 51) then
                bp.queue.add("Blood Weapon", player)

            end
            
            if target and bp.abilities.get('auto_soul_enslavement') and bp.core.ready("Soul Enslavement", 497) then
                bp.queue.add("Soul Enslavement", player)

            end

        end

        if player and target then

            -- DRAINS.
            if bp.combat.get('auto_drain') then
                local drain = bp.combat.get('auto_drain')
                local vitals = bp.__player.vitals()
                
                if drain.enabled and vitals.hpp < drain.hpp and target then

                    for spell in T{"Drain III","Drain II","Drain"}:it() do

                        if bp.core.ready(spell) then
                            bp.queue.add(spell, target)

                        end

                    end

                end

            end

            -- ASPIRS.
            if bp.combat.get('auto_aspir') then
                local aspir = bp.combat.get('auto_aspir')
                local vitals = bp.__player.vitals()
                
                if aspir.enabled and vitals.mpp < aspir.mpp and target then

                    for spell in T{"Aspir III","Aspir II","Aspir"}:it() do

                        if bp.core.ready(spell) then
                            bp.queue.add(spell, target)

                        end

                    end

                end

            end

        end

        return self

    end

    function self:abilities()

        if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local target = bp.targets.getCombatTarget()
            local player = bp.__player.get()

            -- WEAPON BASH.
            if player and target and bp.abilities.get('auto_weapon_bash') and bp.core.ready("Weapon Bash") then
                bp.queue.add("Weapon Bash", target)

            end

        end

        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.combat.get('auto_job_abilities') and bp.actions.canAct() and target then

                    -- CONSUME MANA.
                    if bp.abilities.get('auto_consume_mana') and bp.core.ready("Consume Mana", 599) then
                        local vitals = bp.__player.vitals()
                        local mws = bp.combat.get('auto_melee_weaponskill')

                        if vitals and mws and vitals.tp() >= mws.tp then
                            bp.queue.add("Consume Mana", player)

                        end

                    end

                    -- LAST RESORT.
                    if not bp.combat.get('auto_tank_mode') and bp.abilities.get('auto_last_resort') and bp.core.ready("Last Resort", 63) then
                        bp.queue.add("Last Resort", player)

                    -- SOULEATER.
                    elseif not bp.combat.get('auto_tank_mode') and bp.abilities.get('souleater') and bp.core.ready("Souleater", 64) then
                        bp.queue.add("Souleater", player)

                    -- DIABOLIC EYE.
                    elseif bp.abilities.get('auto_diabolic_eye') and bp.core.ready("Diabolic Eye", 349) then
                        bp.queue.add("Diabolic Eye", player)

                    -- SCARLET DELIRIUM.
                    elseif bp.abilities.get('auto_scarlet_delirium') and bp.core.ready("Scarlet Delirium", {479,480}) then
                        bp.queue.add("Scarlet Delirium", player)

                    end

                end

                if bp.actions.canCast() then

                    -- ENDARK.
                    if bp.buffs.get('auto_endark') and not bp.queue.search({"Endark","Endark II"}) and target then
                        local jpoints = bp.__player.jp()

                        if jpoints.jp_spent >= 100 and bp.core.ready("Endark II", 288) then
                            bp.queue.add("Endark II", player)

                        elseif jpoints.jp_spent < 100 and bp.core.ready("Endark", 288) then
                            bp.queue.add("Endark", player)

                        end

                    end

                    -- ABSORBS.
                    if bp.buffs.get('auto_absorb') then
                        local absorb = bp.buffs.get('auto_absorb')

                        if absorb.enabled and target and bp.core.ready(absorb.name) and (not bp.__buffs.hasAbsorb() or S{"Absorb-Attri","Absorb-TP"}:contains(absorb.name)) then

                            -- DARK SEAL.
                            if bp.abilities.get('auto_dark_seal') and bp.core.ready("Dark Seal", 345) and bp.actions.canAct() then
                                bp.queue.add("Dark Seal", player)
                            
                            end

                            -- NETHER VOID.
                            if bp.abilities.get('auto_nether_void') and bp.core.ready("Nether Void", 439) and bp.actions.canAct() then
                                bp.queue.add("Nether Void", player)
                            
                            end
                            bp.queue.add(absorb, target)

                        end

                    end

                    -- DREAD SPIKES.
                    if bp.buffs.get('auto_dread_spikes') and not bp.__buffs.hasSpikes() then
                        bp.queue.add("Dread Spikes", player)

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
            local target = bp.targets.getCombatTarget()
            local player = bp.__player.get()

            if player and target then
                
                -- STUN.
                if bp.core.ready("Stun") and bp.actions.canCast() then
                    bp.queue.add("Stun", target)
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