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

            if bp.abilities.get('auto_meikyo_shisui') and bp.core.ready("Meikyo Shisui", 44) then
                bp.queue.add("Meikyo Shisui", player)

            end
            
            if bp.abilities.get('auto_yaegasumi') and bp.core.ready("Yaegasumi", 490) then
                bp.queue.add("Yaegasumi", player)

            end

        end

        return self

    end

    function self:abilities()
        
        if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- SHIKIKOYO.
                if bp.abilities.get('auto_shikikoyo') then
                    local shikikoyo = bp.abilities.get('shikikoyo')
                    
                    if shikikoyo.enabled and bp.core.ready("Shikikoyo") then
                        local target = bp.__target.get(shikikoyo.target)

                        if target and bp.__player.tp() >= shikikoyo.tp and bp.__distance.get(target) <= bp.actions.getRange("Shikikoyo") then
                            bp.queue.add("Shikikoyo", target)

                        end

                    end

                end

                -- MEDITATE.
                if bp.abilities.get('auto_meditate') and bp.core.ready("Meditate") and bp.__player.tp() < 1500 then
                    bp.queue.add("Meditate", player)

                end

                -- BLADE BASH.
                if bp.abilities.get('auto_blade_bash') and bp.core.ready("Blade Bash") and target then
                    bp.queue.add("Blade Bash", target)

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- MEDITATE.
                if bp.abilities.get('auto_meditate') and bp.core.ready("Meditate") and bp.__player.tp() < 1500 then
                    bp.queue.add("Meditate", player)

                end

                -- BLADE BASH.
                if bp.abilities.get('auto_blade_bash') and bp.core.ready("Blade Bash") and target then
                    bp.queue.add("Blade Bash", target)

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

                if bp.actions.canAct() then
                    local aftermath = bp.core.get('auto_aftermath')

                    -- THIRD EYE.
                    if bp.abilities.get('auto_third_eye') and bp.core.ready("Third Eye", 67) then
                        bp.queue.add("Third Eye", player)

                    end

                    -- HASSO.
                    if bp.abilities.get('auto_hasso') and not bp.combat.get('auto_tank_mode') and bp.core.ready("Hasso", 353) then
                        local main = bp.__equipment.get(0)

                        if main then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(main.bag, main.index)

                            if index and res and S{4,6,7,8,10,12}:contains(res.skill) then
                                bp.queue.add("Hasso", player)

                            end

                        end

                    -- SEIGAN.
                    elseif bp.abilities.get('auto_seigan') and bp.combat.get('auto_tank_mode') and bp.core.ready("Seigan", 354) then
                        bp.queue.add("Seigan", player)

                    -- SEKKANOKI.
                    elseif bp.abilities.get('auto_sekkanoki') and bp.core.ready("Sekkanoki", 408) then

                        if aftermath and aftermath.enabled then

                            if bp.__aftermath.active() then
                                bp.queue.add("Sekkanoki", player)

                            end

                        elseif (not aftermath or (aftermath and not aftermath.enabled)) then
                            bp.queue.add("Sekkanoki", player)

                        end

                    -- KONZEN-ITTAI.
                    elseif bp.abilities.get('auto_konzen_ittai') and bp.core.ready("Konzen-Ittai") then
                        bp.queue.add("Konzen-Ittai", player)

                    -- SENGIKORI.
                    elseif bp.abilities.get('auto_sengikori') and bp.core.ready("Sengikori", 440) then
                        bp.queue.add("Sengikori", player)

                    -- HAMANOHA.
                    elseif bp.abilities.get('auto_hamanoha') and bp.core.ready("Hamanoha", 465) then
                        bp.queue.add("Hamanoha", player)

                    -- HAGAKURE.
                    elseif bp.abilities.get('auto_hagakure') and bp.core.ready("Hagakure", 483) then
                        bp.queue.add("Hagakure", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- THIRD EYE.
                    if bp.abilities.get('auto_third_eye') and bp.core.ready("Third Eye", 67) then
                        bp.queue.add("Third Eye", player)

                    end

                    -- HASSO.
                    if bp.abilities.get('auto_hasso') and not bp.combat.get('auto_tank_mode') and bp.core.ready("Hasso", 353) then
                        local main = bp.__equipment.get(0)

                        if main then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(main.bag, main.index)

                            if index and res and S{4,6,7,8,10,12}:contains(res.skill) then
                                bp.queue.add("Hasso", player)

                            end

                        end

                    -- SEIGAN.
                    elseif bp.abilities.get('auto_seigan') and bp.combat.get('auto_tank_mode') and bp.core.ready("Seigan", 354) then
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
        return self

    end

    function self:nuke()
        return self

    end
    
    return self

end
return load