require('actions')
local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings      = bp.__settings.new('actions')
    local action_ranges = {1, 1.55, 1.490909, 1.44, 1.377778, 1.30, 1.15, 1.25, 1.377778, 1.45, 1.454545454545455, 1.666666666666667}
    local protection    = {[0]=T{0},[2]=T{0},[3]=T{0,1},[4]=T{1},[5]=T{0,1},[7]=T{1},[9]=T{0,1},[11]=T{2,3},[12]=T{0,2},[13]=T{2,3},[14]=T{0},[15]=T{1},[16]=T{1},[18]=T{85},[19]=T{2,3},[26]=T{0}}
    local anchored      = T{set=false, midcast=false, position={x=0, y=0, z=0}}
    local position      = T{}
    local ismoving      = false
    local lastdeath     = 0
    local lastperform   = 0
    local actions       = {

        ['interact']    = 0,    ['engage']          = 2,    ['/magic']          = 3,    ['magic']           = 3,    ['/mount'] = 26,
        ['disengage']   = 4,    ['/help']           = 5,    ['help']            = 5,    ['/weaponskill']    = 7,
        ['weaponskill'] = 7,    ['/jobability']     = 9,    ['jobability']      = 9,    ['return']          = 11,
        ['/assist']     = 12,   ['assist']          = 12,   ['accept raise']    = 13,   ['/fish']           = 14,
        ['fish']        = 14,   ['switch target']   = 15,   ['/range']          = 16,   ['range']           = 16,
        ['/dismount']   = 18,   ['dismount']        = 18,   ['zone']            = 20,   ['accept tractor']  = 19,
        ['mount']       = 26,

    }

    do -- Setup default setting values.
        settings.action_after_death_delay   = settings:default('action_after_death_delay',         10)
        settings.auto_face_target           = settings:default('auto_face_target',              false)
        settings.auto_distance_from_target  = settings:default('auto_distance_from_target',     false)
        settings.prevent_spell_interruption = settings:default('prevent_spell_interruption',    false)
        settings.prevent_player_knockback   = settings:default('prevent_player_knockback',      false)

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:save()
        settings:update()
        bp.socket.sendSettings({['actions']=settings:get()})

        -- Timer creation.
        o.timer('auto-distance-timer',  0.3)
        o.timer('auto-facing-timer',    1.0)

    end

    local function prerender()

        -- Update players position.
        ismoving = not position:equals(bp.__player.position())
        position:update(bp.__player.position())

        if settings.auto_distance_from_target and bp.__player.status() == 1 and bp.__player.get(true) and o.timer('auto-distance-timer'):ready() then
            local target = bp.__target.get('t')

            if bp.__target.inRange(target) then
                bp.run(false)

            elseif not bp.__target.inRange(target) then
                bp.actions.move(target.x, target.y, target.z)

            end                        

        end

        if settings.auto_face_target and bp.__player.status() == 1 and o.timer('auto-facing-timer'):ready() then
            local target = bp.__target.get('t')

            if target then
                bp.actions.face(bp.__target.get(target))

            end

        end

    end

    local function zonechange()
        anchored.set = false

    end

    local function statuschange(n, o)

        if n == 0 and S{2,3}:contains(o) then
            lastdeath = os.clock()

        end

    end

    local function oanchor(id, original)
        if not S{0x015,0x01a}:contains(id) then return false end
        local parsed = bp.packets.parse('outgoing', original)
        
        if id == 0x015 and o.isCastingLocked() then

            if parsed and anchored.set and anchored.position and math.abs(T(anchored.position):sum()) > 0 then

                do
                    parsed['Run Count'] = 2
                    parsed['X'] = anchored.position.x
                    parsed['Y'] = anchored.position.y
                    parsed['Z'] = anchored.position.z

                end
                return bp.packets.build(parsed)
            
            else
                anchored.position = {x=parsed['X'], y=parsed['Y'], z=parsed['Z']}
            
            end

        elseif id == 0x01a and o.isCastingLocked() then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed['Category'] == 3 and not anchored.set then
                local target = bp.__target.get(parsed['Target'])
                local spell = bp.res.spells[parsed['Param']]

                if target and spell and bp.__target.castable(target, spell) then
                    anchored.set = true

                end

            end

        end

    end

    local function ianchor(id, original)
        if not S{0x028,0x029,0x053,0x05c}:contains(id) then return false end
        local parsed = bp.packets.parse('incoming', original)
        
        if id == 0x028 and o.isCastingLocked() then

            if parsed['Category'] == 8 and parsed['Actor'] == bp.__player.id() then
                anchored.midcast = true
                
                if parsed['Param'] ~= 24931 then
                    anchored.set, anchored.midcast = false, false
                    
                end

            elseif parsed['Category'] == 4 then
                anchored.set, anchored.midcast = false, false

            end

        elseif id == 0x029 then
            local parsed = bp.packets.parse('incoming', original)

            if bp.__player.get() and parsed and parsed['Actor'] == bp.__player.id() and S{4,5,16,17,18,49,78,313,446,581}:contains(parsed['Message']) and not anchored.midcast then
                anchored.set = false

            end

        elseif id == 0x053 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and S{297,298,299}:contains(parsed['Message ID']) and not anchored.midcast then
                anchored.set = false

            end

        elseif id == 0x05c then
            anchored.set, anchored.midcast = false, false

        end

    end

    -- Public Methods.
    o.isMoving = function()
        return (ismoving == true)

    end

    o.forceUpdate = function()
        bp.packets.inject(bp.packets.new('outgoing', 0x061, {}))

    end

    o.isCastingLocked = function()
        return (settings.prevent_spell_interruption == true) and true or false

    end

    o.isKnockbackAllowed = function()
        return (settings.prevent_player_knockback == true) and true or false

    end

    o.setCastLocked = function(b)
        settings.prevent_spell_interruption = (b == true) and true or false

    end

    o.move = function(x, y, z)
        local position = bp.__player.position()
        local status = bp.__player.status()

        if position and x and not y and type(x) == 'table' and x.x and x.y and x.z and not bp.__player.isZoning() then
            local coords = {x=x.x, y=x.y, z=x.z}
            local x = ((coords.x - position.x) / bp.__distance.get(coords) / 10)
            local y = ((coords.y - position.y) / bp.__distance.get(coords) / 10)

            if coords and x and y then

                if S{5,85}:contains(bp.__player.status()) then
                    x = (x * 2)
                    y = (y * 2)
    
                end
                bp.run(x, y)

            end

        elseif position and x and y and z and not bp.__player.isZoning() then
            local coords = {x=x, y=y, z=z}
            local x = ((coords.x - position.x) / bp.__distance.get(coords) / 10)
            local y = ((coords.y - position.y) / bp.__distance.get(coords) / 10)
            
            if coords and x and y then
                
                if S{5,85}:contains(bp.__player.status()) then
                    x = (x * 2)
                    y = (y * 2)
    
                end
                bp.run(x, y)

            end

        end
        
    end

    o.perform = function(target, action, param, x, y, z)
        local target = bp.__target.get(target)

        if not lastperform or ((os.time() - lastperform) >= 1) then

            if target and action and actions[action] and not bp.__player.moghouse() and (os.clock() - lastdeath) >= settings.action_after_death_delay then

                if protection[actions[action]] and protection[actions[action]]:contains(bp.__player.status()) then
                    bp.packets.inject(bp.packets.new('outgoing', 0x01A, {
                        ['Category']        = actions[action],
                        ['Target Index']    = target.index,
                        ['Target']          = target.id,
                        ['Param']           = param or 0,
                        ['X Offset']        = x or 0,
                        ['Y Offset']        = y or 0,
                        ['Z Offset']        = z or 0,

                    }))
                    lastperform = os.time()

                end

            end

        end

    end

    o.tradeItems = function(target, ...)
        local target = bp.__target.get(target)
        local total = T{...}:length()
        local items = T{...}
        
        if target and total > 0 then
            local block = T{}
            local trade = bp.packets.new('outgoing', 0x036, {
                
                ['Target']          = target.id,
                ['Target Index']    = target.index,
                ['Number of Items'] = total,

            })

            for i=1, total do

                if items[i][1] and items[i][2] then
                    trade[string.format('Item Index %s', i)] = items[i][1]
                    trade[string.format('Item Count %s', i)] = items[i][2]

                else
                    trade[string.format('Item Index %s', i)] = 0
                    trade[string.format('Item Count %s', i)] = 0

                end

            end
            bp.packets.inject(trade)

        end
        return false

    end

    o.tradeGil = function(target, amount)
        local target = bp.__target.get(target)
        local amount = tonumber(amount)

        if target and amount and target.id and target.index and amount ~= nil and amount <= bp.__player.gil() then
            bp.packets.inject(bp.packets.new('outgoing', 0x036, {                    
                ['Target']          = target.id,
                ['Target Index']    = target.index,
                ['Number of Items'] = 1,
                ['Item Index 1']    = 0,
                ['Item Count 1']    = amount,

            }))

        end
        return false

    end

    o.returnHome = function()
        o.perform(bp.__player.get(), 'return')
    
    end

    o.useItem = function(item, target, bag)
        local target = bp.__target.get(target)

        if item and target and type(item) == 'string' then
            local bag, index, id = bp.__inventory.findItem(item)

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x037, {
                    ['Player']          = target.id,
                    ['Player Index']    = target.index,
                    ['Slot']            = index,
                    ['Bag']             = bag,

                }))

            end

        elseif item and target and bag and tonumber(item) ~= nil and tonumber(bag) ~= nil then
            local index, count, id, status, bag = bp.__inventory.getByIndex(tonumber(bag), tonumber(item))

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x037, {
                    ['Player']          = target.id,
                    ['Player Index']    = target.index,
                    ['Slot']            = index,
                    ['Bag']             = bag,

                }))

            end

        end

    end

    o.equipItem = function(item, slot, bag)

        if item and slot and type(item) == 'string' and bp.res.slots[slot] then
            local bag, index = bp.__inventory.findItem(item)

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x050, {
                    ['Item Index'] = index,
                    ['Equip Slot'] = slot,
                    ['Bag'] = bag,

                }))

            end

        elseif item and slot and bag and tonumber(item) ~= nil and bp.res.slots[slot] and bp.res.bags[bag] then
            local index, count, id, status, bag = bp.__inventory.getByIndex(tonumber(bag), tonumber(item))
            
            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x050, {
                    ['Item Index'] = index,
                    ['Equip Slot'] = slot,
                    ['Bag'] = bag,

                }))

            end

        end

    end

    o.buyItem = function(id, quantity)
        
        if id and quantity and tonumber(quantity) ~= nil then
            bp.packets.inject(bp.packets.new('outgoing', 0x083, {['Shop Slot']=id, ['Count']=quantity}))

        end

    end

    o.turn = function(x, y)

        if bp.__player.get(true) and x and y then
            bp.turn(-math.atan2(y-bp.__player.get(true).y, x-bp.__player.get(true).x))

        end

    end

    o.face = function(coords)

        if bp.__player.get(true) and coords and coords.x and coords.y then
            bp.turn(((math.atan2((coords.y - bp.__player.get(true).y), (coords.x - bp.__player.get(true).x))*180/math.pi)*-1):radian())

        end

    end

    o.aboutFace = function()
        bp.turn(((bp.__player.get(true).facing*-1)+math.pi)*-1)

    end

    o.toRadians = function(pos)

        if bp.__player.get(true) and pos and pos.x and pos.y then
            return ((math.atan2((pos.y - bp.me.y), (pos.x - bp.me.x))*180/math.pi)*-1):radian()
        
        end
        return 0

    end

    o.getFacing = function(target)
        local target = bp.__target.get(target)

        if target then
            return target.facing % math.tau

        elseif bp.__player.get(true) and not target then
            return bp.__player.get(true).facing % math.tau

        end
        
    end

    o.getRotation = function()

        if bp.__player.get(true) then
            return (((o.getFacing()*180)/math.pi)*256/360)
        end
        return 0

    end

    o.convertRotation = function(rot)
        if not rot then return end
        local rotation = rot

        if bp.__player.get(true) then
            return ((bit.band(rot, 0xff) * math.tau) * 0.00390625)
        end
        return 0

    end

    o.keyCombo = function(combo, delay, wait)
        local wait = tonumber(wait) ~= nil and tonumber(wait) or 0

        if combo and type(combo) == 'table' then
            coroutine.schedule(function()

                for i,v in ipairs(combo) do
                    coroutine.schedule(function()
                        bp.cmd(string.format('setkey %s down; wait 0.2; setkey %s up', v, v))

                    end, (i * (delay or 0.3)))

                end

            end, wait or 0)

        end

    end

    o.canCast = function()
        local statuses = {[0]=0,[1]=1}

        if statuses[bp.__player.status()] and not o.isMoving() then
            local statuses = {[0]=0,[2]=2,[6]=6,[7]=7,[10]=10,[14]=14,[17]=17,[19]=19,[22]=22,[28]=28,[29]=29,[193]=193,[252]=252,[262]=262}

            for buff in bp.__player.buffs():it() do

                if statuses[buff] then
                    return false
                end

            end

        end
        return true
    
    end

    o.canAct = function()
        local statuses = {[0]=0,[1]=1}

        if statuses[bp.__player.status()] then
            local statuses = {[0]=0,[2]=2,[7]=7,[10]=10,[14]=14,[16]=16,[17]=17,[19]=19,[22]=22,[193]=193,[252]=252,[261]=261}

            for buff in bp.__player.buffs():it() do

                if statuses[buff] then
                    return false
                end

            end

        end
        return true

    end

    o.canItem = function()
        local statuses = {[0]=0,[1]=1}

        if statuses[bp.__player.status()] and not o.isMoving() then
            local statuses = {[473]=473,[252]=252}

            for buff in bp.__player.buffs():it() do

                if statuses[buff] then
                    return false
                end

            end

        end
        return true

    end

    o.canMove = function()
        local statuses = {[0]=0,[1]=1,[10]=10,[11]=11,[85]=85}

        if statuses[bp.__player.status()] then
            local statuses = {[0]=0,[2]=2,[7]=7,[11]=11,[14]=14,[17]=17,[19]=19,[193]=193}

            for buff in bp.__player.buffs():it() do

                if statuses[buff] then
                    return false
                end

            end

        end
        return true

    end

    o.canTrust = function()
        return (not o.isMoving() and S{0,1}:contains(bp.__player.status()) and not bp.__aggro.hasAggro()) or bp.__buffs.hasElvorseal() or bp.__buffs.hasReiveMark()

    end

    o.isReady = function(action)
        local action = type(action) == 'table' and action or bp.__res.get(action)

        if action and S{'/jobability','/pet'}:contains(action.prefix) then
            local recast = bp.ja_recast()

            if recast[action.recast_id] and recast[action.recast_id] < 1 then
                return true
                
            end

        elseif action and S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
            local spells    = bp.spells()
            local recast    = bp.ma_recast()
            local jpoints   = bp.__player.jp(bp.__player.mjob(true)).jp_spent

            if spells and spells[action.id] and recast[action.recast_id] and recast[action.recast_id] < 1 then
                local mjob = action.levels[bp.__player.mid()] or false
                local sjob = action.levels[bp.__player.sid()] or false

                if mjob then

                    if mjob < 100 and bp.__player.mlvl() >= mjob then
                        return true

                    elseif mjob >= 100 and jpoints >= mjob then
                        return true
                        
                    end

                elseif sjob then

                    if sjob < 100 and bp.__player.slvl() >= sjob then
                        return true                        
                    end

                end

            end

        elseif action and S{'/weaponskill'}:contains(action.prefix) then

            if bp.__player.tp() > 999 and o.isAvailable(action) then
                return true

            end

        end
        return false

    end

    o.isAvailable = function(action)
        local action = type(action) == 'table' and action or bp.__res.get(action)

        if action and S{'/jobability','/pet'}:contains(action.prefix) then
            local skills = bp.abilities().job_abilities
            local recast = bp.ja_recast()

            for skill in T(skills):it() do

                if skill == action.id then

                    if recast[action.recast_id] then
                        return true
                    end

                end

            end

        elseif action and S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
            local jpoints   = bp.__player.jp(bp.__player.mjob(true)).jp_spent
            local spells    = bp.spells()
            local recast    = bp.ma_recast()

            if spells and spells[action.id] and recast[action.recast_id] then
                local mjob = action.levels[bp.__player.mid()] or false
                local sjob = action.levels[bp.__player.sid()] or false

                if mjob then

                    if mjob < 100 and bp.__player.mlvl() >= mjob then
                        return true

                    elseif mjob >= 100 and jpoints >= mjob then
                        return true
                        
                    end

                elseif sjob then

                    if sjob < 100 and bp.__player.slvl() >= sjob then
                        return true                        
                    end

                end

            end

        elseif action and S{'/weaponskill'}:contains(action.prefix) then

            for skill in T(bp.abilities().weapon_skills):it() do

                if skill == action.id then
                    return true
                end

            end

        end
        return false

    end

    o.getRange = function(action)
        local action = type(action) == 'table' and action or bp.__res.get(action)
        
        if action and action.range and action_ranges[action.range] then
            return (action.range * action_ranges[action.range])

        end
        return 999

    end

    o.inActionRange = function(action, target)
        local action = type(action) == 'table' and action or bp.__res.get(action)
        local target = bp.__target.get(target)

        if action and target and action.range then
            local tr = bp.__target.getRadius(target.index)
            local ar = (action.range * action_ranges[action.range])

            if tr and ar and bp.__distance.get(target) < (tr + ar) then
                return true

            end

        end
        return false

    end

    o.inPetActionRange = function(action, target)
        local action = type(action) == 'table' and action or bp.__res.get(action)
        local target = bp.__target.get(target)

        if action and target and action.range then
            local tr = bp.__target.getRadius(target.index)
            local ar = (action.range * action_ranges[action.range])

            if tr and ar and bp.__distance.pet(target) < (tr + ar) then
                return true

            end

        end
        return false

    end

    o.acceptRaise = function()
        o.perform(bp.__player.get(), 'accept raise', 0)

    end

    o.engage = function(target)
        if not target then return end
        o.perform(target, 'engage', 0)

    end

    o.disengage = function()
        
        if bp.__player.status() == 1 then
            o.perform(bp.__target.get('t'), 'disengage', 0)
            
        end

    end

    o.switchTarget = function(target)
        local target = bp.__target.get(target)

        if target and bp.__target.canEngage(target) then
            local status = bp.__player.status()

            if status == 1 then
                o.perform(target, 'switch target', 0)
            
            elseif status == 0 then
                o.engage(target)
                
            end

        end

    end

    o.weaponskill = function(target)
        local target = bp.__target.get(target)
        local status = bp.__player.status()

        if target and status == 1 then
            bp.queue.add(bp.core.get('auto_melee_weaponskill').name, target, 100)
            
        end        

    end

    o.isFacing = function(target)
        local target = bp.__target.get(target)
        local player = bp.__player.get(true)

        if target and player then
            local m_degrees = ((o.getFacing()*180)/math.pi)
            local t_degrees = ((((target.facing)*180)/math.pi) + 180) >= 360 and ((((target.facing)*180)/math.pi)-180) or ((((target.facing)*180)/math.pi)+180)

            if math.abs(m_degrees - t_degrees) <= 15 and bp.__target.inRange(target) then
                return true
                
            end

        end
        return false

    end

    o.isBehind = function(target)
        local target = bp.__target.get(target)

        if target then
            local m_degrees = ((o.getFacing()*180)/math.pi)
            local t_degrees = (((target.facing)*180)/math.pi)
            
            if math.abs(m_degrees - t_degrees) <= 15 then
                return true
            end

        end
        return false

    end

    o.inConal = function(target)
        local target = bp.__target.get(target)

        if target then
            local m_degrees = ((o.getFacing()*180)/math.pi)
            local t_degrees = ((((target.facing)*180)/math.pi) + 180) >= 360 and ((((target.facing)*180)/math.pi)-180) or ((((target.facing)*180)/math.pi)+180)

            if math.abs(m_degrees - t_degrees) <= 38 then
                return true
            end

        end
        return false

    end

    o.itemReady = function(lookup, bag)

        if lookup and type(lookup) == 'string' then
            local bag, index, id = bp.__inventory.findItem(lookup)

            if bp and bag and index and id and bp.res.items[id] then
                local index, count, id, status, bag = bp.__inventory.getByIndex(bag, index)
                local data = index and bag and bp.extdata.decode(bp.items(bag, index)) or false

                if index and data and data.type and data.type == 'Enchanted Equipment' then
                    local charges   = data.charges_remaining
                    local ready     = math.max((data.activation_time + 18000) - os.time(), 0)
                    local next_use  = math.max((data.next_use_time + 18000) - os.time(), 0)

                    if charges > 0 and ready == 0 and next_use == 0 then
                        return index, count, id, status, bag, bp.res.items[id]

                    end

                end

            end

        elseif lookup and bag and tonumber(lookup) ~= nil and tonumber(bag) ~= nil then
            local index, count, id, status, bag = bp.__inventory.getByIndex(bag, lookup)
            local data = index and bag and bp.extdata.decode(bp.items(bag, index)) or false

            if index and data and data.type and data.type == 'Enchanted Equipment' then
                local charges   = data.charges_remaining
                local ready     = math.max((data.activation_time + 18000) - os.time(), 0)
                local next_use  = math.max((data.next_use_time + 18000) - os.time(), 0)

                if charges > 0 and ready == 0 and next_use == 0 then
                    return index, count, id, status, bag, bp.res.items[id]

                end

            end

        end
        return false

    end

    o.castItem = function(name, slot)
        local index, count, id, status, bag = o.itemReady(name)
            
        if index and bag and bp.res.items[id] then
            local item = bp.res.items[id]

            if item and item.cast_delay then

                if status == 0 and slot then
                    o.equipItem(index, slot, bag)
                    o.useItem:schedule((item.cast_delay + 2), index, bp.__player.get(), bag)
                    return (item.cast_delay + 2)

                elseif status == 5 then
                    o.useItem(index, bp.__player.get(), bag)
                    return (item.cast_delay + 2)

                end

            end

        end
        return 0

    end

    o.useDimensionalRing = function()
        local ring = false

        for bag in bp.__inventory.equippable():it() do

            for item, index in T(bp.items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and S{"Dim. Ring (Holla)","Dim. Ring (Dem)","Dim. Ring (Mea)"}:contains(bp.res.items[item.id].en) then
                    ring = {index=index, id=item.id, status=item.status, bag=bag, res=bp.res.items[item.id]}

                end

            end

        end

        if ring and ring.status and S{0,5}:contains(ring.status) then
            return o.castItem(ring.res.en, 13)

        end

    end

    -- Private Events.
    o.events('prerender', prerender)
    o.events('zone change', zonechange)
    o.events('status change', statuschange)
    o.events('incoming chunk', ianchor)
    o.events('outgoing chunk', oanchor)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and command == 'actions' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then
                local target = bp.targets.get('player')

                if ('weaponskill'):startswith(command) and target then
                    bp.orders.send('r', string.format('/ act __weaponskill %s', target.id))

                elseif ('switch'):startswith(command) and target then
                    bp.orders.send('r', string.format('/ act __switch %s', target.id))

                elseif ('action_after_death_delay'):startswith(command) then
                    settings.action_after_death_delay = (commands[1] and tonumber(commands[1]) or settings.action_after_death_delay)
                    settings:save()

                elseif ('prevent_spell_interruption'):startswith(command) then
                    settings.prevent_spell_interruption = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')
                    settings:save()

                elseif ('prevent_player_knockback'):startswith(command) then
                    settings.prevent_player_knockback = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')
                    settings:save()

                elseif ('auto_distance_from_target'):startswith(command) then
                    settings.auto_distance_from_target = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')
                    settings:save()

                elseif ('auto_face_target'):startswith(command) then
                    settings.auto_face_target = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')
                    settings:save()

                elseif command == '__weaponskill' and commands[1] then
                    bp.__actions.weaponskill(commands[1])

                elseif command == '__switch' and commands[1] then
                    bp.__actions.switchTarget(commands[1])
                    
                end

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    -- Open Action Handler.
    ActionPacket.open_listener(function(_, act)
        if act.category ~= 11 or not o.isKnockbackAllowed() then
            return
        end

        for x = 1, act.target_count do

            for n = 1, act.targets[x].action_count do
                act.targets[x].actions[n].stagger = 0
                act.targets[x].actions[n].knockback = 0

            end

        end
        return act

    end)

    return o

end
return helper