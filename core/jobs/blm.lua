local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        -- ONE-HOURS.
        if bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then
            local target = bp.targets.get('player')

            if bp.core.get('manafont') and bp.core.ready("Manafont", 47) and target then
                bp.queue.add("Manafont", bp.__player.get())

            end
            
            if bp.core.get('subtle-sorcery') and bp.core.ready("Subtle Sorcery", 490) and target then
                bp.queue.add("Subtle Sorcery", bp.__player.get())

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

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

                    -- MANA WALL.
                    if bp.core.get('mana-wall') and bp.core.ready("Mana Wall", 437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.__player.id() then
                            bp.queue.add("Mana Wall", bp.__player.get())

                        end

                    end

                    -- ENMITY DOUSE.
                    if bp.core.get('enmity-douse') and bp.core.ready("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.__player.id() then
                            bp.queue.add("Enmity Douse", bp.__player.get())

                        end

                    end

                    -- MANAWELL. NEEDS UPDATE!!
                    if bp.core.get('manawell') and (bp.core.get('nuke-mode') or (bp.core.get('mb') and bp.core.get('mb').enabled)) and bp.core.ready("Manawell", 229) then
                        bp.queue.add("Manawell", bp.__player.get())

                    end

                end

                if bp.actions.canCast() then

                    -- SPIKES.
                    if bp.core.get('spikes') and bp.core.get('spikes').enabled and not bp.__buffs.hasSpikes() then
                        local spikes = bp.core.get('spikes').name

                        if spikes and bp.core.ready(spikes) then
                            bp.queue.add(spikes, bp.__player.get())

                        end

                    end

                    -- DRAINS.
                    if bp.core.get('drain') and bp.core.get('drain').enabled and bp.core.vitals.hpp < bp.core.get('drain').hpp and target then

                        for drain in T{"Drain III","Drain II","Drain"}:it() do

                            if cp.core.ready(drain) then
                                bp.queue.add(drain, target)

                            end

                        end

                    end

                    -- ASPIRS.
                    if bp.core.get('aspir') and bp.core.get('aspir').enabled and bp.core.vitals.mpp < bp.core.get('aspir').mpp and target then

                        for aspir in T{"Aspir III","Aspir II","Aspir"}:it() do

                            if cp.core.ready(aspir) then
                                bp.queue.add(aspir, target)

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- MANA WALL.
                    if bp.core.get('mana-wall') and bp.core.ready("Mana Wall", 437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.__player.id() then
                            bp.queue.add("Mana Wall", bp.__player.get())

                        end

                    end

                    -- ENMITY DOUSE.
                    if bp.core.get('enmity-douse') and bp.core.ready("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.__player.id() then
                            bp.queue.add("Enmity Douse", bp.__player.get())

                        end

                    end

                    -- MANAWELL. NEEDS UPDATE!!
                    if bp.core.get('manawell') and (bp.core.get('nuke-mode') or (bp.core.get('mb') and bp.core.get('mb').enabled)) and bp.core.ready("Manawell", 229) then
                        bp.queue.add("Manawell", bp.__player.get())

                    end

                end

                if bp.actions.canCast() then

                    -- SPIKES.
                    if bp.core.get('spikes') and bp.core.get('spikes').enabled and not bp.__buffs.hasSpikes() then
                        local spikes = bp.core.get('spikes').name

                        if spikes and bp.core.ready(spikes) then
                            bp.queue.add(spikes, bp.__player.get())

                        end

                    end

                    -- DRAINS.
                    if bp.core.get('drain') and bp.core.get('drain').enabled and bp.core.vitals.hpp < bp.core.get('drain').hpp and target then

                        for drain in T{"Drain III","Drain II","Drain"}:it() do

                            if cp.core.ready(drain) then
                                bp.queue.add(drain, target)

                            end

                        end

                    end

                    -- ASPIRS.
                    if bp.core.get('aspir') and bp.core.get('aspir').enabled and bp.core.vitals.mpp < bp.core.get('aspir').mpp and target then

                        for aspir in T{"Aspir III","Aspir II","Aspir"}:it() do

                            if cp.core.ready(aspir) then
                                bp.queue.add(aspir, target)

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()

        if bp.debuffs.enabled() and bp.actions.canCast() then
            bp.debuffs.cast()

        end

        return self

    end

    function self:enmity()
        local timer = bp.core.timer('enmity')

        if bp.core.get('auto_enmity_generation') and bp.core.get('auto_enmity_generation').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- STUN.
                if bp.core.ready("Stun") then
                    bp.queue.add("Stun", target)
                    timer:update()

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- STUN.
                if bp.core.ready("Stun") then
                    bp.queue.add("Stun", target)
                    timer:update()

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

                    if bp.core.get('cascade') and bp.core.get('cascade').enabled and bp.__player.tp() >= bp.core.get('cascade').tp and bp.core.ready("Cascade", 598) and bp.actions.canAct() then
                        bp.queue.add("Cascade", target)
                    
                    end
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load