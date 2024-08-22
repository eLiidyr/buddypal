local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        if bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then

        end

        return self

    end

    function self:abilities()
        
        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- SHIKIKOYO.
                if bp.core.get('shikikoyo') and bp.core.get('shikikoyo').enabled and bp.core.ready("Shikikoyo") then
                    local target = bp.__target.get(bp.core.get('shikikoyo').target)

                    if target and bp.__player.tp() >= bp.core.get('shikikoyo').tp and bp.__distance.get(target) <= bp.actions.getRange("Shikikoyo") then
                        bp.queue.add("Shikikoyo", target)

                    end

                end

                -- MEDITATE.
                if bp.core.get('meditate') and bp.core.ready("Meditate") and bp.__player.tp() < 1500 then
                    bp.queue.add("Meditate", player)

                end

                -- BLADE BASH.
                if bp.core.get('blade-bash') and bp.core.ready("Blade Bash") and target then
                    bp.queue.add("Blade Bash", target)

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- SHIKIKOYO.
                if bp.core.get('shikikoyo') and bp.core.get('shikikoyo').enabled and bp.core.ready("Shikikoyo") then
                    local target = bp.__target.get(bp.core.get('shikikoyo').target)

                    if target and bp.__player.tp() >= bp.core.get('shikikoyo').tp and bp.__distance.get(target) <= bp.actions.getRange("Shikikoyo") then
                        bp.queue.add("Shikikoyo", target)

                    end

                end

                -- MEDITATE.
                if bp.core.get('meditate') and bp.core.ready("Meditate") and bp.__player.tp() < 1500 then
                    bp.queue.add("Meditate", player)
                
                end

                -- BLADE BASH.
                if bp.core.get('blade-bash') and bp.core.ready("Blade Bash") and target then
                    bp.queue.add("Blade Bash", target)
                
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

                if bp.actions.canAct() then

                    -- THIRD EYE.
                    if bp.core.get('third-eye') and bp.core.ready("Third Eye", 67) then
                        bp.queue.add("Third Eye", player)

                    end

                    -- HASSO.
                    if bp.core.get('hasso') and not bp.core.get('tank-mode') and bp.core.ready("Hasso", 353) then
                        local main = bp.__equipment.get(0)

                        if main then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(main.bag, main.index)

                            if index and res and S{4,6,7,8,10,12}:contains(res.skill) then
                                bp.queue.add("Hasso", player)

                            end

                        end

                    -- SEIGAN.
                    elseif bp.core.get('seigan') and bp.core.get('tank-mode') and bp.core.ready("Seigan", 354) then
                        bp.queue.add("Seigan", player)

                    -- SEKKANOKI.
                    elseif bp.core.get('sekkanoki') and bp.core.ready("Sekkanoki", 408) then

                        if bp.core.get('aftermath') and bp.core.get('aftermath').enabled then

                            if bp.__aftermath.active() then
                                bp.queue.add("Sekkanoki", player)

                            end

                        elseif (not bp.core.get('aftermath') or (bp.core.get('aftermath') and not bp.core.get('aftermath').enabled)) then
                            bp.queue.add("Sekkanoki", player)

                        end

                    -- KONZEN-ITTAI.
                    elseif bp.core.get('konzen-ittai') and bp.core.ready("Konzen-Ittai") then
                        bp.queue.add("Konzen-Ittai", player)

                    -- SENGIKORI.
                    elseif bp.core.get('sengikori') and bp.core.ready("Sengikori", 440) then
                        bp.queue.add("Sengikori", player)

                    -- HAMANOHA.
                    elseif bp.core.get('hamanoha') and bp.core.ready("Hamanoha", 465) then
                        bp.queue.add("Hamanoha", player)

                    -- HAGAKURE.
                    elseif bp.core.get('hagakure') and bp.core.ready("Hagakure", 483) then
                        bp.queue.add("Hagakure", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- THIRD EYE.
                    if bp.core.get('third-eye') and bp.core.ready("Third Eye", 67) then
                        bp.queue.add("Third Eye", player)

                    end

                    -- HASSO.
                    if bp.core.get('hasso') and not bp.core.get('tank-mode') and bp.core.ready("Hasso", 353) then
                        local main = bp.__equipment.get(0)

                        if main then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(main.bag, main.index)

                            if index and res and S{4,6,7,8,10,12}:contains(res.skill) then
                                bp.queue.add("Hasso", player)

                            end

                        end

                    -- SEIGAN.
                    elseif bp.core.get('seigan') and bp.core.get('tank-mode') and bp.core.ready("Seigan", 354) then
                        bp.queue.add("Seigan", player)

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

        if bp.core.get('hate') and bp.core.get('hate').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('nuke-mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

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