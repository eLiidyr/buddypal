local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then
            local pet = bp.__player.pet()

            if pet.status == 0 and target then

                -- ASTRAL FLOW.
                if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault') then
                    bp.queue.add("Astral Flow", player)
                    
                end

                -- USE APOGEE BEFORE ASTRAL CONDUIT.
                if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                    -- ASTRAL CONDUIT.
                    if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault')) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                        bp.queue.add("Astral Conduit", player)

                    end

                end

            elseif pet.status == 1 and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and target then

                -- ASTRAL FLOW.
                if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled then
                    bp.queue.add("Astral Flow", player)

                end

                -- USE APOGEE BEFORE ASTRAL CONDUIT.
                if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                    -- ASTRAL CONDUIT.
                    if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                        bp.queue.add("Astral Conduit", player)

                    end

                end

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()
            local pet = bp.__player.pet()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if pet then

                    -- RELEASE.
                    if bp.core.get('summon') and bp.core.get('summon').enabled and pet.name ~= bp.core.get('summon').name and bp.core.ready("Release") then
                        bp.queue.add("Release", player)

                    -- AVATARS FAVOR.
                    elseif bp.core.ready("Avatar's Favor", 431) then
                        bp.queue.add("Avatar's Favor", player)

                    elseif pet.status == 0 and target then

                        -- ASSAULT.
                        if bp.core.get('assault') and bp.core.ready("Assault") then
                            bp.queue.add("Assault", target)
                        end

                    end

                    -- BLOOD PACTS THAT PURELY DEAL DAMAGE & MEWING.
                    if pet.status == 0 and target then

                        -- ASTRAL FLOW.
                        if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault') then
                            bp.queue.add("Astral Flow", player)

                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault')) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                                bp.queue.add("Astral Conduit", player)

                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault') then
                            local rage = bp.core.get('bp-rage').pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if bp.core.get('apogee') and bp.core.ready("Apogee", 583) then
                                    bp.queue.add("Apogee", player)

                                -- MANA CEDE.
                                elseif bp.core.get('mana-cede') and bp.core.ready("Mana Cede") then
                                    bp.queue.add("Mana Cede", player)

                                else
                                    bp.queue.add(rage, target)
                                    
                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.queue.add(ward, target)

                            end

                        end

                    elseif pet.status == 1 and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and target then

                        -- ASTRAL FLOW.
                        if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled then
                            bp.queue.add("Astral Flow", player)

                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                                bp.queue.add("Astral Conduit", player)

                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled then
                            local rage = bp.core.get('bp-rage').pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if bp.core.get('apogee') and bp.core.ready("Apogee", 583) then
                                    bp.queue.add("Apogee", player)

                                -- MANA CEDE.
                                elseif bp.core.get('mana-cede') and bp.core.ready("Mana Cede") then
                                    bp.queue.add("Mana Cede", player)

                                else
                                    bp.queue.add(rage, target)

                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.queue.add(ward, target)

                            end

                        end

                    end

                elseif not pet then

                    -- SUMMON.
                    if bp.core.get('summon') and bp.core.get('summon').enabled and bp.core.ready(bp.core.get('summon').name) and bp.actions.canCast() then
                        bp.queue.add(bp.core.get('summon').name, player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if pet then

                    -- RELEASE.
                    if bp.core.get('summon') and bp.core.get('summon').enabled and pet.name ~= bp.core.get('summon').name and bp.core.ready("Release") then
                        bp.queue.add("Release", player)

                    -- AVATARS FAVOR.
                    elseif bp.core.ready("Avatar's Favor", 431) then
                        bp.queue.add("Avatar's Favor", player)

                    elseif pet.status == 0 and target then

                        -- ASSAULT.
                        if bp.core.get('assault') and bp.core.ready("Assault") then
                            bp.queue.add("Assault", target)

                        end

                    end

                    -- BLOOD PACTS THAT PURELY DEAL DAMAGE & MEWING.
                    if pet.status == 0 and target then

                        -- ASTRAL FLOW.
                        if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault') then
                            bp.queue.add("Astral Flow", player)

                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault')) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                                bp.queue.add("Astral Conduit", player)

                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and not bp.core.get('assault') then
                            local rage = bp.core.get('bp-rage').pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if bp.core.get('apogee') and bp.core.ready("Apogee", 583) then
                                    bp.queue.add("Apogee", player)

                                -- MANA CEDE.
                                elseif bp.core.get('mana-cede') and bp.core.ready("Mana Cede") then
                                    bp.queue.add("Mana Cede", player)

                                else
                                    bp.queue.add(rage, target)
                                    
                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.queue.add(ward, target)

                            end

                        end

                    elseif pet.status == 1 and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled and target then

                        -- ASTRAL FLOW.
                        if bp.core.get('astral-flow') and bp.core.ready("Astral Flow", 55) and bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled then
                            bp.queue.add("Astral Flow", player)

                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not bp.core.get('apogee') or bp.core.get('apogee') and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if bp.core.get('astral-conduit') and bp.core.ready("Astral Conduit", 504) and (bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled) or (bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and bp.core.get('bp-ward').pacts[pet.name] == "Mewing Lullaby") then
                                bp.queue.add("Astral Conduit", player)

                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if bp.core.get('bp-rage') and bp.core.get('bp-rage').enabled then
                            local rage = bp.core.get('bp-rage').pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if bp.core.get('apogee') and bp.core.ready("Apogee", 583) then
                                    bp.queue.add("Apogee", player)

                                -- MANA CEDE.
                                elseif bp.core.get('mana-cede') and bp.core.ready("Mana Cede") then
                                    bp.queue.add("Mana Cede", player)

                                else
                                    bp.queue.add(rage, target)

                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.queue.add(ward, target)

                            end

                        end

                    end

                elseif not pet then

                    -- SUMMON.
                    if bp.core.get('summon') and bp.core.get('summon').enabled and bp.core.ready(bp.core.get('summon').name) and bp.actions.canCast() then
                        bp.queue.add(bp.core.get('summon').name, player)

                    end

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

                if bp.actions.canAct() and bp.__player.pet() then
                    local pet = bp.__player.pet()

                    -- BLOOD PACTS THAT GIVE A PLAYER OR PLAYERS A BUFF.
                    if pet.status == 0 and not bp.__buffs.active(504) then

                        -- BLOOD PACT: WARDS.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                bp.queue.add(ward, player)

                            end

                        end

                    elseif pet.status == 1 and not bp.__buffs.active(504) then

                        -- BLOOD PACT: WARDS.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                bp.queue.add(ward, player)

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() and bp.__player.pet() then
                    local pet = bp.__player.pet()

                    -- BLOOD PACTS THAT GIVE A PLAYER OR PLAYERS A BUFF.
                    if pet.status == 0 and not bp.__buffs.active(504) then

                        -- BLOOD PACT: WARDS.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled and not bp.core.get('assault') then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                bp.queue.add(ward, player)

                            end

                        end

                    elseif pet.status == 1 and not bp.__buffs.active(504) then

                        -- BLOOD PACT: WARDS.
                        if bp.core.get('bp-ward') and bp.core.get('bp-ward').enabled then
                            local ward = bp.core.get('bp-ward').pacts[pet.name] or false

                            if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                bp.queue.add(ward, player)

                            end

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