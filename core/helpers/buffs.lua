local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings = bp.__settings.new(string.format("buffs/%s%s", bp.__player.mjob(true), bp.__player.sjob(true)))
    local base = {

        WAR={},    
        MNK={},    
        WHM={
            __mainonly = {'auto_boost','auto_auspice'},
            auto_boost = {enabled=false, name="Boost-STR"},
            auto_haste = false,
            auto_aquaveil = false,
            auto_blink = false,
            auto_stoneskin = false,
            auto_auspice = false,
            auto_reraise = false,
        },    
        BLM={
            __mainonly = {},
            auto_spikes = {enabled=false, name="Blaze Spikes"},
        },    
        RDM={
            __mainonly = {'auto_gain_stats','auto_temper'},
            auto_enspell = {enabled=false, name="Enfire"},
            auto_spikes = {enabled=false, name="Blaze Spikes"},
            auto_gain_stats = {enabled=false, name="Gain-DEX"},
            auto_blink = false,
            auto_aquaveil = false,
            auto_stoneskin = false,
            auto_haste = false,
            auto_phalanx = false,
            auto_temper = false,
            auto_refresh = false,
        },    
        THF={},    
        PLD={
            __mainonly = {'auto_reprisal','auto_crusade','auto_enlight'},
            auto_reprisal = false,
            auto_phalanx = false,
            auto_crusade = false,
            auto_enlight = false,
        },    
        DRK={
            __mainonly = {'auto_absorb','auto_dread_spikes','auto_endark'},
            auto_absorb = {enabled=false, name="Absorb-ACC"},
            auto_dread_spikes = false,
            auto_endark = false,
        },    
        BST={},
        BRD={
            __mainonly = {},
            song_loops = {},
        },
        RNG={},
        SMN={},
        SAM={},
        NIN={
            __mainonly = {'auto_myoshu','auto_migawari','auto_gekka','auto_yain','auto_kakka'},
            auto_utsusemi = false,
            auto_myoshu = false,
            auto_migawari = false,
            auto_gekka = false,
            auto_yain = false,
            auto_kakka = false,
        },    
        DRG={},    
        BLU={
            __mainonly = {},
            auto_haste = false,
        },    
        COR={
            __mainonly = {},
            auto_rolls = {enabled=false, max=2, roll_1="Chaos Roll", roll_2="Samurai Roll"},
            auto_double_up = {enabled=false, max=7},
        },    
        PUP={
            __mainonly = {'auto_maneuvers','auto_secondary_maneuvers'},
            auto_maneuvers = {enabled=false, maneuver_1="Fire Maneuver", maneuver_2="Light Maneuver", maneuver_3="Wind Maneuver"},
            auto_secondary_maneuvers = {enabled=false, maneuver_1="Fire Maneuver", maneuver_2="Light Maneuver", maneuver_3="Wind Maneuver", hpp=40},
        },    
        DNC={},    
        SCH={
            __mainonly = {'auto_storms'},
            auto_spikes = {enabled=false, name="Blaze Spikes"},
            auto_storms = {enabled=false, name="Firestorm"},
            auto_aquaveil = false,
            auto_blink = false,
            auto_stoneskin = false,
        },    
        GEO={
            __mainonly = {'auto_indicolure','auto_geocolure','auto_entrust'},
            auto_indicolure = {enabled=false, name="Indi-Fury"},
            auto_geocolure = {enabled=false, name="Indi-Fury"},
            auto_entrust = {enabled=false, name="Indi-Fury", target="Indi-Haste"},
        },    
        RUN={
            __mainonly = {'auto_temper','auto_crusade','auto_phalanx'},
            auto_spikes = {enabled=false, name="Blaze Spikes"},
            auto_runes = {enabled=false, rune_1="Ignis", rune_2="Ignis", rune_3="Ignis"},
            auto_aquaveil = false,
            auto_blink = false,
            auto_stoneskin = false,
            auto_temper = false,
            auto_foil = false,
            auto_refresh = false,
            auto_phalanx = false,
            auto_regen = false,
            auto_crusade = false,
        },

    }

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:check(base):update()

    end

    -- Public Methods.
    o.get = function(k)
        return settings:get(k)

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and (string.match(command, 'buffs/%a%a%a%a%a%a')) then

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