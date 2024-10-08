local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        if bp.combat.get('auto_one_hours') and bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()
            local target = bp.__target.get('t')

            if player and target and player.status == 1 then

                -- HUNDRED FISTS.
                if bp.abilities.get('auto_hundred_fists') and bp.core.ready("Hundred Fists", 46) then
                    bp.queue.add("Hundred Fists", player)

                end
                
                -- INNER STRENGTH.
                if bp.abilities.get('auto_inner_strength') and bp.core.ready("Inner Strength", 491) then
                    bp.queue.add("Inner Strength", player)

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

                -- MANTRA.
                if bp.abilities.get('auto_mantra') and bp.core.ready("Mantra") and target then
                    bp.queue.add("Mantra", player)
                    
                end

                -- CHI BLAST.
                if bp.abilities.get('auto_chi_blast') and bp.core.ready("Chi Blast") then
                    bp.queue.add("Chi Blast", bp.targets.get('player'))

                end

            end

        end

        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if target then

                    -- DODGE.
                    if bp.abilities.get('auto_dodge') and bp.core.ready("Dodge", 60) then
                        bp.queue.add("Dodge", player)

                    -- FOCUS.
                    elseif bp.abilities.get('auto_focus') and bp.core.ready("Focus", 59) then
                        bp.queue.add("Focus", player)

                    -- IMPETUS.
                    elseif bp.abilities.get('auto_impetus') and bp.core.ready("Impetus", 461) then
                        bp.queue.add("Impetus", player)

                    -- FOOTWORK.
                    elseif bp.abilities.get('auto_footwork') and bp.core.ready("Footwork", 406) then
                        bp.queue.add("Footwork", player)

                    -- FORMLESS STRIKES.
                    elseif bp.abilities.get('auto_formless_strikes') and bp.core.ready("Formless Strikes", 341) then
                        bp.queue.add("Formless Strikes", player)

                    -- COUNTERSTANCE.
                    elseif bp.abilities.get('auto_counterstance') and bp.core.ready("Counterstance", 61) then
                        bp.queue.add("Counterstance", player)

                    -- PERFECT COUNTER.
                    elseif bp.abilities.get('auto_perfect_counter') and bp.core.ready("Perfect Counter", 436) then
                        bp.queue.add("Perfect Counter", player)

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