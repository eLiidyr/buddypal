local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local automation = nil

    -- Public Variables.

    -- Private Methods.
    local function onload(mjob, sjob)
        o.timer('master-loop', 0.5)
        o.timer('sleeps', 5)
        o.timer('aoe-sleeps', 5)
        o.timer('enmity', 1)

        -- Load up core automation.
        o.getAutomation(mjob or nil, sjob or nil)

    end

    local function job_change(mid, _, sid, _)
        local mjob = bp.res.jobs[mid]
        local sjob = bp.res.jobs[sid]

        if mjob then
            onload(mjob and mjob.ens:lower(), sjob and sjob.ens:lower())

        end

    end

    local function automate()

        -- Handle Trust before performing any kind of actions.
        --if bp.trust.isEnabled() and bp.trust.canSummon() then
            --bp.trust.summon()
            --return

        --end

        -- Handle skillup logic if enabled.
        if bp.skillup.isEnabled() then
            automation:skillup()
            return

        end

        -- Handle item usage.
        --automation:medicine()

        -- Handle curing if available.
        automation:curing()

        -- Handle status fixes.
        automation:statusfix()

        -- Handle one-hours.
        automation:specials().subjob:specials()

        -- Handle holding hate.
        automation:enmity().subjob:enmity()

        -- Handle non-buff abilities.
        automation:abilities().subjob:abilities()

        -- Handle buffing.
        automation:buff().subjob:buff()
        --automation:buffing()

        -- Handle debuffing.
        automation:debuff().subjob:debuff()

        -- Handle weaponskills.
        automation:weaponskill()

        -- Handle casting nukes if available.
        automation:nuke()

        -- Handle ranged attacks if nothing else.
        automation:ranged()

    end

    local function master_loop()
        local loop = o.timer('master-loop')

        if bp.enabled and loop:ready() and bp.__player.get() and not bp.zoning.isInJail() and not bp.zoning.isInTown() then
            automate()
            loop:update()

        end

    end

    -- Public Methods.
    o.getAutomation = function(mjob, sjob)
        local mjob = mjob or bp.__player.mjob(true)
        local sjob = sjob or bp.__player.sjob(true)
        local file = bp.files.new(string.format('core/jobs/%s.lua', mjob))

        if file:exists() then
            automation = dofile(("%score/jobs/%s.lua"):format(bp.path, mjob))(bp)
            
            -- Handle weaponskill function.
            function automation:weaponskill()
                bp.combat.handle_weaponskills()
            
            end

            -- Handle ranged attacks.
            function automation:ranged()
                bp.combat.handle_ranged()
            
            end

            -- Handle fixing status effects.
            function automation:statusfix()
                bp.statusfix.fix()
            
            end

            -- Handle skillup mode.
            function automation:skillup()
                bp.skillup.handle()
            
            end
            
            -- handle using medicines.
            function automation:medicine()
            
            end
            
            -- Handle curing party members.
            function automation:curing()
                bp.cures.handleCuring()
            
            end
            
            -- handle self buffing, and buffing party members.
            function automation:buffing()
                bp.buffs.handleBuffing()
            
            end

            if bp.__player.hasSubjob() then
                local sub = dofile(("%score/jobs/%s.lua"):format(bp.path, sjob))(bp)

                if automation and not automation.subjob then
                    automation.subjob = sub

                end

            else

                -- If subjob is not currently active, then just return an empty placeholder.
                local function load(bp)
                    local sj = {}
                    function sj:items() return sj end
                    function sj:specials() return sj end
                    function sj:abilities() return sj end
                    function sj:buff() return sj end
                    function sj:debuff() return sj end
                    function sj:enmity() return sj end
                    function sj:nuke() return sj end
                    function sj:weaponskill() return sj end
                    function sj:ranged() return sj end
                    function sj:statusfix() return sj end
                    function sj:skillup() return sj end
                    function sj:medicine() return sj end
                    function sj:curing() return sj end
                    function sj:buffing() return sj end
                    return sj

                end
                automation.subjob = load(bp, settings)

            end

        end

    end

    o.ready = function(action, buffs)

        if action and bp.actions.isReady(action) and not bp.queue.inQueue(action) then

            if buffs and not bp.__buffs.active(buffs) then
                return true

            elseif buffs == nil then
                return true
                
            end

        end
        return false

    end

    -- Private Events.
    o.events('prerender', master_loop)
    o.events('job change', job_change)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper