local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings  = bp.__settings.new(string.format("cures/%s%s", bp.__player.mjob(true), bp.__player.sjob(true)))
    local jobs      = S{'WHM','RDM','SCH','PLD','DNC','BLU'}
    local partydata = {}

    do -- Setup default setting values.
        settings.auto_cures_enabled     = settings:default('auto_cures_enabled',        false)
        settings.alliance_cures_enabled = settings:default('alliance_cures_enabled',    false)
        settings.cure_power             = settings:default('cure_power',                15)
        settings.debug_cures            = settings:default('debug_cures',               {enabled=false, hpp=75})
        settings.cure                   = settings:default('cure',                      {enabled=false, hp=90,      hpp=0})
        settings.cure_ii                = settings:default('cure_ii',                   {enabled=false, hp=200,     hpp=0})
        settings.cure_iii               = settings:default('cure_iii',                  {enabled=false, hp=650,     hpp=0})
        settings.cure_iv                = settings:default('cure_iv',                   {enabled=false, hp=900,     hpp=0})
        settings.cure_v                 = settings:default('cure_v',                    {enabled=false, hp=1100,    hpp=0})
        settings.cure_vi                = settings:default('cure_vi',                   {enabled=false, hp=1800,    hpp=0})
        settings.curaga                 = settings:default('curaga',                    {enabled=false, hp=110,     hpp=0})
        settings.curaga_ii              = settings:default('curaga_ii',                 {enabled=false, hp=275,     hpp=0})
        settings.curaga_iii             = settings:default('curaga_iii',                {enabled=false, hp=700,     hpp=0})
        settings.curaga_iv              = settings:default('curaga_iv',                 {enabled=false, hp=980,     hpp=0})
        settings.curaga_v               = settings:default('curaga_v',                  {enabled=false, hp=1300,    hpp=0})
        settings.curing_waltz           = settings:default('curing_waltz',              {enabled=false, hp=200,     hpp=0})
        settings.curing_waltz_ii        = settings:default('curing_waltz_ii',           {enabled=false, hp=650,     hpp=0})
        settings.curing_waltz_iii       = settings:default('curing_waltz_iii',          {enabled=false, hp=900,     hpp=0})
        settings.curing_waltz_iv        = settings:default('curing_waltz_iv',           {enabled=false, hp=1100,    hpp=0})
        settings.curing_waltz_v         = settings:default('curing_waltz_v',            {enabled=false, hp=1800,    hpp=0})
        settings.divine_waltz           = settings:default('divine_waltz',              {enabled=false, hp=100,     hpp=0})
        settings.divine_waltz_ii        = settings:default('divine_waltz_ii',           {enabled=false, hp=400,     hpp=0})
        
    end

    -- Public Variables.

    -- Private Methods.
    local function filter_settings()
        local romans = {['ii']='II', ['IIi']='III', ['iv']='IV', ['v']='V', ['vi']='VI'}

        -- Filter the keys for spells if the character can cast that spell currently.
        for key in T(settings:get():keyset()):it() do
            local name = ((function(s) for old, new in pairs(romans) do s = (s:gsub(old, new)) end return s end)(key)):gsub('_', ' '):capitalize()
            
            if bp.__res.get(name) and not bp.__player.hasSpell(bp.__res.get(name).id) then
                settings[key] = nil

            end

        end

    end

    local function onload()
        o.timer('build-party', 0.4)

        if jobs:contains(bp.__player.mjob()) or jobs:contains(bp.__player.sjob()) then
            filter_settings()
            settings:save():update()

        end

    end

    local function update_settings()
        filter_settings()
        settings:save():update()

    end

    local function sort()
        return table.sort(partydata, function(a, b) return a.missing > b.missing end)

    end

    local function update_party()
        local timer = o.timer('build-party')

        if timer:ready() then
            partydata = {}

            for data in T(bp.__party.get()):it() do

                if data.mob and data.mob.valid_target then

                    if data.mob.in_party then
                        table.insert(partydata, {id=data.mob.id, index=data.mob.index, name=data.name, hp=data.hp, hpp=data.hpp, missing=data.missing, distance=bp.__distance.get(data.mob.id), valid=data.mob.valid_target})

                    elseif settings:get('alliance_cures_enabled') and not data.mob.in_party and data.mob.in_alliance then
                        table.insert(partydata, {id=data.mob.id, index=data.mob.index, name=data.name, hp=data.hp, hpp=data.hpp, missing=data.missing, distance=bp.__distance.get(data.mob.id), valid=data.mob.valid_target})

                    end

                end

            end
            partydata = sort()
            timer:update()

        end

    end

    local function estimateCure(member)
        local selected = nil
        local target = nil

        if member and member.missing and member.hpp and member.missing > 0 then

            for id in T{1,2,3,4,5,6}:it() do
                local spell = bp.res.spells[id]
                local name = string.format('%s', spell.en:gsub(' ', '_')):lower()

                if spell and name and bp.__player.hasSpell(spell.id) and settings:get(name) then
                    local setting = settings:get(name)
                    
                    if setting and setting.enabled then
                        local power = settings:get('cure_power')
                        local vitals = bp.__player.vitals()
                        local estimate = ((setting.hp or 0) + ((setting.hp or 0) * ((power or 0) / 100)))

                        if bp.actions.isReady(spell) and vitals.mp >= spell.mp_cost and estimate < member.missing and (setting.hpp == 0 or setting.hpp <= member.hpp) then
                            target = bp.__target.get(member.id)
                            selected = spell
                        
                        end

                    end

                end

            end
            
        end
        return target, selected
        
    end

    local function getWeight()
        local curaga_target = {target=false, weight=0, count=0}
        local sorted = sort()

        for target_a in T(sorted):it() do
            
            if target_a.distance <= 21 then

            end

        end

        --[[
        for target in T(sorted):it() do
            local target = bp.__target.get(target.id)

            if target and bp.__distance.get(target) <= 21 then
                local weight, n = 0, 0

                for _,m in ipairs(sorted) do
                    local member = bp.__target.get(m.id)
                    
                    if member and (((target.x-member.x)^2 + (target.y-member.y)^2) <= 10^2) then

                        if bp.player.main_job_level == 99 then
                            local curaga = false

                            for i=3, #allowed['Curaga'] do
                                local spell = allowed['Curaga'][i]

                                if spell and m.missing >= spell.min then
                                    curaga = spell
                                end

                            end

                            if curaga then
                                weight = (weight + m.missing)
                                n = (n + 1)

                            end

                        elseif bp.player.main_job_level < 50 then

                            for i=1, #allowed['Curaga'] do
                                local spell = allowed['Curaga'][i]

                                if spell and m.missing >= spell.min then
                                    curaga = spell
                                end

                            end

                            if curaga then
                                weight, n = (weight + m.missing), (n + 1)
                            end

                        end

                    end

                end

                if weight > selected.weight then
                    selected = {target=target, weight=weight, count=n}                    
                end
                
            end

        end
        ]]
        return selected

    end

    local function handle_incoming(id, original)
        if not S{0x028,0x0df}:contains(id) then
            return false

        end

        local debug = settings:get('debug_cures')

        if settings:get('auto_cures_enabled') then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = bp.__target.get(parsed['Actor'])
            local target    = bp.__target.get(parsed['Target 1 ID'])
            local count     = parsed['Target Count']
            local category  = parsed['Category']
            local param     = parsed['Param']

            if actor and target and bp.__player.id() == actor.id and bp.res.spells[param] then
                local spell = bp.res.spells[param]
                
                if category == 4 and spell.en:startswith('Cure') then

                    if bp.queue.length() > 0 then
                        local targets = T{}
                        
                        for i=0, count do
                            table.insert(targets, parsed[string.format('Target %s ID', i)])

                        end
                        
                        if #targets > 0 then

                            for i=bp.queue.length(), 1, -1 do
                                local act = bp.queue.get(i)

                                if act and act.action.en:startswith('Cure') and targets:contains(act.target.id) then
                                    bp.queue.remove(act.action, act.target)

                                end

                            end

                        end

                    end

                end

            end

        elseif id == 0x0df and debug and debug.enabled then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['ID'] ~= bp.__player.id() then
                parsed['HPP'] = debug.hpp
                return bp.packets.build(parsed)

            end

        end

    end

    local function updateCure(action, target, missing)
        local action    = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
        local target    = bp.__target.get(target)
        local priority  = bp.priorities.get(action.en)

        if missing then
            priority = (priority + (missing / 10000))

        end
            
        if action and target then
            local update = false

            for act, index in bp.queue.it() do
                
                if act.action and act.target and (act.action.type == 'WhiteMagic' or act.action.type == 'Waltz') then
                    
                    if act.target.id == target.id and act.action.en ~= action.en and act.action.en:startswith('Cur') and not bp.queue.inQueue(action.en, target) then
                        act.action, act.priority = bp.res.spells[action.id], priority
                        update = true

                    elseif act.target.id == target.id and act.action.en ~= action.en and act.action.en:startswith('Waltz') and not bp.queue.inQueue(action.en, target) then
                        act.action, act.priority = bp.res.job_abilities[action.id], priority
                        update = true

                    end

                end

            end

            if not update then
                bp.queue.add(action.en, target, priority)
                return true

            end

        end
        return false

    end

    -- Public Methods.
    o.handleCuring = function()
        if T(partydata):length() == 0 then
            return

        end

        if settings:get('auto_cures_enabled') then

            if bp.__player.mjob() == 'DNC' or bp.__player.sjob() == 'DNC' then

            else

                for member in T(partydata):it() do
                    local target, cure = estimateCure(member)

                    if target and cure and not bp.queue.inQueue(cure.en, target) then
                
                        if bp.__distance.get(target) <= bp.actions.getRange(cure) and not T{2,3}:contains(target.status) then
                            updateCure(cure, target.id, member.missing)

                        end
                    
                    end

                end

            end

        end

    end

    --[[
    o.getCuraga = function()
        local weight = getWeight()

        if weight and weight.count > 2 and (bp.player.main_job == 'WHM' or bp.player.sub_job == 'WHM') then
            local cure = estimateCuraga(weight)

            if cure and not bp.__queue.inQueue(cure.en) then
                cure.target = weight.target
                cure.count  = weight.count

                if cure.target and cure.count then
                    return cure
                end

            end

        end
        return false

    end
    ]]

    -- Private Events.
    o.events('prerender', update_party)
    o.events('incoming chunk', handle_incoming)
    o.events('zone change', update_settings)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and (string.match(command, 'cures/%a%a%a%a%a%a')) then

            if settings[commands[1]] ~= nil then
                settings:fromClient(commands)

            else

                local command = commands[1] and table.remove(commands, 1):lower()

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper

--[[
    -- Private Variables.
    local debug         = false
    local settings      = bp.__settings.new('cures')
    local party         = {}
    local alliance      = {}
    local priorities    = {}
    

    -- Private Methods.
    local function validSpell(id)
        return T({1,2,3,4,5,6,7,8,9,10,11}):contains(id)
    
    end
    
    local function validAbility(id)
        return T({190,191,192,193,311,195,262}):contains(id)
    
    end

    local function validJob(id)
        return T({3,4,5,7,10,15,19,20,21}):contains(id)

    end

    local function estimateCuraga(w)
        local estimate = false
        
        if bp and bp.player and w and w.weight and w.count then
            local vitals = bp.player.vitals
            local mlevel = bp.player.main_job_level

            if mlevel == 99 then
            
                for cure in T(allowed['Curaga']):it() do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.__actions.isReady(spell.en) and cure.id > 8 and vitals.mp >= spell.mp_cost then
                        local weight = (w.weight/w.count)

                        if weight and (cure.min + (cure.min * (settings.power / 100))) <= weight then
                            estimate = bp.res.spells[cure.id]
                        end

                    end

                end

            elseif mlevel < 50 then

                for cure in T(allowed['Curaga']):it() do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.__actions.isReady(spell.en) and vitals.mp >= spell.mp_cost then
                        local weight = (w.weight/w.count)

                        if weight and (cure.min + (cure.min * (settings.power / 100))) <= weight then
                            estimate = bp.res.spells[cure.id]
                        end
                        
                    end

                end

            end
            
        end
        return estimate
        
    end

    local function estimateWaltz(missing, percent)
        local estimate, once = false, true
        
        if bp and bp.player and missing and percent and missing > 0 then
            local vitals = bp.player.vitals
            local mlevel = bp.player.main_job_level
            
            if bp.player.main_job == 'DNC' then
                
                if mlevel >= 87 then
                
                    for cure in T(allowed['Waltz']):it() do
                        local spell = bp.res.job_abilities[cure.id]
                                    
                        if spell and bp.__actions.isReady(spell.en) and cure.id > 191 and vitals.tp >= spell.tp_cost then

                            if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                estimate = spell

                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false

                            end
                        
                        end

                    end

                else

                    for cure in T(allowed['Waltz']):it() do
                        local spell = bp.res.job_abilities[cure.id]

                        if spell and bp.__actions.isReady(spell.en) and vitals.tp >= spell.tp_cost then

                            if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                estimate = spell

                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false

                            end

                        end

                    end

                end

            elseif bp.player.sub_job == 'DNC' then

                for cure in T(allowed['Waltz']):it() do
                    local spell = bp.res.job_abilities[cure.id]
                                
                    if spell and bp.__actions.isReady(spell.en) and cure.id > 190 and vitals.tp >= spell.tp_cost then

                        if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                            estimate = spell

                        elseif missing > cure.min and percent < 85 and once then
                            estimate, once = spell, false

                        end
                    
                    end

                end

            end
            
        end
        return estimate
        
    end

    -- Register Custom Events.
    self.__registerEvents = function()
        local class = self.__class

        if class and class.addEvent then

        end

    end
        
    -- Public Methods.
    self.getModes = function()
        return {'PARTY','ALLIANCE'}
    
    end

    self.getWeight = function() return getWeight() end   
    self.setPriority = function(target, urgency)
        local target    = bp.__target.get(target)
        local urgency   = tonumber(urgency)

        if target and urgency and urgency >= 0 and urgency <= 100 then
            priorities[target.id] = urgency
            bp.popchat.pop(string.format('PRIORITY FOR \\cs(%s)%s\\cr SET TO: \\cs(%s)%03d\\cr.', bp.colors.setting, target.name:upper(), bp.colors.setting, urgency))

        else

            if target and not urgency then
                bp.popchat.pop('PLEASE ENTER A VALID NUMBER BETWEEN 0 & 100!')

            else
                bp.popchat.pop('INVALID TARGET SELECTED!')

            end

        end

    end

    self.getPriority = function(target)
        local target = bp.__target.get(target)

        if target and priorities[target.id] then
            return priorities[target.id] or 0    
        end
        return 0

    end

    self.doDNCCures = function(party)

        for member in T(party):it() do
            local cure = estimateWaltz(member.missing, member.hpp)
            local target = bp.__target.get(member.id)

            if cure and target and not bp.__queue.inQueue(cure.en, target) then
                
                if (bp.__distance.get(target) - target.model_size) <= bp.__queue.getRange(cure.en) and not T{2,3}:contains(target.status) then
                    updateCure(cure, target)
                end
            
            end

        end

    end
        
    -- Private Events.
    self.__events('prerender', buildParty)
    self.__events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
        
        if bp and command and command:lower() == 'cures' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command and command:startswith('pri') and #commands > 0 then
                local target    = tonumber(commands[#commands]) == nil and bp.__target.get(commands[#commands]) or windower.ffxi.get_mob_by_target('t')
                local value     = tonumber(commands[1]) or false

                if value and bp.party.isMember(target, true) then
                    self.setPriority(target, value)
                end

            end
            settings:save()

        end

    end)

    ]]