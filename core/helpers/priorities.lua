local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local ja = bp.__settings.new("/priorities/abilities")
    local ma = bp.__settings.new("/priorities/spells")
    local ws = bp.__settings.new("/priorities/skills")
    local it = bp.__settings.new("/priorities/items")

    do -- Setup default setting values.
        ja.priorities = ja:default('priorities', {})
        ma.priorities = ma:default('priorities', {})
        ws.priorities = ws:default('priorities', {})
        it.priorities = it:default('priorities', {})

    end

    -- Public Variables.

    -- Private Methods.
    local function set(name, value)
        local resource = bp.__res.get(name)
        local value = tonumber(value)

        if resource and value and value <= 999 and o.get(resource.en) then
            
            if S{'/jobability','/pet'}:contains(resource.prefix) then
                ja.priorities[tostring(resource.id)] = value

            elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                ma.priorities[tostring(resource.id)] = value

            elseif S{'/weaponskill'}:contains(resource.prefix) then
                ws.priorities[tostring(resource.id)] = value

            elseif resource.flags and resource.flags:contains('Usable') then
                it.priorities[tostring(resource.id)] = value

            end

        end

    end

    local function build()
        local specific = T{

            ["Megalixir"]           = 250,
            ["Vile Elixir +1"]      = 250,
            ["Full Circle"]         = 102,
            ["Radial Arcana"]       = 101,
            ["Mending Halation"]    = 101,
            ["Blaze of Glory"]      = 99,
            ["Lasting Emanation"]   = 97,
            ["Ecliptic Attrition"]  = 97,
            ["Dematerialize"]       = 96,
            ["Life Cycle"]          = 96,
            ["Majesty"]             = 51,
            ["Curaga V"]            = 50,
            ["Curaga IV"]           = 50,
            ["Curaga III"]          = 50,
            ["Cure VI"]             = 49,
            ["Cure V"]              = 49,
            ["Vivacious Pulse"]     = 49,
            ["Holy Water"]          = 48,
            ["Cursna"]              = 48,
            ["Stona"]               = 47,
            ["Curaga"]              = 47,
            ["Divine Waltz"]        = 47,
            ["Echo Drops"]          = 46,
            ["Silena"]              = 46,
            ["Panacea"]             = 45,
            ["Erase"]               = 45,
            ["Remedy"]              = 43,
            ["Viruna"]              = 43,
            ["Blindna"]             = 42,
            ["Paralyna"]            = 42,
            ["Poisona"]             = 42,
            ["Eye Drops"]           = 42,
            ["Antidote"]            = 42,
            ["Cure IV"]             = 40,
            ["Foil"]                = 30,
            ["Vallation"]           = 28,
            ["Valiance"]            = 28,
            ["Pflug"]               = 28,
            ["Soporific"]           = 26,
            ["Geist Wall"]          = 26,
            ["Sheep Song"]          = 26,
            ["Provoke"]             = 24,
            ["Shield Bash"]         = 24,
            ["Jettatura"]           = 24,
            ["Blank Gaze"]          = 24,
            ["Flash"]               = 22,
            ["Stun"]                = 22,
            ["Animated Flourish"]   = 22,
            ["Souleater"]           = 20,
            ["Last Resort"]         = 20,
            ["Stinking Gas"]        = 20,
            ["Dispel"]              = 20,
            ["Magic Finale"]        = 20,
            ["Poisonga"]            = 20,
            ["Toolbag (Shika)"]     = 20,
            ["Toolbag (Cho)"]       = 20,
            ["Toolbag (Ino)"]       = 20,
            ["Toolbag (Sanja)"]     = 20,
            ["Toolbag (Soshi)"]     = 20,
            ["Toolbag (Uchi)"]      = 20,
            ["Toolbag (Tsura)"]     = 20,
            ["Toolbag (Kawa)"]      = 20,
            ["Toolbag (Maki)"]      = 20,
            ["Toolbag (Hira)"]      = 20,
            ["Toolbag (Mizu)"]      = 20,
            ["Toolbag (Shihe)"]     = 20,
            ["Toolbag (Jusa)"]      = 20,
            ["Toolbag (Kagi)"]      = 20,
            ["Toolbag (Sai)"]       = 20,
            ["Toolbag (Kodo)"]      = 20,
            ["Toolbag (Shino)"]     = 20,
            ["Toolbag (Ranka)"]     = 20,
            ["Toolbag (Furu)"]      = 20,
            ["Toolbag (Kaben)"]     = 20,
            ["Toolbag (Jinko)"]     = 20,
            ["Toolbag (Ryuno)"]     = 20,
            ["Toolbag (Moku)"]      = 20,
            ["Utsusemi: San"]       = 19,
            ["Utsusemi: Ni"]        = 18,
            ["Utsusemi: Ichi"]      = 17,
            ["Raise"]               = 10,
            ["Raise II"]            = 10,
            ["Raise III"]           = 10,
            ["Arise"]               = 10,
            ["Reraise"]             = 10,
            ["Reraise II"]          = 10,
            ["Reraise III"]         = 10,
            ["Reraise IV"]          = 10,
            ["Phalanx"]             = 7,
            ["Phalanx II"]          = 7,
            ["Sekkanoki"]           = 7,
            ["Warrior's Charge"]    = 7,
            ["Refresh"]             = 6,
            ["Refresh II"]          = 6,
            ["Refresh III"]         = 6,
            ["Cure III"]            = 4,
            ["Cure II"]             = 4,
            ["Curaga II"]           = 4,
            ["Avatar's Favor"]      = 4,
            ["Cure"]                = 3,
            ["Apogee"]              = 2,
            ["Mana Cede"]           = 2,
            ["Elemental Siphon"]    = 2,

        }
    
        -- ABILITIES.
        for action in T(bp.res.job_abilities):it() do

            -- PET COMMANDS.
            if action.prefix == '/pet' then

                if S{'Assault','Retreat','Release','Fight','Heel','Stay','Activate','Deus Ex Automata','Deactivate','Deploy','Retrieve'}:contains(action.en) then
                    set(action.en, 3)
                
                end

            -- SELF-ENHANCING ABILITIES.
            else

                if (action.targets:contains('Self') or action.targets:contains('Player') or action.targets:contains('Party') or action.targets:contains('Ally')) and action.status then
                    set(action.en, 27)

                else
                    set(action.en, 1)
                
                end

            end

        end
    
        -- SPELLS.
        for action in T(bp.res.spells):it() do

            -- SUMMONING SPELLS.
            if action.type == 'SummonerPact' then
                set(action.en, 2)

            -- ENHANCING SPELLS.
            else

                if (action.targets:contains('Self') or action.targets:contains('Player') or action.targets:contains('Party') or action.targets:contains('Ally')) and action.status and T{34,37,39}:contains(action.skill) then
                    set(action.en, 5)

                else
                    set(action.en, 1)
                
                end

            end

        end
    
        -- GEOMANCY SPELLS.
        for action in T(bp.res.spells):it() do

            if action.en:startswith("Geo-") then
                set(action.en, 98)

            else
                set(action.en, 1)

            end

        end

        -- ITEMS.
        for action in T(bp.res.items):it() do

            if action.flags and action.flags:contains('Usable') then
                set(action.en, 1)

            end

        end
    
        -- 1 HOURS.
        for action in T{16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,93,96,135,181,210,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,356,377,378}:it() do
            set(bp.res.job_abilities[action].en, 100)
        
        end
    
        -- SPECIFIC DEFAULTS.
        for priority, action in specific:it() do
            set(action, priority)
        
        end
    
    end

    local function onload()

        if T(ja.priorities):length() == 0 or T(ma.priorities):length() == 0 or T(ws.priorities):length() == 0 or T(it.priorities):length() == 0 then
            
            -- Build default values.
            build()

            do -- Save all the settings.
                ja:save()
                ma:save()
                ws:save()
                it:save()

            end

        end

    end

    -- Public Methods.
    o.get = function(name)
        local resource = bp.__res.get(name)

        if resource then
            
            if S{'/jobability','/pet'}:contains(resource.prefix) then
                return ja.priorities[tostring(resource.id)] or 1

            elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                return ma.priorities[tostring(resource.id)] or 1

            elseif S{'/weaponskill'}:contains(resource.prefix) then
                return ws.priorities[tostring(resource.id)] or 1

            elseif resource.flags and resource.flags:contains('Usable') then
                return it.priorities[tostring(resource.id)] or 1

            end

        end
        return 1

    end

    -- Private Events.

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper