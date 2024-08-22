local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
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

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- HANDLE SONGS.
                if bp.actions.canCast() then
                    bp.songs.handleLoops()
                
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