local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new('queue')
    local display   = bp.texts.new({pos={x=200, y=80}, bg={alpha=175, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=8, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=0, alpha=0, red=0, green=0, blue=0}}, padding=2})
    local queue     = T{}

    do -- Setup default setting values.
        settings.action_bypass   = T(settings:default('action_bypass',    {}))                        -- Actions that can be bypassed while moving
        settings.display         = settings:default('display',            {x=1, y=1, locked=true})    -- Display settings.

    end

    -- Public Variables.

    -- Private Methods.
    local function set_position(commands)
        local num = tonumber
        local x = (commands[1] and num(commands[1])) and num(commands[1]) or settings.display.x
        local y = (commands[2] and num(commands[2])) and num(commands[2]) or settings.display.y

        if x and y then
            display:pos(x, y)

        end

    end

    local function set_locked(commands)
        settings.display.locked = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!') or (settings.display.locked ~= true)
        display:draggable(settings.display.locked)

    end

    local function update_display()

        if queue:length() > 0 then
            local colors = {english='0,153,204', attempts='255,255,255', name='102,225,051', cost='50,180,120'}
            local data = {}

            for act, n in queue:it() do
                local attempts  = act.attempts
                local english   = #act.action.en > 15 and string.format("%s...", act.action.en:sub(1,15)) or act.action.en
                local name      = #act.target.name > 15 and string.format("%s...", act.target.name:sub(1,15)) or act.target.name
                local priority  = act.priority or bp.priorities.get(act.action.en)
                local cost      = 0

                if S{'/magic','/ninjutsu','/song'}:contains(act.action.prefix) then
                    cost = act.action.mp_cost

                elseif S{'/jobability','/pet'}:contains(act.action.prefix) then
                    cost = act.action.tp_cost >= act.action.mp_cost and act.action.tp_cost or act.action.mp_cost

                end

                if n < 20 then

                    if n == 1 then
                        table.insert(data, string.format("\n%s[ ACTION QUEUE ]%s\n", (''):lpad(' ', 25), (''):rpad(' ', 25)))
                        table.insert(data, string.format("%s<\\cs(%s)%02d::%03d\\cr> [ \\cs(%s)%03d\\cr ] \\cs(%s)%s \\cr%s►%s\\cs(%s)%s\\cr",
                            (''):lpad(' ', 5),
                            colors.attempts,
                            attempts,
                            priority,
                            colors.cost,
                            cost,
                            colors.english,
                            english,
                            (''):rpad('-', 25-english:len()),
                            (''):rpad(' ', 2),
                            colors.name,
                            name
                        ))

                    else
                        table.insert(data, string.format("%s<\\cs(%s)%02d::%03d\\cr> [ \\cs(%s)%03d\\cr ] \\cs(%s)%s \\cr%s %s\\cs(%s)%s\\cr",
                            (''):lpad(' ', 5),
                            colors.attempts,
                            attempts,
                            priority,
                            colors.cost,
                            cost,
                            colors.english,
                            english,
                            (''):rpad(' ', 25-english:len()),
                            (''):rpad(' ', 2),
                            colors.name,
                            name

                        ))

                    end

                end

            end
            display:text(table.concat(data, "\n"))

            if not display:visible() then
                display:show()

            end

        else
            display:hide()

        end

    end

    local function attempt(prefix, action, target, callback)
        if queue:empty() then return end
        local timer = o.timer('actions-protect')

        if prefix and action and target and timer:ready() then
            local top = queue:first()
            
            timer:update(0.75)
            if action.en == 'Ranged' then
                bp.cmd(('input %s'):format(prefix))
                top.attempts = (o.attempts() + 1)

            elseif prefix and prefix == '/item' then
                bp.cmd(('input %s "%s" %s'):format("/item", action.en, target.id))
                top.attempts = (o.attempts() + 1)

            else
                bp.cmd(('input %s "%s" %s'):format(prefix, action.en, target.id))
                top.attempts = (o.attempts() + 1)

            end

        end

    end

    local function handle()
        if (not bp.enabled or queue:empty() or not o.timer('actions-protect'):ready()) then return end

        do -- Sort the queue before handling an action.
            o.sort()

        end
        local target    = bp.__target.get(bp.queue.target())
        local action    = o.action()
        local priority  = o.priority()
        local attempts  = o.attempts()
        local player    = bp.__player.get()

        if player and action and target and priority and attempts and (not bp.actions.isMoving() or S{'Provoke','Flash','Stun','Chi Blast','Animated Flourish','Full Circle','Deploy','Fight','Sic','Assault','Avatar\'s Favor'}:contains(action.en)) then
            local range     = bp.actions.getRange(action)
            local distance  = bp.__distance.get(target)

            if S{'/jobability','/pet'}:contains(action.prefix) then
                local pet = bp.__target.get('pet') or false

                if action.prefix == '/jobability' then

                    if action.en == 'Pianissimo' then
                        return attempt(action.prefix, action, player)

                    elseif action.en == 'Double-Up' then

                        if bp.__rolls.isMidroll() and bp.__rolls.active(true) > 0 then
                            return attempt(action.prefix, action, target)

                        else
                            queue:remove(1)
                            o.updateDisplay()

                        end

                    elseif action.type == 'Scholar' then

                        if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and bp.actions.isReady(action.en) and not bp.__target.isDead(target) and bp.__stratagems.current >= action.mp_cost and bp.actions.canAct() then
                            return attempt(action.prefix, action, target)

                        else
                            queue:remove(1)
                            o.updateDisplay()

                        end

                    elseif S{'Full Circle','Ecliptic Attrition','Lasting Emanation','Radial Arcana','Mending Halation'}:contains(action.en) then
                        
                        if pet and not T{2,3}:contains(pet.status) then

                            if action.en == 'Ecliptic Attrition' then
                                
                                if not bp.__buffs.active(513) then
                                    return attempt(action.prefix, action, target)

                                else
                                    queue:remove(1)
                                    o.updateDisplay()

                                end

                            else
                                return attempt(action.prefix, action, target)

                            end

                        else
                            queue:remove(1)
                            o.updateDisplay()

                        end

                    else

                        if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and bp.actions.isReady(action.en) and not bp.__target.isDead(target) and bp.actions.canAct() then
                            return attempt(action.prefix, action, target)

                        else
                            queue:remove(1)
                            o.updateDisplay()

                        end


                    end

                elseif action.prefix == '/pet' then

                    if pet then

                        if action.type == 'Monster' then

                        elseif S{"Assault","Deploy","Fight"}:contains(action.en) then

                            if attempts < 15 and (distance - target.model_size) < range and bp.actions.isReady(action.en) and bp.__target.isEnemy(target) and bp.__target.canEngage(target) and not bp.__target.isDead(target) then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        elseif action.en == "Avatar's Favor" then

                            if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and bp.actions.isReady(action.en) then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        elseif S{'BloodPactRage','BloodPactWard'}:contains(action.type) then

                            if attempts < 15 and (bp.__distance.pet(target) - target.model_size) < range and bp.actions.isReady(action.en) and bp.__target.castable(target, action) and bp.__target.canEngage(target) and not bp.__target.isDead(target) then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        else
                            
                            if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and not bp.__target.isDead(target) then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        end

                    else
                        queue:remove(1)
                        o.updateDisplay()

                    end

                end

            elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                if action.prefix == '/magic' then

                    if attempts < 15 and (distance - target.model_size) < range and (bp.__target.castable(target, action) or action.skill == 44) and not bp.__target.isDead(target) and bp.__player.mp() >= action.mp_cost and bp.actions.canCast() then

                        if bp.statusfix.isRemoval(action.id) then
                            return attempt(action.prefix, action, target)

                        elseif T{44,34,37,39}:contains(action.skill) and action.status then
                            
                            if action.en:startswith("Geo-") then

                                if (not pet or bp.__bubbles.canRecast(true) or bp.skillup.enabled()) then
                                    return attempt(action.prefix, action, target)
                                    
                                else
                                    queue:remove(1)
                                    o.updateDisplay()

                                end

                            elseif action.en:startswith("Indi-") then

                                if player.id ~= target.id then

                                    if bp.__buffs.active(584) and not bp.core.hasBuff(target.id, 612) then
                                        return attempt(action.prefix, action, target)

                                    else
                                        queue:remove(1)
                                        o.updateDisplay()

                                    end

                                elseif player.id == target.id then

                                    if (not bp.__buffs.active(612) or bp.__bubbles.canRecast() or bp.skillup.enabled()) then
                                        return attempt(action.prefix, action, target)

                                    else
                                        queue:remove(1)
                                        o.updateDisplay()

                                    end

                                else
                                    queue:remove(1)
                                    o.updateDisplay()

                                end

                            elseif not bp.__buffs.hasBuff(target.id, action.status) or bp.skillup.enabled() then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        else

                            if bp.actions.isReady(action) then
                                return attempt(action.prefix, action, target)

                            else
                                queue:remove(1)
                                o.updateDisplay()

                            end

                        end

                    else
                        queue:remove(1)
                        o.updateDisplay()

                    end

                elseif action.prefix == '/ninjutsu' then

                    if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and not bp.__target.isDead(target) and bp.actions.canCast() then
                        return attempt(action.prefix, action, target)

                    else
                        queue:remove(1)
                        o.updateDisplay()

                    end

                elseif action.prefix == '/song' then

                    if attempts < 15 and (bp.__target.castable(target, action) or bp.__buffs.active(409)) and not bp.__target.isDead(target) then
                        return attempt(action.prefix, action, target)

                    else
                        queue:remove(1)
                        o.updateDisplay()

                    end

                end

            elseif S{'/weaponskill'}:contains(action.prefix) then
                local t = bp.__target.get('t')
                
                if bp.actions.isReady(action.en) and bp.actions.inActionRange(action, target) and bp.__target.canEngage(target) and t and target.id == t.id then
                    return attempt(action.prefix, action, target)

                else
                    queue:remove(1)
                    o.updateDisplay()

                end

            elseif S{'/ra'}:contains(action.prefix) then

                if bp.actions.canAct() and (distance - target.model_size) < range and not bp.__target.isDead(target) then
                    return attempt("/ra", action, target)

                else
                    queue:remove(1)
                    o.updateDisplay()

                end

            elseif action.flags and action.flags:contains('Usable') then

                if bp.actions.canItem() and (distance - target.model_size) < 10 and bp.__target.castable(target, action) and not bp.__target.isDead(target) then
                    return attempt("/item", action, target)

                else
                    queue:remove(1)
                    o.updateDisplay()

                end

            end

        end

    end

    local function push(action, target, priority)
        
        if action and target and priority then

            if queue:empty() then
                queue:append({action=action, target=target, priority=priority, attempts=0})

            else
                queue:append({action=action, target=target, priority=priority, attempts=0})

            end
            o.updateDisplay()

        end

    end

    local function trigger(action)
        if queue:empty() then return end

        if S{'/jobability','/pet'}:contains(action.prefix) then
            o.timer('actions-protect'):update(1.25)
            print('make: 1.25')

        elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
            o.timer('actions-protect'):update(2.75)
            print('make: 2.75')

        elseif S{'/weaponskill'}:contains(action.prefix) then
            o.timer('actions-protect'):update(1.25)
            print('make: 1.25')

        elseif S{'/ra'}:contains(action.prefix) then
            o.timer('actions-protect'):update(2.00)
            print('make: 2.00')

        elseif action.flags and action.flags:contains('Usable') then
            o.timer('actions-protect'):update(action.cast_delay or 2.50)
            print('make: x.xx')

        else
            o.timer('actions-protect'):update(2.00)
            print('make: 2.00')

        end
    
    end

    local function onload()
        o.timer('actions-protect', 0.50)
        handle:loop(0.50)
        settings:save()

        -- Update the players client.
        bp.socket.sendSettings({['queue']=settings:get()})

    end

    local function status_change(new, old)

        if S{2,3,4,5,33,38,39,40,41,42,43,44,47,48,51,52,53,54,55,56,57,58,59,60,61,85}:contains(new) then
            queue:clear()
            o.updateDisplay()

        elseif new == 0 and old == 1 then
            queue:clear()
            o.updateDisplay()

        end

    end

    local function handle_incoming(id, original)
        local timer = o.timer('actions-protect')

        if id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = bp.__target.get(parsed['Actor'])
            local target    = bp.__target.get(parsed['Target 1 ID'])
            
            if bp.__player.get() and parsed and actor and target and actor.id == bp.__player.id() then
                local count, category, param = parsed['Target Count'], parsed['Category'], parsed['Param']
    
                -- Finish Ranged Attack.
                if category == 2 then
                    o.remove({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_time=-999}, target, 1)
    
                -- Finish Weaponskill.
                elseif category == 3 and bp.res.weapon_skills[param] then
                    o.remove(bp.res.weapon_skills[param], target, 1)
    
                -- Finish Spell Casting.
                elseif category == 4 and bp.res.spells[param] then
                    o.remove(bp.res.spells[param], target, 1)
    
                -- Finish using an Item.
                elseif category == 5 and bp.res.items[param] then
                    o.remove(bp.res.items[param], target, 1)
    
                -- Use Job Ability.
                elseif category == 6 and bp.res.job_abilities[param] then
                    o.remove(bp.res.job_abilities[param], target, 1)
    
                -- Use Weaponskill.
                elseif category == 7 then

                    if param == 24931 and bp.res.weapon_skills[parsed['Target 1 Action 1 Param']] then
                        timer:update(1)

                    elseif param == 28787 and bp.res.weapon_skills[parsed['Target 1 Action 1 Param']] then
                        o.remove(bp.res.job_abilities[param], target, 1)

                    end

                -- Begin Spell Casting.
                elseif category == 8 then

                    if param == 24931 and bp.res.spells[parsed['Target 1 Action 1 Param']] then
                        timer:update(bp.res.spells[parsed['Target 1 Action 1 Param']].cast_time)

                    elseif param == 28787 then
                        timer:update(1)

                    end
    
                -- Begin Item Usage.
                elseif category == 9 then
    
                    if param == 24931 and bp.res.items[parsed['Target 1 Action 1 Param']] then
                        timer:update(bp.res.items[parsed['Target 1 Action 1 Param']].cast_time or 2)

                    elseif param == 28787 then
                        timer:update(1)

                    end
    
                -- NPC TP Move.
                elseif category == 11 then
    
                -- Begin Ranged Attack.
                elseif category == 12 then
                    timer:update(2)
    
                -- Finish Pet Ability / Weaponskill.
                elseif category == 13 then
                    o.remove(bp.res.job_abilities[param], target, 1)
    
                -- DNC Abilities
                elseif category == 14 then
                    o.remove(bp.res.job_abilities[param], target, 1)
    
                -- RUN Abilities
                elseif category == 15 then
                    o.remove(bp.res.job_abilities[param], target, 1)
    
                end
    
            end
    
        end

    end

    -- Public Methods.
    o.updateDisplay = function()
        update_display()

    end

    o.ready = function()

        if bp.__player.get() and S{0,1}:contains(bp.__player.status()) then
            return true
        
        end
        return false

    end

    o.it = function()
        local key
        return function()
            local value
            key, value = next(queue, key)
            return value, key

        end

    end

    o.sort = function()
        return queue:sort(function(a, b) return (a and b and a.priority > b.priority) end)

    end

    o.action = function()
        return queue:length() > 0 and queue[1].action or nil

    end

    o.target = function()
        return queue:length() > 0 and queue[1].target or nil

    end

    o.attempts = function()
        return queue:length() > 0 and queue[1].attempts or nil

    end

    o.priority = function()
        return queue:length() > 0 and queue[1].priority or nil

    end

    o.length = function()
        return queue:length()

    end

    o.empty = function()
        return queue:empty()

    end

    o.clear = function()
        queue:clear()
        o.updateDisplay()

    end

    o.removeFirst = function()
        return queue:remove(1)

    end

    o.force = function(action, target, priority)

        if bp.__player.get() and action and target then
            local action = type(action) == 'table' and action or bp.__res.get(action)
            local target = bp.__target.get(target)

            if target and action and T{0,1}:contains(bp.__player.status()) then
                local priority = priority or bp.priorities.get(action.en)

                if priority and bp.actions.isReady(action.en) and not bp.queue.inQueue(action, target) and (not action.mp_cost or (action.mp_cost <= bp.__player.mp())) then
                    push(action, target, priority)
                    
                end

            end

        end

    end

    o.add = function(action, target, priority)
        
        if bp.__player.get() and action and target then
            local action = type(action) == 'table' and action or bp.__res.get(action)
            local target = bp.__target.get(target)
            
            if target and action and T{0,1}:contains(bp.__player.status()) and not bp.__buffs.isSilent() then
                local range     = bp.actions.getRange(action)
                local distance  = bp.__distance.get(target)
                local priority  = priority or bp.priorities.get(action.en)

                -- JOB ABILITIES.
                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = bp.__player.pet()

                    if action.prefix == '/jobability' and bp.__target.castable(target, action) then

                        if action.type == 'JobAbility' and (distance - target.model_size) < range then

                            if action.en == 'Pianissimo' then
                                push(action, target, priority)

                            elseif bp.actions.isReady(action.en) and not bp.queue.inQueue(action, target) and bp.actions.canAct() then
                                push(action, target, priority)

                            end

                        elseif bp.actions.canAct() and not bp.queue.inQueue(action, target) then

                            if action.type == 'CorsairShot' then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    local index, count = bp.__inventory.findByName("Trump Card", 0)
                                
                                    if count > 0 then
                                        push(action, target, priority)

                                    end

                                end

                            elseif action.type == 'CorsairRoll' then

                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif action.type == 'Scholar' then
                                
                                -- UPDATE??
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range and bp.__stratagems.current >= action.mp_cost then
                                    push(action, target, priority)

                                end

                            elseif action.type == 'Rune' then

                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif action.type == 'Ward' then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif action.type == 'Effusion' then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif action.type == 'Jig' then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif S{'Samba','Waltz'}:contains(action.type) and action.tp_cost <= bp.__player.tp() then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            elseif S{'Flourish1','Flourish2','Flourish3'}:contains(action.type) then
                                
                                if bp.actions.isReady(action.en) and (distance - target.model_size) < range then
                                    push(action, target, priority)

                                end

                            end

                        end

                    elseif action.prefix == '/pet' then
                        
                        if action.type == 'Monster' then
                            print('Monster actions not implemented!')

                        elseif S{'BloodPactRage','BloodPactWard'}:contains(action.type) then

                            if bp.actions.isReady(action.en) and (bp.__distance.pet(target) - target.model_size) < range then
                                push(action, target, priority)

                            end

                        elseif bp.actions.isReady(action.en) and not bp.queue.inQueue(action, target) then
                            push(action, target, priority)

                        end

                    end

                -- SPELLS.
                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
                    
                    if action.prefix == '/magic' and (action.mp_cost and (action.mp_cost <= bp.__player.mp() or bp.__buffs.active({47,229}))) and bp.actions.canCast() then

                        if bp.actions.isReady(action.en) and (distance - target.model_size) < range and not bp.queue.inQueue(action, target) then

                            if action.en:startswith("Geo-") then
                                
                                if not pet or bp.__bubbles.canRecast(true) then
                                    push(action, target, priority)

                                end

                            elseif action.en:startswith("Indi-") then

                                if (bp.__player.id() == target.id and not bp.__buffs.active(612) or bp.__bubbles.canRecast()) or (bp.__player.id() ~= target.id and bp.__buffs.active(584) and not bp.core.hasBuff(target.id, 612) or bp.__bubbles.canRecast()) then
                                    push(action, target, priority)

                                end

                            elseif bp.__target.castable(target, action) then

                                if action.status then
                                    
                                    if bp.__party.isMember(target.name, true) and not bp.__buffs.hasBuff(target.id, action.status) then
                                        push(action, target, priority)

                                    elseif not bp.__party.isMember(target.name, true) and not bp.debuffs.hasDebuff(action.status, target) then

                                        if bp.__player.mjob() == 'RDM' and bp.core.get('saboteur') and bp.core.ready("Saboteur", 454) and action.skill == 35 then
                                            push(bp.__res.get("Saboteur"), target, bp.priorities.get(bp.__res.get("Saboteur").en))

                                        end
                                        push(action, target, priority)

                                    end

                                else
                                    push(action, target, priority)

                                end

                            end

                        end

                    elseif action.prefix == '/ninjutsu' then
                        
                        if bp.actions.isReady(action.en) and (distance - target.model_size) < range and not bp.queue.inQueue(action, target) then
                            push(action, target, priority)

                        end

                    elseif action.prefix == '/song' then
                        push(action, target, priority)

                    elseif action.prefix == '/trust' then
                        
                        if bp.actions.isReady(action.en) and (distance - target.model_size) < range and not bp.queue.inQueue(action, target) then
                            push(action, target, priority)

                        end

                    end

                -- WEAPON SKILLS.
                elseif S{'/weaponskill'}:contains(action.prefix) then

                    if bp.__player.tp() >= 1000 and bp.actions.isReady(action.en) and not bp.queue.inQueue(action, target, true) then

                        if action.range < 5 and bp.actions.inActionRange(action, target) then
                            push(action, target, priority)

                        elseif (distance - target.model_size) < range then
                            push(action, target, priority)

                        end

                    end

                -- RANGED ATTACKS.
                elseif S{'/ra'}:contains(action.prefix) then
                    push({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}, target, 1)

                -- USEABLE ITEMS.
                elseif action.flags and action.flags:contains('Usable') and bp.actions.canItem() and not bp.queue.inQueue(action, target) then
                    push(action, target, priority)

                end

            end

        end

    end

    o.remove = function(action, target, index)
        local action = type(action) == 'table' and action or bp.__res.get(action)

        print('removing...')
        if index and index == 1 then

            if queue[1] then
                trigger(queue[1].action)
                queue:remove(1)

            end

        else
        
            if action and not index then
            
                if not target then

                    for act, index in queue:it() do

                        if action.en == act.action.en then
                            trigger(action)
                            queue:remove(index)
                            break

                        end

                    end

                elseif target then

                    for act, index in queue:it() do
                        
                        if action.en == act.action.en and target.id == act.target.id then
                            trigger(action)
                            queue:remove(index)
                            break

                        end

                    end

                end

            elseif action and index and queue[index] then
                trigger(queue[index].action)
                queue:remove(index)

            end

        end
        o.updateDisplay()

    end

    o.removeType = function(action)
        local action = type(action) == 'table' and action or bp.__res.get(action)

        if action and (action.prefix == '/weaponskill' or action.type) then

            for act, index in queue:it() do

                if action.prefix == '/weaponskill' and act.action.prefix and act.action.prefix == action.prefix then
                    queue:remove(index)

                elseif action.type and act.action.type and act.action.type == action.type then
                    queue:remove(index)

                end

            end
            o.updateDisplay()

        end

    end

    o.inQueue = function(action, target, flag)
        local action = type(action) == 'table' and action or bp.__res.get(action)

        if flag then

            if action and queue:length() > 0 and (action.type or action.prefix == '/weaponskill') then

                for act in queue:it() do
    
                    if act.action and action.prefix and act.action.prefix and action.prefix == '/weaponskill' and act.action.prefix == '/weaponskill' then
                        return true
    
                    else
    
                        if act.action and act.action.type == action.type then
                            return true

                        end
    
                    end
    
                end
    
            end
            return false

        else

            if action and type(action) == 'table' then

                if queue:length() > 0 then
                
                    if target then

                        for act in queue:it() do

                            if act.action and act.target and act.action.id == action.id and act.action.en == action.en and act.target.id == target.id then
                                return true

                            end

                        end

                    elseif not target then

                        for act in queue:it() do

                            if act.action and act.target and act.action.id == action.id and act.action.en == action.en then
                                return true

                            end

                        end                        

                    end

                end
                return false

            end
            return true

        end

    end

    o.hasType = function(t)
        if not t then return true end

        for act in queue:it() do

            if act.action then

                if act.action.type and act.action.type == t then
                    return true

                elseif act.action.prefix and act.action.prefix == t then
                    return true

                end

            end

        end
        return false

    end

    o.search = function(search)
        
        for act in queue:it() do
                    
            if type(search) == 'string' then
                
                if act.action.en:startswith(search) then
                    return true

                end

            elseif type(search) == 'table' then

                for check in T(search):it() do

                    if act.action.en:startswith(check) then
                        return true

                    end

                end

            end
            
        end
        return false

    end

    -- Private Events.
    o.events('status change', status_change)
    o.events('incoming', handle_incoming)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
    
        if command and command:lower() == 'queue' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'locked' and #commands > 0 then
                    set_locked(commands)

                elseif command == 'pos' and #commands > 0 then
                    set_position(commands)

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