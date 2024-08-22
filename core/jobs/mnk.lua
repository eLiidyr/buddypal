local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()

        if player and player.status == 1 and bp.core.get('one-hours') and bp.actions.canAct() and bp.targets.get('player') then

            -- HUNDRED FISTS.
            if bp.core.get('hundred-fists') and bp.core.ready("Hundred Fists", 46) then
                bp.queue.add("Hundred Fists", player)

            end
            
            -- INNER STRENGTH.
            if bp.core.get('inner-strength') and bp.core.ready("Inner Strength", 491) then
                bp.queue.add("Inner Strength", player)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- MANTRA.
                if bp.core.get('mantra') and bp.core.ready("Mantra") and target then
                    bp.queue.add("Mantra", player)
                    
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

                    -- DODGE.
                    if bp.core.get('dodge') and bp.core.ready("Dodge", 60) then
                        bp.queue.add("Dodge", player)

                    -- FOCUS.
                    elseif bp.core.get('focus') and bp.core.ready("Focus", 59) then
                        bp.queue.add("Focus", player)

                    -- IMPETUS.
                    elseif bp.core.get('impetus') and bp.core.ready("Impetus", 461) then
                        bp.queue.add("Impetus", player)

                    -- FOOTWORK.
                    elseif bp.core.get('footwork') and bp.core.ready("Footwork", 406) then
                        bp.queue.add("Footwork", player)

                    -- FORMLESS STRIKES.
                    elseif bp.core.get('formless-strikes') and bp.core.ready("Formless Strikes", 341) then
                        bp.queue.add("Formless Strikes", player)

                    -- COUNTERSTANCE.
                    elseif bp.core.get('counterstance') and bp.core.ready("Counterstance", 61) then
                        bp.queue.add("Counterstance", player)

                    -- PERFECT COUNTER.
                    elseif bp.core.get('perfect-counter') and bp.core.ready("Perfect Counter", 436) then
                        bp.queue.add("Perfect Counter", player)

                    end

                end

            end

        end

        return self

    end

    function self:debuff()

        -- CHI BLAST.
        if bp.core.get('job-abilities') and bp.actions.canAct() and bp.core.get('chi-blast') and bp.core.ready("Chi Blast") and bp.targets.get('player') then
            bp.queue.add("Chi Blast", bp.targets.get('player'))

        end

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