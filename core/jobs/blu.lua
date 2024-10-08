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

        -- MAGIC HAMMER.
        if target and bp.combat.get('auto_magic_hammer') then
            local spells = bp.__blu.getSpells()

            if spells:contains("Magic Hammer") and bp.core.ready("Magic Hammer") and bp.__player.mpp() < 25 then
                bp.queue.add("Magic Hammer", target)

            end
        
        end

        if player and target and bp.combat.get('auto_one_hours') and bp.combat.get('auto_job_abilities') and bp.actions.canAct() then

        end

        return self

    end

    function self:abilities()
        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') and bp.actions.canCast() then
            local player = bp.__player.get()
            local target = bp.targets.getCombatTarget()

            if bp.actions.canAct() then
                local diffusion = bp.core.get('auto_diffusion')

                -- DIFFUSION.
                if diffusion and diffusion.enabled and bp.core.ready("Diffusion") then

                end

            end

        end

        return self

    end

    function self:debuff()
        return self

    end

    function self:enmity()
        local enmity = bp.combat.get('auto_enmity_generation')

        if enmity and enmity.enabled and bp.core.timer('enmity'):ready() then
            local player = bp.__player.get()
            local target = bp.targets.getCombatTarget()

            if bp.actions.canCast() and target then

                if bp.__blu.hasHateSpells({"Blank Gaze"}) and bp.core.ready("Blank Gaze") then
                    bp.queue.add("Blank Gaze", target)

                elseif bp.combat.get('allow_aoe_enmity_spells') and bp.__blu.hasHateSpells({"Geist Wall","Jettatura","Soporific","Sheep Song"}) then

                    for spell in T{"Geist Wall","Jettatura","Soporific","Sheep Song"}:it() do

                        if bp.core.ready(spell) then
                            bp.queue.add(spell, target)
                            bp.core.timer('enmity'):update()
                            break

                        end

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        return self

    end
    
    return self

end
return load