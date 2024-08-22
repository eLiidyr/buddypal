local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings    = bp.__settings.new('statusfix')
    local spells      = T{14,15,16,17,18,19,20,143}
    local dnc         = T{["Erase"]=T{3,4,5,6,7,8,134,135,186,13,21,146,147,148,149,167,174,175,217,223,404,557,558,559,560,561,562,563,564,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567},["Asleep"]=T{2,19}}
    local statusmap   = T{

        ["Poisona"]     = T{3},
        ["Blindna"]     = T{5},
        ["Silena"]      = T{6},
        ["Stona"]       = T{7},
        ["Viruna"]      = T{8,31},
        ["Paralyna"]    = T{4,566},
        ["Charmed"]     = T{14,17},
        ["Cursna"]      = T{9,15,20},
        ["Asleep"]      = T{2,19,193},
        ["Erase"]       = T{11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567,13,21,146,147,148,149,167,174,175,194,217,223,404,557,558,559,560,561,562,563,564,134,135,186,144,145},

    }

    do -- Setup default setting values.
        settings.status_removal_enabled = settings:default('status_removal_enabled',    false)  -- Status removals is enabled.
        settings.removable              = settings:default('removable',                 {})     -- Save which status effects you want the player to remove.

    end

    -- Public Variables.
    o.removable = T(settings.removable):copy()

    -- Private Methods.
    local function onload()
        settings:save()
        bp.socket.sendSettings({['statusfix']=settings:get()})

    end

    local function handle_incoming(id, original)
        if (not S{0x028}:contains(id) or not settings.status_removal_enabled) then return false end
        local parsed    = bp.packets.parse('incoming', original)
        local actor     = bp.__target.get(parsed['Actor'])
        local target    = bp.__target.get(parsed['Target 1 ID'])
        local param     = parsed['Param']

        if actor and target and bp.__player.get() and bp.__player.id() == actor.id and bp.res.spells[param] and parsed['Category'] == 4 and spells:contains(param) then

            if bp.queue.length() > 0 then
                local targets = T{}
            
                for i=1, parsed['Target Count'] do
                    table.insert(targets, parsed[string.format('Target %s ID', i)])

                end

                if targets:length() > 0 then

                    for q in bp.queue.it() do
                        local action = q.action
                        local target = q.target

                        if action and target and action.id == param and T{33,34}:contains(action.skill) and o.isRemoval(action.id) then
                            bp.queue.remove(action, target)

                        end

                    end

                end

            end

        end

    end

    local function fix(category, target)
        local target = bp.__target.get(target)
        local actions = {}

        actions["Poisona"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Poisona", target) then
                bp.queue.add("Poisona", target)

            end
    
        end
    
        actions["Blindna"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Blindna", target) then
                bp.queue.add("Blindna", target)

            end
    
        end
    
        actions["Silena"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Silena", target) then
                bp.queue.add("Silena", target)

            end
    
        end
    
        actions["Stona"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Stona", target) then
                bp.queue.add("Stona", target)

            end
    
        end
    
        actions["Viruna"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Viruna", target) then
                bp.queue.add("Viruna", target)

            end
    
        end
    
        actions["Paralyna"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Paralyna", target) then
                bp.queue.add("Paralyna", target)

            end
    
        end
    
        actions["Charmed"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Repose", target) and bp.__party.isMember(target.name, true) then
                bp.queue.add("Repose", target)

            end
    
        end
    
        actions["Cursna"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Cursna", target) then
                bp.queue.add("Cursna", target)

            end
    
        end
    
        actions["Asleep"] = function()
    
            if target and bp.actions.canCast() then
    
                if bp.__party.isMember(target.name) and not bp.queue.inQueue("Curaga", target) then
                    bp.queue.add("Curaga", target)
                    
                elseif bp.__party.isMember(target.name, true) and not bp.queue.inQueue("Cure", target) then
                    bp.queue.add("Cure", target)
    
                end
    
            end
    
        end
    
        actions["Erase"] = function()
    
            if target and bp.actions.canCast() and not bp.queue.inQueue("Erase", target) and bp.__party.isMember(target.name) then
                bp.queue.add("Erase", target)

            end
    
        end

        if actions[category] then
            actions[category]()

        end

    end

    local function add_fix(commands)
        local buff = tonumber(table.concat(commands, " "))

        if buff and not T(settings.removable):contains(buff) then
            settings.removable:insert(buff)

        end

    end

    local function remove_fix(commands)
        local buff = tonumber(table.concat(commands, " "))

        if buff and T(settings.removable):contains(buff) then
            T(settings.removable):delete(buff)

        end

    end

    -- Public Methods.
    o.isRemoval = function(id)
        return spells:contains(id)
    
    end

    o.fix = function()

        if settings.status_removal_enabled and bp.__buffs.removal:length() > 0 then
            local mjob = bp.__player.mjob()
            local sjob = bp.__player.sjob()

            if (mjob == 'WHM' or sjob == 'WHM' or (mjob == 'SCH' and bp.__buffs.active(401)) or (sjob == 'SCH' and bp.__buffs.active(401))) then
                    
                for player in bp.__buffs.removal:it() do

                    for list, category in statusmap:it() do
                        
                        for status in list:it() do

                            if T(player.list):contains(status) and not bp.__buffs.hasAura(status) then
                                --self.__class:doEvent('fix-status', category, player.id) UPDATE

                            end

                        end

                    end
    
                end

            elseif (mjob == 'DNC' or sjob == 'DNC') then
                    
                for player in bp.__buffs.removal:it() do

                    for status in T(player.list):it() do
                        
                        if T{3,4,5,6,7,8,134,135,186,13,21,146,147,148,149,167,174,175,217,223,404,557,558,559,560,561,562,563,564,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567}:contains(status) and not bp.__buffs.hasAura(status) then
                            local target = bp.__target.get(player.id)

                            if target and bp.__party.isMember(target.name, false) and bp.actions.isReady("Healing Waltz") and not bp.queue.inQueue("Healing Waltz", target) then
                                bp.queue.add("Healing Waltz", target)

                            end

                        elseif T{2,19}:contains(status) then
                            local target = bp.__target.get(player.id)

                            if target and bp.__party.isMember(target.name, false) and bp.actions.isReady("Divine Waltz") and not bp.queue.inQueue("Divine Waltz", target) then
                                bp.queue.add("Divine Waltz", target)

                            end

                        end

                    end
    
                end
                
            end

        end

    end

    -- Private Events.
    o.events('incoming', handle_incoming)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'statusfix' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'status_removal_enabled' then
                    settings.status_removal_enabled = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!') or (settings.status_removal_enabled ~= true)

                elseif command == '+status' and #commands > 0 then
                    add_fix(commands)

                elseif command == '-status' and #commands > 0 then
                    remove_fix(commands)

                end
                settings:save()

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper