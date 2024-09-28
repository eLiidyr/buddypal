local function lib(bp)
    local o = {}

    -- Private Variables.
    local level       = T{270,271,272}
    local levels      = T{270,271,272,273}
    local relics      = T{"Spharai","Mandau","Excalibur","Ragnarok","Guttler","Bravura","Apocalypse","Gungnir","Kikoku","Amanomurakumo","Mjollnir","Claustrum","Yoichinoyumi","Annihilator"}
    local aftermaths  = T{
        
        ["Verethragna"]         = "Victory Smite",
        ["Glanzfaust"]          = "Ascetic's Fury",
        ["Kenkonken"]           = "Stringing Pummel",
        ["Godhands"]            = "Shijin Spiral",
        ["Twashtar"]            = "Rudra's Storm",
        ["Vajra"]               = "Mandalic Stab",
        ["Carnwenhan"]          = "Mordant Rime",
        ["Terpsichore"]         = "Pyrrihic Kleos",
        ["Aeneas"]              = "Exenterator",
        ["Almace"]              = "Chant du Cygne",
        ["Burtgang"]            = "Atonement",
        ["Murgleis"]            = "Death Blossom",
        ["Tizona"]              = "Expiacion",
        ["Sequence"]            = "Requiescat",
        ["Caladbolg"]           = "Torcleaver",
        ["Epeolatry"]           = "Dimidiation",
        ["Lionheart"]           = "Resolution",
        ["Farsha"]              = "Cloudsplitter",
        ["Aymur"]               = "Primal Rend",
        ["Tri-edge"]            = "Ruinator",
        ["Ukonvasara"]          = "Ukko's Fury",
        ["Conqueror"]           = "King's Justice",
        ["Chango"]              = "Upheaval",
        ["Redemption"]          = "Quietus",
        ["Liberator"]           = "Insurgency",
        ["Anguta"]              = "Entropy",
        ["Rhongomiant"]         = "Camlann's Torment",
        ["Ryunohige"]           = "Drakesbane",
        ["Trishula"]            = "Stardiver",
        ["Kannagi"]             = "Blade: Hi",
        ["Nagi"]                = "Blade: Kamu",
        ["Heishi Shorinken"]    = "Blade: Shun",
        ["Masamune"]            = "Tachi: Fudo",
        ["Kogarasumaru"]        = "Tachi: Rana",
        ["Dojikiri Yasutsuna"]  = "Tachi: Shoha",
        ["Gambateinn"]          = "Dagan",
        ["Yagrush"]             = "Mystic Boon",
        ["Idris"]               = "Exudation",
        ["Tishtrya"]            = "Realmrazer",
        ["Hvergelmir"]          = "Myrkr",
        ["Laevteinn"]           = "Vidohunir",
        ["Nirvana"]             = "Garland of Bliss",
        ["Tupsimati"]           = "Omniscience",
        ["Khatvanga"]           = "Shattersoul",
        ["Gandiva"]             = "Jishnu's Radiance",
        ["Fail-not"]            = "Apex Arrow",
        ["Armageddon"]          = "Wildfire",
        ["Gastraphetes"]        = "Trueflight",
        ["Death Penalty"]       = "Leaden Salute",
        ["Fomalhaut"]           = "Last Stand",
        ["Spharai"]             = "Final Heaven",
        ["Mandau"]              = "Mercy Stroke",
        ["Excalibur"]           = "Kights of Round",
        ["Ragnarok"]            = "Scourge",
        ["Guttler"]             = "Onslaught",
        ["Bravura"]             = "Metatron Torment",
        ["Apocalypse"]          = "Catastrophe",
        ["Gungnir"]             = "Geirskogul",
        ["Kikoku"]              = "Blade: Metsu",
        ["Amanomurakumo"]       = "Tachi: Kaiten",
        ["Mjollnir"]            = "Randgrith",
        ["Claustrum"]           = "Gates of Tartarus",
        ["Yoichinoyumi"]        = "Namas Arrow",
        ["Annihilator"]         = "Coronach",
        
    }

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.
    o.weaponskill = function(weapon)
        return weapon and aftermaths[weapon] or false
    
    end

    o.active = function()
        
        for id in bp.__player.buffs():it() do
                    
            if levels:contains(id) then
                return true
            end
            
        end
        return false

    end

    o.canReplace = function()
        if not bp.combat.get('auto_aftermath') then
            return false
        
        end

        for id in bp.__player.buffs():it() do

            if levels:contains(id) then
                local aftermath = bp.combat.get('auto_aftermath')
                local level = level[id]

                if aftermath and level and aftermath.level > level then
                    return true

                end

            end

        end

    end

    o.getWeapon = function()

        if T{'COR','RNG'}:contains(bp.__player.mjob()) then
            return bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)

        else
            return bp.__inventory.getByIndex(bp.__equipment.get(0).bag, bp.__equipment.get(0).index)

        end
        return nil

    end

    o.getAvailable = function()
        local available = {}

        for slot in S{0,2}:it() do
            local index, _, _, _, _, resource = bp.__inventory.getByIndex(bp.__equipment.get(slot).bag, bp.__equipment.get(slot).index)

            if index and resource and aftermaths[resource.en] then
                table.insert(available, aftermaths[resource.en])

            end

        end
        return available

    end

    -- Private Events.

    return o

end
return lib