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
        local pet = bp.__player.pet()

        if player and target and pet and bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then

            if bp.core.get('spirit-surge') and bp.core.ready("Spirit Surge", 126) then
                bp.queue.add("Spirit Surge", player)

            end
            
            if bp.core.get('fly-high') and bp.core.ready("Fly High", 503) then
                bp.queue.add("Fly High", player)

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

                -- CALL WYVERN.
                if not pet and bp.core.get('call-wyvern') and bp.core.ready("Call Wyvern") then
                    bp.queue.add("Call Wyvern", player)

                end

                -- ANGON.
                if bp.core.get('angon') and bp.core.ready("Angon") and bp.__inventory.canEquip("Angon") and target then
                    bp.queue.add("Angon", target)
                
                end

                -- JUMP.
                if bp.core.get('jump') and bp.core.ready("Jump") and target then
                    bp.queue.add("Jump", target)

                -- HIGH JUMP.
                elseif bp.core.get('high-jump') and bp.core.ready("High Jump") and target then
                    bp.queue.add("High Jump", target)

                -- SUPER JUMP.
                elseif bp.core.get('super-jump') and bp.core.ready("Super Jump") and target then
                    bp.queue.add("Super Jump", target)

                -- SPIRIT JUMP.
                elseif bp.core.get('spirit-jump') and bp.core.ready("Spirit Jump") and target then
                    bp.queue.add("Spirit Jump", target)

                -- SOUL JUMP.
                elseif bp.core.get('soul-jump') and bp.core.ready("Soul Jump") and target then
                    bp.queue.add("Soul Jump", target)

                end

                if pet then

                    -- SMITING BREATH.
                    if bp.core.get('smiting-breath') and bp.core.ready("Smiting Breath") and target then

                        if bp.core.get('deep-breathing') and bp.core.ready("Deep Breathing") then
                            bp.queue.add("Deep Breathing", player)

                        end
                        bp.queue.add("Smiting Breath", target)

                    -- RESTORING BREATH.
                    elseif bp.core.get('restoring-breath') and bp.core.ready("Restoring Breath") then

                        if bp.core.get('deep-breathing') and bp.core.ready("Deep Breathing") then
                            bp.queue.add("Deep Breathing", player)

                        end
                        bp.queue.add("Restoring Breath", player)

                    -- STEADY WING.
                    elseif bp.core.get('steady-wing') and bp.core.ready("Steady Wing") then
                        bp.queue.add("Steady Wing", player)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- CALL WYVERN.
                if not pet and bp.core.get('call-wyvern') and bp.core.ready("Call Wyvern") then
                    bp.queue.add("Call Wyvern", player)

                end

                -- ANGON.
                if bp.core.get('angon') and bp.core.ready("Angon") and bp.__inventory.canEquip("Angon") and target then
                    bp.queue.add("Angon", target)
                
                end

                -- JUMP.
                if bp.core.get('jump') and bp.core.ready("Jump") and target then
                    bp.queue.add("Jump", target)

                -- HIGH JUMP.
                elseif bp.core.get('high-jump') and bp.core.ready("High Jump") and target then
                    bp.queue.add("High Jump", target)

                -- SUPER JUMP.
                elseif bp.core.get('super-jump') and bp.core.ready("Super Jump") and target then
                    bp.queue.add("Super Jump", target)

                -- SPIRIT JUMP.
                elseif bp.core.get('spirit-jump') and bp.core.ready("Spirit Jump") and target then
                    bp.queue.add("Spirit Jump", target)

                -- SOUL JUMP.
                elseif bp.core.get('soul-jump') and bp.core.ready("Soul Jump") and target then
                    bp.queue.add("Soul Jump", target)

                end

                if pet then

                    -- SMITING BREATH.
                    if bp.core.get('smiting-breath') and bp.core.ready("Smiting Breath") and target then

                        if bp.core.get('deep-breathing') and bp.core.ready("Deep Breathing") then
                            bp.queue.add("Deep Breathing", player)

                        end
                        bp.queue.add("Smiting Breath", target)

                    -- RESTORING BREATH.
                    elseif bp.core.get('restoring-breath') and bp.core.ready("Restoring Breath") then

                        if bp.core.get('deep-breathing') and bp.core.ready("Deep Breathing") then
                            bp.queue.add("Deep Breathing", player)

                        end
                        bp.queue.add("Restoring Breath", player)

                    -- STEADY WING.
                    elseif bp.core.get('steady-wing') and bp.core.ready("Steady Wing") then
                        bp.queue.add("Steady Wing", player)

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