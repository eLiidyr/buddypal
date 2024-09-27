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

        if player and target and bp.core.get('auto_auto_one_hours') and bp.actions.canAct() and player.status == 1 then

            if bp.core.get('auto_auto_blood_weapon') and bp.core.ready("Blood Weapon", 51) then
                bp.queue.add("Blood Weapon", player)

            end
            
            if bp.core.get('auto_soul_enslavement') and bp.core.ready("Soul Enslavement", 497) then
                bp.queue.add("Soul Enslavement", player)

            end

        end

        -- DRAINS.
        if player and target and bp.core.get('drain') and bp.core.get('drain').enabled and bp.__player.hpp() < bp.core.get('drain').hpp then

            for drain in T{"Drain III","Drain II","Drain"}:it() do

                if bp.core.ready(drain) then

                    if drain == "Drain III" and bp.core.get('auto_dark_seal') and bp.core.ready("Dark Seal", 345) and bp.actions.canAct() then
                        bp.queue.add("Dark Seal", player)

                    end                                
                    bp.queue.add(drain, target)

                end

            end

        end

        -- ASPIRS.
        if player and target and bp.core.get('aspir') and bp.core.get('aspir').enabled and bp.__player.mpp() < bp.core.get('aspir').mpp then

            for aspir in T{"Aspir III","Aspir II","Aspir"}:it() do

                if bp.core.ready(aspir) then
                    bp.queue.add(aspir, target)

                end

            end

        end

        return self

    end

    function self:abilities()

        if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- WEAPON BASH.
                if bp.core.get('auto_weapon_bash') and bp.core.ready("Weapon Bash") and target then
                    bp.queue.add("Weapon Bash", target)

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- WEAPON BASH.
                if bp.core.get('auto_weapon_bash') and bp.core.ready("Weapon Bash") and target then
                    bp.queue.add("Weapon Bash", target)

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

                if bp.actions.canAct() and target then

                    -- CONSUME MANA.
                    if bp.core.get('auto_consume_mana') and bp.core.ready("Consume Mana", 599) and bp.__player.tp() >= bp.core.get('auto_melee_weaponskill').tp then
                        bp.queue.add("Consume Mana", player)

                    end

                    -- LAST RESORT.
                    if not bp.core.get('auto_tank_mode') and bp.core.get('auto_last_resort') and bp.core.ready("Last Resort", 63) then
                        bp.queue.add("Last Resort", player)

                    -- SOULEATER.
                    elseif not bp.core.get('auto_tank_mode') and bp.core.get('souleater') and bp.core.ready("Souleater", 64) then
                        bp.queue.add("Souleater", player)

                    -- DIABOLIC EYE.
                    elseif bp.core.get('auto_diabolic_eye') and bp.core.ready("Diabolic Eye", 349) then
                        bp.queue.add("Diabolic Eye", player)

                    -- SCARLET DELIRIUM.
                    elseif bp.core.get('auto_scarlet_delirium') and bp.core.ready("Scarlet Delirium", {479,480}) then
                        bp.queue.add("Scarlet Delirium", player)

                    end

                end

                if bp.actions.canCast() then

                    -- ENDARK.
                    if bp.core.get('endark') and not bp.queue.search({"Endark","Endark II"}) and target then
                        local spent = bp.__player.jp().jp_spent

                        if spent >= 100 and bp.core.ready("Endark II", 288) then
                            bp.queue.add("Endark II", player)

                        elseif spent < 100 and bp.core.ready("Endark", 288) then
                            bp.queue.add("Endark", player)

                        end

                    end

                    -- ABSORBS.
                    if bp.core.get('absorb') and bp.core.get('absorb').enabled and target then
                        local absorb = bp.core.get('absorb').name

                        if absorb and bp.core.ready(absorb) and (not bp.__buffs.hasAbsorb() or absorb == "Absorb-Attri" or absorb == "Absorb-TP") then

                            -- DARK SEAL.
                            if bp.core.get('auto_dark_seal') and bp.core.ready("Dark Seal", 345) and bp.actions.canAct() then
                                bp.queue.add("Dark Seal", player)
                            
                            end

                            -- NETHER VOID.
                            if bp.core.get('auto_nether_void') and bp.core.ready("Nether Void", 439) and bp.actions.canAct() then
                                bp.queue.add("Nether Void", player)
                            
                            end
                            bp.queue.add(absorb, target)

                        end

                    end

                    -- DREAD SPIKES.
                    if bp.core.get('auto_dread_spikes') and not bp.__buffs.hasSpikes() then
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
        local timer = bp.core.timer('enmity')

        if bp.core.get('auto_enmity_generation') and bp.core.get('auto_enmity_generation').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- STUN.
                if bp.core.ready("Stun") and bp.actions.canCast() then
                    bp.queue.add("Stun", target)
                    timer:update()

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

            end

        end

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