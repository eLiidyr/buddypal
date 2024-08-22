local function load(bp, settings)
    local self = {}

    local deploy_target = false

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.core.get('one-hours') and bp.actions.canAct() then

            if bp.core.get('overdrive') and bp.core.ready("Overdrive", 166) then
                bp.queue.add("Overdrive", player)

            end
            
            if bp.core.get('heady-artifice') and bp.core.ready("Heady Artifice") then
                bp.queue.add("Heady Artifice", player)

            end

        end

        return self

    end

    function self:abilities()
        local pet = bp.__player.pet()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if not pet then

                    -- ACTIVATE.
                    if bp.core.get('activate') and not bp.queue.search({"Activate","Deus Ex"}) then

                        if bp.core.ready("Activate") then
                            bp.queue.add("Activate", bp.__player.get())

                        elseif bp.core.ready("Deus Ex Automata") then
                            bp.queue.add("Deus Ex Automata", bp.__player.get())

                        end

                    end

                elseif pet and not T{2,3}:contains(pet.status) then

                    -- REPAIR.
                    if bp.core.get('repair') and bp.core.get('repair').enabled and bp.core.ready("Repair") and pet.hpp < bp.core.get('repair').hpp and target then
                        local oil = bp.__equipment.get(3)

                        if oil and oil.index > 0 then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(oil.bag, oil.index)

                            if index and status and res and res.en:startswith("Automat") then

                                if status == 5 then
                                    bp.queue.add("Repair", bp.__player.get())

                                elseif status == 0 then
                                    bp.actions.equipItem(index, 3, 0)

                                end

                            end

                        end

                    end

                    -- MANEUVERS.
                    if pet.status == 1 and bp.core.get('maneuvers') and bp.core.get('maneuvers').enabled and bp.core.ready("Fire Maneuver", 299) then
                        local active = bp.__maneuvers.active(true)

                        if #active < 3 then
                            local maneuvers = bp.__maneuvers.missing()

                            if maneuvers:length() > 0 and not bp.queue.search(maneuvers[1]) then
                                bp.queue.add(maneuvers[1], bp.__player.get())

                            end

                        end

                    end

                    -- COOLDOWN.
                    if bp.core.get('cooldown') and bp.core.ready("Cooldown") and bp.__maneuvers.active(true):length() == 3 then
                        bp.queue.add("Cooldown", bp.__player.get())

                    end

                    if pet.status == 0 then

                        -- DEPLOY.
                        if bp.core.get('deploy') and bp.core.ready("Deploy") and target then
                            bp.queue.add("Deploy", target)
                            deploy_target = target.id

                        end

                    elseif pet.status == 1 then

                        -- D.A.D. METHOD.
                        if bp.core.get('dad-method') and bp.__player.petmpp() < 18 then
                            bp.queue.add("Deactivate", bp.__player.get())
                            bp.queue.add("Activate", bp.__player.get())
                            bp.queue.add("Deploy", target)

                        else

                            -- RETRIEVE.
                            if not bp.core.get('deploy') and bp.core.ready("Retrieve") then
                                bp.queue.add("Retrieve", bp.__player.get())
                                
                            end

                            -- ASSIST-MASTER.
                            if bp.core.get('deploy') and bp.core.ready("Deploy") and target and target.id ~= deploy_target then
                                bp.queue.add("Deploy", target)
                                deploy_target = target.id

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if not pet then

                    -- ACTIVATE.
                    if bp.core.get('activate') and not bp.queue.search({"Activate","Deus Ex"}) then

                        if bp.core.ready("Activate") then
                            bp.queue.add("Activate", bp.__player.get())

                        elseif bp.core.ready("Deus Ex Automata") then
                            bp.queue.add("Deus Ex Automata", bp.__player.get())

                        end

                    end

                elseif pet and not T{2,3}:contains(pet.status) then

                    -- REPAIR.
                    if bp.core.get('repair') and bp.core.get('repair').enabled and bp.core.ready("Repair") and pet.hpp < bp.core.get('repair').hpp and target then
                        local oil = bp.__equipment.get(3)

                        if oil and oil.index > 0 then
                            local index, count, id, status, bag, res = bp.__inventory.getByIndex(oil.bag, oil.index)

                            if index and status and res and res.en:startswith("Automat") then

                                if status == 5 then
                                    bp.queue.add("Repair", bp.__player.get())

                                elseif status == 0 then
                                    bp.actions.equipItem(index, 3, 0)

                                end

                            end

                        end

                    end

                    -- MANEUVERS.
                    if pet.status == 1 and bp.core.get('maneuvers') and bp.core.get('maneuvers').enabled and bp.core.ready("Fire Maneuver", 299) then
                        local active = bp.__maneuvers.active(true)

                        if #active < 3 then
                            local maneuvers = bp.__maneuvers.missing()

                            if maneuvers:length() > 0 and not bp.queue.search(maneuvers[1]) then
                                bp.queue.add(maneuvers[1], bp.__player.get())

                            end

                        end

                    end

                    -- COOLDOWN.
                    if bp.core.get('cooldown') and bp.core.ready("Cooldown") and bp.__maneuvers.active(true):length() == 3 then
                        bp.queue.add("Cooldown", bp.__player.get())

                    end

                    if pet.status == 0 then

                        -- DEPLOY ON AGGRO.
                        if bp.core.get('deploy-on-aggro') and bp.__aggro.hasAggro() and not target then
                            local target = bp.__target.get(bp.__aggro.getAggro()[1])
                            
                            -- DEPLOY.
                            if bp.core.get('deploy') and bp.core.ready("Deploy") and target then
                                bp.queue.add("Deploy", target)
                                deploy_target = target.id

                                -- TARGET-ON-AGGRO.
                                if bp.core.get('target-on-aggro') then
                                    bp.targets.set(target)

                                end

                            end

                        elseif target then

                            -- DEPLOY.
                            if bp.core.get('deploy') and bp.core.ready("Deploy") then
                                bp.queue.add("Deploy", target)
                                deploy_target = target.id

                            end

                        end

                    elseif pet.status == 1 then

                        -- D.A.D. METHOD.
                        if bp.core.get('dad-method') and bp.__player.petmpp() < 18 then
                            bp.queue.add("Deactivate", bp.__player.get())
                            bp.queue.add("Activate", bp.__player.get())
                            bp.queue.add("Deploy", target)

                        else

                            -- RETRIEVE.
                            if not bp.core.get('deploy') and bp.core.ready("Retrieve") then
                                bp.queue.add("Retrieve", bp.__player.get())
                                
                            end

                            -- ASSIST-MASTER.
                            if bp.core.get('deploy') and bp.core.ready("Deploy") and target and target.id ~= deploy_target then
                                bp.queue.add("Deploy", target)
                                deploy_target = target.id

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:buff()
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