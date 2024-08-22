local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new(string.format("jobs/%s", bp.__player.mjob(true)))
    local switches  = bp.files.new('resources/switches.lua'):exists() and dofile(string.format('%sresources/switches.lua', bp.path)) or {}
    local automation = nil

    do -- Setup default setting values.
        settings.core = T(settings.core)

    end

    -- Public Variables.

    -- Private Methods.
    local function updateSettings(base, core)
        local updated = false

        for k, v in pairs(base) do

            if type(v) == 'table' then

                if core and core[k] == nil then
                    core[k] = v
                    updated = true
                
                end
                updateSettings(v, core[k])

            else
                
                if core and core[k] == nil then
                    core[k] = v
                    updated = true

                end

            end

        end
        return updated

    end

    local function filterSettings()
        return T(settings):key_filter(function(key) return (#key > 3 or S{bp.__player.mjob(), bp.__player.sjob()}:contains(key)) end)

    end

    local function onload(mjob, sjob)
        local updated = updateSettings(o.getBase(), settings.core)
        settings:save()
        
        if updated then
            -- Lets add some sort of indicator that lets us know our character has new settings.

        end

        -- Create timers needed for the helper.
        o.timer('master-loop', 0.5)
        o.timer('sleeps', 5)
        o.timer('aoe-sleeps', 5)
        o.timer('enmity', settings.auto_enmity_generation.delay or 1)

        -- Load up core automation.
        o.getAutomation(settings, mjob or nil, sjob or nil)

        -- Send data to the client.
        bp.socket.sendSettings({['core']=settings.core})

    end

    local function job_change(mid, _, sid, _)
        local mjob = bp.res.jobs[mid]
        local sjob = bp.res.jobs[sid]

        if mjob then
            settings = bp.__settings.new(string.format("jobs/%s", mjob.ens:lower()))
            settings.core = T(settings.core)
            onload(mjob and mjob.ens:lower(), sjob and sjob.ens:lower())

        end

    end

    local function handle_weaponskills()
        local target = bp.targets.get('player')
        local status = bp.__player.status()

        if status == 1 or (status == 0 and target) then
            local target = (status == 1) and bp.__target.get('t') or target or false
            local limits = bp.core.get('hpp-limit')

            -- Handle Skillchains.
            -- Handle HP% Limiting weapon skills.
            if target and limits and limits.enabled then

                if limits.option == '>' and target.hpp < limits.hpp then
                    return

                elseif limits.option == '<' and target.hpp > limits.hpp then
                    return

                end

            end

            -- Handle melee distance weapon skills.
            if target and bp.core.get('melee-weaponskill') and bp.core.get('melee-weaponskill').enabled and bp.__target.inRange(target) and bp.core.canAct() then
                local sanguine  = bp.core.get('sanguine-blade')
                local myrkr     = bp.core.get('myrkr')
                local moonlight = bp.core.get('moonlight')

                if sanguine and sanguine.enabled and bp.__player.hpp() <= sanguine.hpp and bp.actions.isReady("Sanguine Blade") and bp.actions.inActionRange("Sanguine Blade", target) then

                    if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                        bp.queue.add("Sanguine Blade", target)

                    end

                elseif myrkr and myrkr.enabled and bp.__player.mpp() <= myrkr.mpp and bp.core.ready("Myrkr") and bp.actions.inActionRange("Myrkr", target) then

                    if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                        bp.queue.add("Myrkr", bp.__player.get())

                    end

                elseif moonlight and moonlight.enabled and bp.__player.mpp() <= moonlight.mpp and (bp.core.ready("Moonlight") or bp.core.ready("Starlight")) and (bp.actions.inActionRange("Moonlight", target) or bp.actions.inActionRange("Starlight", target)) then

                    if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then

                        if bp.core.ready("Moonlight") then
                            bp.queue.add("Moonlight", bp.__player.get())

                        elseif bp.core.ready("Starlight") then
                            bp.queue.add("Starlight", bp.__player.get())

                        end

                    end

                else
                    local index, count, id, status, bag, resource = bp.__aftermath.getWeapon()
                    local aml = (bp.core.get('aftermath') and bp.core.get('aftermath').enabled) and (bp.core.get('aftermath').level * 1000) or false
                    
                    if index and resource and aml and bp.__player.tp() >= aml and not bp.__aftermath.active() and bp.__aftermath.weaponskill(resource.en) and bp.actions.inActionRange(bp.__aftermath.weaponskill(resource.en), target) then
                        bp.queue.add(bp.__aftermath.weaponskill(resource.en), target)

                    elseif (aml and bp.__aftermath.active()) or not aml or not bp.__aftermath.weaponskill(resource.en) or bp.__buffs.active({168,189}) then

                        if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp then
                            bp.queue.add(bp.core.get('melee-weaponskill').name, target)

                        end

                    end
                    
                end

            -- Handle ranged distance weapon skills.
            elseif target and bp.core.canAct() and bp.core.get('range-weaponskill') and bp.core.get('range-weaponskill').enabled then
                local sanguine  = bp.core.get('sanguine-blade')
                local myrkr     = bp.core.get('myrkr')
                local moonlight = bp.core.get('moonlight')

                if myrkr and myrkr.enabled and bp.__player.mpp() <= myrkr.mpp and bp.core.ready("Myrkr") and bp.actions.inActionRange("Myrkr", target) then
                    
                    if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                        bp.queue.add("Myrkr", bp.__player.get())

                    end

                elseif moonlight and moonlight.enabled and bp.__player.mpp() <= moonlight.mpp and (bp.core.ready("Moonlight") or bp.core.ready("Starlight")) and (bp.actions.inActionRange("Moonlight", target) or bp.actions.inActionRange("Starlight", target)) then

                    if bp.__player.tp() >= bp.core.get('melee-weaponskill').tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then

                        if bp.core.ready("Moonlight") then
                            bp.queue.add("Moonlight", bp.__player.get())

                        elseif bp.core.ready("Starlight") then
                            bp.queue.add("Starlight", bp.__player.get())

                        end

                    end

                else
                    local index, count, id, status, bag, resource = bp.__aftermath.getWeapon()
                    local aml = (bp.core.get('aftermath') and bp.core.get('aftermath').enabled) and (bp.core.get('aftermath').level * 1000) or false
                    
                    if index and resource and aml and bp.__player.tp() >= aml and not bp.__aftermath.active() and bp.__aftermath.weaponskill(resource.en) and bp.actions.inActionRange(resource.en, target) then
                        bp.queue.add(bp.__aftermath.weaponskill(resource.en), target)

                    elseif (aml and bp.__aftermath.active()) or not aml or not bp.__aftermath.weaponskill(resource.en) or bp.__buffs.active({168,189}) then

                        if bp.__player.tp() >= bp.core.get('range-weaponskill').tp then
                            bp.queue.add(bp.core.get('range-weaponskill').name, target)

                        end

                    end
                    
                end

            end
            
        end

    end

    local function handle_ranged()
        local target    = bp.targets.get('player')
        local ranged    = bp.__equipment.get(2)
        local ammo      = bp.__equipment.get(3)

        if bp.core.get('ranged-attacks') and ranged and ammo and ranged.index > 0 and target and bp.__queue.length() then
            local index, count, id, status, bag, resource = bp.__inventory.getByIndex(ranged.bag, ranged.index)
            
            if resource and bp.res.items[id] and T{25,26}:contains(resource.skill) and not bp.__queue.inQueue({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}) then
                bp.queue.add({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}, target, 1)

            end

        end

    end

    local function automate()

        -- Handle Trust before performing any kind of actions.
        --if bp.trust.isEnabled() and bp.trust.canSummon() then
            --bp.trust.summon()
            --return

        --end

        -- Handle skillup logic if enabled.
        if bp.skillup.enabled() then
            automation:skillup()
            return

        end

        -- Handle item usage.
        --automation:medicine()

        -- Handle curing if available.
        --automation:curing()

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

    local function handle_commands(command, value)
        if (not command or not value or not switches) then
            return        
        end

        if switches then
            local split = command:split(':')

            if #split > 1 then
                local setting, key, option = o.get(command)

                if switches[key] and option then
                    switches[key](bp, setting, option, value)
                    settings:save()

                elseif setting[option] ~= nil then

                    if S{'!','#'}:contains(value) then
                        setting[option] = (value == '!')
                        settings:save()

                    end

                end

            else
                o.save(command, value)
                settings:save()

            end

        end

    end

    -- Public Methods.
    o.get = function(s)
        local keys = s:split(':')

        if #keys > 1 then
            local setting = nil
            local key = nil
            local option = nil

            for i=#keys, 1, -1 do

                if type(settings[keys[i]]) == 'table' then
                    setting = settings[keys[i]]
                    key = keys[i]
                    break

                end
                option = keys[i]

            end
            return setting, key, option
            
        elseif settings[s] ~= nil then
            return settings[s], s

        end
        return nil

    end

    o.save = function (s, value)
        local keys = s:split(':')

        print('saving:', s)

        if #keys > 1 then
            local setting = nil

            for i=1, #keys do

                if type(settings[keys[i]]) == 'table' then
                    print('table', keys[i])
                    setting = settings[keys[i]]

                else
                    print('else', keys[i])
                    if S{'!','#'}:contains(value) then
                        setting[keys[i]] = (value =='!')

                    else
                        setting[keys[i]] = value

                    end
                    return setting[keys[i]]

                end

            end
            return setting
            
        elseif settings[s] ~= nil then

            if S{'!','#'}:contains(value) then
                settings[s] = (value == '!')

            else
                settings[s] = value

            end
            return settings[s]

        end
        return nil

    end

    o.getBase = function()
        return bp.files.new('resources/base.lua'):exists() and dofile(string.format('%sresources/base.lua', bp.path)) or {}

    end

    o.getAutomation = function(settings, mjob, sjob)
        if not settings then return end
        local mjob = mjob or bp.__player.mjob(true)
        local sjob = sjob or bp.__player.sjob(true)
        local file = bp.files.new(string.format('core/jobs/%s.lua', mjob))

        if file:exists() then
            automation = dofile(("%score/jobs/%s.lua"):format(bp.path, mjob))(bp, settings)
            function automation:weaponskill() handle_weaponskills() end
            function automation:ranged() handle_ranged() end
            function automation:statusfix() bp.statusfix.fix() end
            function automation:skillup() bp.skillup.handle() end
            function automation:medicine() end
            function automation:curing() bp.cures.handleCuring() end
            function automation:buffing() bp.buffs.handleBuffing() end

            if bp.__player.hasSubjob() then
                local sub = dofile(("%score/jobs/%s.lua"):format(bp.path, sjob))(bp, settings)

                if automation and not automation.subjob then
                    automation.subjob = sub

                end

            else

                -- If subjob is not currently active, then just return an empty placeholder.
                local function load(bp, settings)
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
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1) or nil
    
        if command and S{'core'}:contains(command) then
            local command = commands[1] and table.remove(commands, 1) or false
            local value = commands[1] and table.remove(commands, 1) or false

            if command then
                handle_commands(command, value)

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper