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
            local target = bp.targets.get('player')

            if bp.abilities.get('auto_manafont') and bp.core.ready("Manafont", 47) and target then
                bp.queue.add("Manafont", player)

            end
            
            if bp.abilities.get('auto_subtle_sorcery') and bp.core.ready("Subtle Sorcery", 490) and target then
                bp.queue.add("Subtle Sorcery", player)

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
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- ENMITY DOUSE.
                if bp.core.get('auto_enmity_douse') and bp.core.ready("Enmity Douse") then

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- ENMITY DOUSE.
                if bp.core.get('auto_enmity_douse') and bp.core.ready("Enmity Douse") then -- UPDATE.

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

                if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then

                    -- MANA WALL.
                    if bp.abilities.get('auto_mana_wall') and bp.core.ready("Mana Wall", 437) then

                        if bp.__aggro.hasAggro() then -- UPDATE.
                            bp.queue.add("Mana Wall", player)

                        end

                    end

                    -- MANAWELL.
                    --if bp.core.get('auto_manawell') and (bp.core.get('nuke-mode') or (bp.core.get('mb') and bp.core.get('mb').enabled)) and bp.core.ready("Manawell", 229) then -- UPDATE.
                        --bp.queue.add("Manawell", player)

                    --end

                end

                if bp.actions.canCast() then

                    -- SPIKES.
                    if bp.buffs.get('auto_spikes') then
                        local spikes = bp.buffs.get('auto_spikes')
                        
                        if spikes.enabled and not bp.__buffs.hasSpikes() and bp.core.ready(spikes.name) then
                            bp.queue.add(spikes.name, player)

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- MANA WALL.
                    if bp.abilities.get('auto_mana_wall') and bp.core.ready("Mana Wall", 437) then

                        --if bp.__aggro.hasAggro() then -- UPDATE.
                            --bp.queue.add("Mana Wall", player)

                        --end

                    end

                    -- MANAWELL.
                    --if bp.core.get('auto_manawell') and (bp.core.get('nuke-mode') or (bp.core.get('mb') and bp.core.get('mb').enabled)) and bp.core.ready("Manawell", 229) then -- UPDATE.
                        --bp.queue.add("Manawell", player)

                    --end

                end

                if bp.actions.canCast() then

                    -- SPIKES.
                    if bp.buffs.get('auto_spikes') then
                        local spikes = bp.buffs.get('auto_spikes')
                        
                        if spikes.enabled and not bp.__buffs.hasSpikes() and bp.core.ready(spikes.name) then
                            bp.queue.add(spikes.name, player)

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