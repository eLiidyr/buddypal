local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        if settings.ja and settings['1hr'] and bp.actions.canAct() then

        end

        return self

    end

    function self:abilities()

        if settings.ja and bp.actions.canAct() then

            if bp.__player.status() == 1 then

            elseif bp.__player.status() == 0 then

            end

        end

        return self

    end

    function self:buff()

        if settings.buffs then

            if bp.__player.status() == 1 then

            elseif bp.__player.status() == 0 then

            end

        end

        return self

    end

    function self:debuff()

        if settings.debuffs and bp.actions.canCast() then

            if bp.__player.status() == 1 then

            elseif bp.__player.status() == 0 then

            end

        end

        return self

    end

    function self:enmity()
        local timer = bp.core.timer('enmity')

        if settings.hate and settings.hate.enabled and timer:ready() then

            if bp.__player.status() == 1 then

            elseif bp.__player.status() == 0 then

            end

        end

        return self

    end

    function self:nuke()

        if settings.nuke and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.isReady(spell) and not bp.core.inQueue(spell) then
                    bp.queue.add(spell, target, bp.core.priority(spell))
                end

            end

        end

        return self

    end
    
    return self

end
return load