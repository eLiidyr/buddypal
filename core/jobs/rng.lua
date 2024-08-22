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

        if player and target and bp.core.get('one-hours') and bp.actions.canAct() then

            if bp.core.get("eagle-eye-shot") and bp.core.ready("Eagle Eye Shot") then
                bp.queue.add("Eagle Eye Shot", target)

            end
            
            if bp.core.get('overkill') and bp.core.ready("Overkill", 500) then
                bp.queue.add("Overkill", player)

            end

        end

        return self

    end

    function self:abilities()
        return self

    end

    function self:buff()

        if bp.core.get('buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- BOUNTY SHOT.
                    if bp.core.get('bounty-shot') and bp.core.ready("Bounty Shot") then
                        bp.queue.add("Bounty Shot", player)

                    end

                    -- DECOY SHOT.
                    if bp.core.get('decoy-shot') and bp.core.ready("Decoy Shot") then
                        local decoy = bp.__target.get(bp.core.get('decoy-shot').target)

                        if decoy and bp__actions.isBehind(decoy) and bp.__distance.get(decoy) <= 20 then
                            bp.queue.add("Decoy Shot", player)

                        end

                    end

                    -- SHARPSHOT.
                    if bp.core.get('sharpshot') and bp.core.ready("Sharpshot", 72) then
                        bp.queue.add("Sharpshot", player)

                    end

                end

            elseif player and player.status == 0 then

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