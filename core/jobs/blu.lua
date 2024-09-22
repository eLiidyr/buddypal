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

        if player and target and bp.core.get('auto_one_hours') and bp.actions.canAct() then

        end

        return self

    end

    function self:abilities()
        return self

    end

    function self:buff()

        if bp.core.get('auto_buffing') and bp.actions.canCast() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then
                    local diffusion = bp.core.get('auto_diffusion')

                    -- DIFFUSION.
                    if diffusion and diffusion.enabled and bp.core.ready("Diffusion") then
                        local spell = bp.__res.get(diffusion.name)
                        local spells = bp.__blu.getSpells()

                        if spell and target and bp.core.ready(spell.en, spell.status) and spells:contains(spell.en) then
                            local unbridled = T{"Carcharian Verve","Mighty Guard","Pyric Bulwark","Harden Shell"}

                            if unbridled:contains(spell.en) then

                                if bp.core.get('auto_unbridled_learning') and bp.core.ready("Unbridled Learning", 485) then
                                    bp.queue.add("Unbridled Learning", player)
                                    bp.queue.add("Diffusion", player)
                                    bp.queue.add(spell, player)

                                end

                            else
                                bp.queue.add("Diffusion", player)
                                bp.queue.add(spell, player)

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then
                    local diffusion = bp.core.get('auto_diffusion')

                    -- DIFFUSION.
                    if diffusion and diffusion.enabled and bp.core.ready("Diffusion") then
                        local spell = bp.__res.get(diffusion.name)
                        local spells = bp.__blu.getSpells()

                        if spell and target and bp.core.ready(spell.en, spell.status) and spells:contains(spell.en) then
                            local unbridled = T{"Carcharian Verve","Mighty Guard","Pyric Bulwark","Harden Shell"}

                            if unbridled:contains(spell.en) then

                                if bp.core.get('auto_unbridled_learning') and bp.core.ready("Unbridled Learning", 485) then
                                    bp.queue.add("Unbridled Learning", player)
                                    bp.queue.add("Diffusion", player)
                                    bp.queue.add(spell, player)

                                end

                            else
                                bp.queue.add("Diffusion", player)
                                bp.queue.add(spell, player)

                            end

                        end

                    end

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
        local timer = bp.core.timer('enmity')

        if bp.core.get('auto_enmity_generation') and bp.core.get('auto_enmity_generation').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.__blu.hasHateSpells({"Blank Gaze"}) and bp.core.ready("Blank Gaze") then
                    bp.queue.add("Blank Gaze", target)

                elseif bp.core.get('auto_enmity_generation').aoe and bp.__blu.hasHateSpells({"Geist Wall","Jettatura","Soporific","Sheep Song"}) then

                    for spell in T{"Geist Wall","Jettatura","Soporific","Sheep Song"}:it() do

                        if bp.core.ready(spell) then
                            bp.queue.add(spell, target)

                        end

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')
        local spells = bp.__blu.getSpells()

        -- MAGIC HAMMER.
        if bp.core.get('auto_magic_hammer') and bp.core.get('auto_magic_hammer').enabled and spells:contains("Magic Hammer") and bp.core.ready("Magic Hammer") and bp.__player.mpp() < bp.core.get('auto_magic_hammer').mpp and target then
            bp.queue.add("Magic Hammer", target)
        
        end

        return self

    end
    
    return self

end
return load