local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local current_roll  = nil
    local midroll       = false
    local lucky_rolls   = {

        ["Samurai Roll"]        = 2,    ["Chaos Roll"]          = 4,
        ["Hunter's Roll"]       = 4,    ["Fighter's Roll"]      = 5,
        ["Wizard's Roll"]       = 5,    ["Tactician's Roll"]    = 5,
        ["Runeist's Roll"]      = 4,    ["Beast Roll"]          = 4,
        ["Puppet Roll"]         = 3,    ["Corsair's Roll"]      = 5,
        ["Evoker's Roll"]       = 5,    ["Companion's Roll"]    = 2,
        ["Warlock's Roll"]      = 4,    ["Magus's Roll"]        = 2,
        ["Drachen Roll"]        = 4,    ["Allies' Roll"]        = 3,
        ["Rogue's Roll"]        = 5,    ["Gallant's Roll"]      = 3,
        ["Healer's Roll"]       = 3,    ["Ninja's Roll"]        = 4,
        ["Choral Roll"]         = 2,    ["Monk's Roll"]         = 3,
        ["Dancer's Roll"]       = 3,    ["Scholar's Roll"]      = 2,
        ["Naturalist's Roll"]   = 3,    ["Avenger's Roll"]      = 4,
        ["Bolter's Roll"]       = 3,    ["Caster's Roll"]       = 2,
        ["Courser's Roll"]      = 3,    ["Blitzer's Roll"]      = 4,
        ["Miser's Roll"]        = 5,

    }

    local unlucky_rolls = {

        ["Samurai Roll"]        = 6,    ["Chaos Roll"]          = 8,
        ["Hunter's Roll"]       = 8,    ["Fighter's Roll"]      = 9,
        ["Wizard's Roll"]       = 9,    ["Tactician's Roll"]    = 8,
        ["Runeist's Roll"]      = 8,    ["Beast Roll"]          = 8,
        ["Puppet Roll"]         = 7,    ["Corsair's Roll"]      = 9,
        ["Evoker's Roll"]       = 9,    ["Companion's Roll"]    = 10,
        ["Warlock's Roll"]      = 8,    ["Magus's Roll"]        = 6,
        ["Drachen Roll"]        = 8,    ["Allies' Roll"]        = 10,
        ["Rogue's Roll"]        = 9,    ["Gallant's Roll"]      = 7,
        ["Healer's Roll"]       = 7,    ["Ninja's Roll"]        = 8,
        ["Choral Roll"]         = 6,    ["Monk's Roll"]         = 7,
        ["Dancer's Roll"]       = 7,    ["Scholar's Roll"]      = 6,
        ["Naturalist's Roll"]   = 7,    ["Avenger's Roll"]      = 8,
        ["Bolter's Roll"]       = 9,    ["Caster's Roll"]       = 7,
        ["Courser's Roll"]      = 9,    ["Blitzer's Roll"]      = 9,
        ["Miser's Roll"]        = 7,

    }

    -- Public Variables.
    o.list = T(bp.res.job_abilities):map(function(ability) return ability.type == "CorsairRoll" and ability.en or nil end)

    -- Private Methods.
    local function onload()

    end

    local function lose_buff(id)
        if not S{308}:contains(id) then
            return
        end
        current_roll, midroll = nil, false

    end

    -- Public Methods.
    o.getRolling = function()
        return current_roll

    end

    o.isMidroll = function()
        return midroll

    end

    o.isLucky = function(name, n)
        return lucky_rolls[name] and (lucky_rolls[name] == n or n == 11) or false
    
    end

    o.isUnlucky = function(name, n)
        return unlucky_rolls[name] and unlucky_rolls[name] == n or false
    
    end

    o.getLucky = function(name)
        return lucky_rolls[name] and true or false
    
    end

    o.getUnlucky = function(name)
        return unlucky_rolls[name] and true or false

    end

    o.active = function(b)
        local active = S(T(bp.__player.buffs()):map(function(id) return T{903,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,600}:contains(id) and bp.res.buffs[id].en or nil end))
        return b and active:length() or active
        
    end
    
    o.getMissing = function()
        local rolls = bp.core.get('auto_rolls')

        if rolls then
            return T(S{rolls.roll_1, rolls.roll_2}:copy():diff(o.active()))
            
        end
        return S{}

    end
    
    o.get = function(n)
        local rolls = bp.core.get('auto_rolls')
        
        if rolls then

            if n then
                return rolls[n]

            end
            return rolls

        end
        return nil

    end

    -- Private Events.
    bp.register('lose buff', lose_buff)
    bp.register('incoming chunk', function(id, original)
    
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = bp.__target.get(parsed['Actor'])
            local target    = bp.__target.get(parsed['Target 1 ID'])
            
            if parsed and actor and target and bp.__player.id() == actor.id and bp.__player.id() == target.id and parsed['Category'] == 6 then
                local rolls = bp.core.get('auto_rolls')

                do
                    current_roll = {name=bp.res.job_abilities[parsed['Param']].en, number=parsed['Target 1 Action 1 Param']}
                    midroll = true

                end

                if rolls and parsed['Target 1 Action 1 Param'] and bp.res.job_abilities[parsed['Param']] and o.list:contains(bp.res.job_abilities[parsed['Param']].en) then
                    local doubleup = bp.core.get('auto_double_up')

                    if current_roll.number >= (doubleup and doubleup.max or 7) and not bp.actions.isReady("Snake Eye") then
                        current_roll, midroll = nil, false

                    elseif (o.isLucky(current_roll.name, current_roll.number) or current_roll.number == 11) then
                        current_roll, midroll = nil, false

                    end
                    
                end

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper