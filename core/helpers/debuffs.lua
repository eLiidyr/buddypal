local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings          = bp.__settings.new('debuffs')
    local debuff_targets    = T{}

    do -- Setup default setting values.
        settings.debuffing_enabled  = settings:default('debuffing_enabled',  false)
        settings.debuffs            = settings:default('debuffs',  {})

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:save()
        settings:update()

    end

    local function remove_debuff(id, tid)
        local tid = tonumber(tid)
        local id = tonumber(id)
        
        if id and tid and debuff_targets[tid] and debuff_targets[tid]:contains(id) then
            debuff_targets[tid] = debuff_targets[tid]:filter(function(cid) return not cid == id end)

        end

    end

    local function add_spell(spell)
        local spell = bp.__res.get(table.concat(spell, " "))
        local mid = bp.__player.mjob()

        if spell and spell.en and spell.status and mid then
            if not settings.debuffs[mid] then settings.debuffs[mid] = {} end
            
            if not S(settings.debuffs[mid]):contains(spell.en) then
                table.insert(settings.debuffs[mid], spell.en)

            end

        end

    end

    local function remove_spell(spell)
        local spell = bp.resource(table.concat(spell, " "))
        local mid = bp.__player.mjob()

        if spell and spell.en and mid and settings.debuffs[mid] then

            for name, i in T(settings.debuffs[mid]):it() do

                if name == spell.en then
                    return table.remove(settings.debuffs[mid], i)

                end

            end

        end

    end

    local function handle_incoming(id, original)
        if not o.isEnabled() then return false end

        if id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = bp.__target.get(parsed['Actor'])
            local target    = bp.__target.get(parsed['Target 1 ID'])

            if parsed and actor and target and debuff_targets[target.id] and bp.__party.isMember(actor.name, true) and bp.__target.isEnemy(target) and S{3,4,6,12,13,14,15}:contains(parsed['Category']) then
                local targets = parsed['Target Count']

                if parsed['Category'] == 3 then
                    local action = bp.res.weapon_skills[parsed['Param']]

                elseif parsed['Category'] == 4 then
                    local action = bp.res.spells[parsed['Param']]

                    if action and action.status then

                        for i=1, targets do
                            local id = parsed[string.format("Target %d ID", i)]

                            if debuff_targets[id] and not debuff_targets[id]:contains(action.status) then
                                if S{85,284,653,654,655,656}:contains(parsed[string.format("Target %d Action 1 Message", i)]) then return false end

                                if action.overwrites then
                                    debuff_targets[id] = debuff_targets[id]:filter(function(cid) return not S(action.overwrites):map(function(i) return bp.res.buffs[bp.res.spells[i].status].id end):contains(cid) end)

                                end
                                debuff_targets[id]:add(action.status)

                            end

                        end

                    end

                elseif parsed['Category'] == 6 then
                    local action = bp.res.job_abilities[parsed['Param']]

                elseif parsed['Category'] == 12 then

                elseif parsed['Category'] == 13 then

                elseif parsed['Category'] == 14 then
                    local action = bp.res.job_abilities[parsed['Param']]

                elseif parsed['Category'] == 15 then
                    local action = bp.res.job_abilities[parsed['Param']]

                end

            end

        elseif id == 0x029 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and debuff_targets:length() > 0 and S{64,74,83,123,159,168,204,206,321,322,341,342,343,344,350,378,531,647,805,806}:contains(parsed['Message']) then
                local target = bp.__target.get(parsed['Target'])
                
                if target and debuff_targets[target.id] and debuff_targets[target.id]:contains(parsed['Param 1']) then
                    debuff_targets[target.id]:remove(parsed['Param 1'])

                    do -- Remove from other players tables.
                        bp.orders.send('r*', string.format('/ debuffs remove-debuff %s', parsed['Param 1'], target.id))

                    end

                end

            end

        elseif id == 0x00e then
            if bp.zoning.isInTown() then return false end
            local parsed = bp.packets.parse('incoming', original)
            local rshift = bit.rshift
            local band = bit.band

            if parsed and bp.__target.isEnemy(parsed['NPC']) then
                local remove = band(rshift(parsed['Mask'], 5), 1) == 1 and true or false
                local status = band(rshift(parsed['Mask'], 2), 1) == 1 and true or false

                if status then
                    local target = bp.__target.get(parsed['NPC'])

                    if target and target.status and S{2,3}:contains(target.status) and debuff_targets[target.id] then
                        debuff_targets[target.id] = nil

                    end

                elseif remove and debuff_targets[parsed['NPC']] then
                    debuff_targets[parsed['NPC']] = nil

                elseif not remove and not debuff_targets[parsed['NPC']] then
                    debuff_targets[parsed['NPC']] = S{}

                end

            end

        end

    end

    -- Public Methods.
    o.isEnabled = function()
        return (settings.debuffing_enabled == true)

    end

    o.hasDebuff = function(id, target)
        local target = bp.__target.get(target)

        if target and debuff_targets[target.id] and debuff_targets[target.id]:contains(id) then
            return true

        end
        return false

    end

    o.cast = function()
        if not o.isEnabled() then return end

        local target = bp.targets.get('player')
        local mid = bp.__player.mjob()

        if target and mid and settings.debuffs[mid] then

            for s in T(settings.debuffs[mid]):it() do
                local spell = bp.resource(s)

                if spell and spell.status and debuff_targets[target.id] and not debuff_targets[target.id]:contains(spell.status) and bp.actions.isReady(spell) then
                    bp.queue.add(spell, target)
                    break

                end

            end

        end

    end

    -- Private Events.
    o.events('incoming', handle_incoming)
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if command and command:lower() == 'debuffs' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'debuffing_enabled' and #commands > 0 then
                    settings.debuffing_enabled = (commands[1] and T{'!','#'}:contains(commands[1])) and (commands[1] == '!')

                elseif command == 'remove-debuff' and commands[1] and commands[2] then
                    remove_debuff(commands[1], commands[2])

                elseif command == 'add-spell' and #commands > 0 then
                    add_spell(commands)

                elseif command == 'remove-spell' and #commands > 0 then
                    remove_spell(commands)

                end

            end
            settings:save()

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper