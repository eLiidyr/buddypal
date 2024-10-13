local function lib(bp)
    local o = {}

    -- Private Variables.
    local song_debuff_ids   = T{2,14,43,192,217}
    local song_buff_ids     = T(T(bp.res.spells):map(function(spell) return spell and spell.status and spell.type == 'BardSong' and not song_debuff_ids:contains(spell.status) and spell.status or nil end))
    local loops             = T{}
    local priority          = 195
    local maps              = {

        dummies = {

            ["Paeon"]       = {"",""},
            ["Operetta"]    = {"",""},

        },
        complex = {
            
            ["march"]       = {count=1, songs={"Honor March","Victory March","Advancing March"}},
            ["min"]         = {count=1, songs={"Valor Minuet V","Valor Minuet IV","Valor Minuet III","Valor Minuet II","Valor Minuet"}},
            ["mad"]         = {count=1, songs={"Blade Madrigal","Sword Madrigal"}},
            ["prelude"]     = {count=1, songs={"Archer's Prelude","Hunter's Prelude"}},
            ["minne"]       = {count=1, songs={"Knight's Minne V","Knight's Minne IV","Knight's Minne III","Knight's Minne II","Knight's Minne"}},
            ["ballad"]      = {count=1, songs={"Mage's Ballad III","Mage's Ballad II","Mage's Ballad"}},
            ["mambo"]       = {count=1, songs={"Dragonfoe Mambo","Sheepfoe Mambo"}},
            ["str"]         = {count=1, songs={"Herculean Etude","Sinewy Etude"}},
            ["dex"]         = {count=1, songs={"Uncanny Etude","Dextrous Etude"}},
            ["vit"]         = {count=1, songs={"Vital Etude","Vivacious Etude"}},
            ["agi"]         = {count=1, songs={"Swift Etude","Quick Etude"}},
            ["int"]         = {count=1, songs={"Sage Etude","Learned Etude"}},
            ["mnd"]         = {count=1, songs={"Logical Etude","Spirited Etude"}},
            ["chr"]         = {count=1, songs={"Bewitching Etude","Enchanting Etude"}},
            ["fire"]        = {count=1, songs={"Fire Carol","Fire Carol II"}},
            ["ice"]         = {count=1, songs={"Ice Carol","Ice Carol II"}},
            ["wind"]        = {count=1, songs={"Wind Carol","Wind Carol II"}},
            ["earth"]       = {count=1, songs={"Earth Carol","Earth Carol II"}},
            ["thunder"]     = {count=1, songs={"Lightning Carol","Lightning Carol II"}},
            ["water"]       = {count=1, songs={"Water Carol","Water Carol II"}},
            ["light"]       = {count=1, songs={"Light Carol","Light Carol II"}},
            ["dark"]        = {count=1, songs={"Dark Carol","Dark Carol II"}},
            ["aria"]        = {count=1, songs={"Aria of Passion"}},

        },
        specific = {
            
            ["req1"]      = "Foe Requiem",          ["req2"]        = "Foe Requiem II",        ["req3"]      = "Foe Requiem III",      ["req4"]      = "Foe Requiem IV",
            ["req5"]      = "Foe Requiem V",        ["req6"]        = "Foe Requiem VI",        ["req7"]      = "Foe Requiem VII",      ["lull1"]     = "Foe Lullaby",
            ["lull2"]     = "Foe Lullaby II",       ["horde1"]      = "Horde Lullaby",         ["horde2"]    = "Horde Lullaby II",     ["army1"]     = "Army's Paeon",
            ["army2"]     = "Army's Paeon II",      ["army3"]       = "Army's Paeon III",      ["army4"]     = "Army's Paeon IV",
            ["army5"]     = "Army's Paeon V",       ["army6"]       = "Army's Paeon VI",       ["ballad1"]   = "Mage's Ballad",        ["ballad2"]   = "Mage's Ballad II",
            ["ballad3"]   = "Mage's Ballad III",    ["minne1"]      = "Knight's Minne",        ["minne2"]    = "Knight's Minne II",
            ["minne3"]    = "Knight's Minne III",   ["minne4"]      = "Knight's Minne IV",     ["minne5"]    = "Knight's Minne V",
            ["min1"]      = "Valor Minuet",         ["min2"]        = "Valor Minuet II",       ["min3"]      = "Valor Minuet III",     ["min4"]      = "Valor Minuet IV",
            ["min5"]      = "Valor Minuet V",       ["mad1"]        = "Sword Madrigal",        ["mad2"]      = "Blade Madrigal",
            ["lude1"]     = "Hunter's Prelude",     ["lude2"]       = "Archer's Prelude",      ["mambo1"]    = "Sheepfoe Mambo",       ["mambo2"]    = "Dragonfoe Mambo",
            ["herb1"]     = "Herb Pastoral",        ["shining1"]    = "Shining Fantasia",      ["oper1"]     = "Scop's Operetta",      ["oper2"]     = "Puppet's Operetta",
            ["gold1"]     = "Gold Capriccio",       ["round1"]      = "Warding Round",         ["gob1"]      = "Goblin Gavotte",       ["march1"]    = "Advancing March",
            ["march2"]    = "Victory March",        ["hm"]          = "Honor March",           ["elegy1"]    = "Battlefield Elegy",    ["elegy2"]    = "Carnage Elegy",
            ["str1"]      = "Sinewy Etude",         ["str2"]        = "Herculean Etude",       ["dex1"]      = "Dextrous Etude",       ["dex2"]      = "Uncanny Etude",
            ["vit1"]      = "Vivacious Etude",      ["vit2"]        = "Vital Etude",           ["agi1"]      = "Quick Etude",          ["agi2"]      = "Swift Etude",
            ["int1"]      = "Learned Etude",        ["int2"]        = "Sage Etude",            ["mnd1"]      = "Spirited Etude",       ["mnd2"]      = "Logical Etude",
            ["chr1"]      = "Enchanting Etude",     ["chr2"]        = "Bewitching Etude",      ["firec1"]    = "Fire Carol",           ["firec2"]    = "Fire Carol II",
            ["icec1"]     = "Ice Carol",            ["icec2"]       = "Ice Carol II",          ["windc1"]    = "Wind Carol",           ["windc2"]    = "Wind Carol II",
            ["earthc1"]   = "Earth Carol",          ["earthc2"]     = "Earth Carol II",        ["thunderc1"] = "Lightning Carol",      ["thunderc2"] = "Lightning Carol II",
            ["waterc1"]   = "Water Carol",          ["waterc2"]     = "Water Carol II",        ["lightc1"]   = "Light Carol",          ["lightc2"]   = "Light Carol II",
            ["darkc1"]    = "Dark Carol",           ["darkc2"]      = "Dark Carol II",         ["firet1"]    = "Fire Threnody",        ["firet2"]    = "Fire Threnody II",
            ["icet1"]     = "Ice Threnody",         ["icet2"]       = "Ice Threnody II",       ["windt1"]    = "Wind Threnody",        ["windt2"]    = "Wind Threnody II",
            ["eartht1"]   = "Earth Threnody",       ["eartht2"]     = "Earth Threnody II",     ["thundt1"]   = "Lightning Threnody",   ["thundt2"]   = "Lightning Threnody II",
            ["watert1"]   = "Water Threnody",       ["watert2"]     = "Water Threnody II",     ["lightt1"]   = "Light Threnody",       ["lightt2"]   = "Light Threnody II",
            ["darkt1"]    = "Dark Threnody",        ["darkt2"]      = "Dark Threnody II",      ["finale"]    = "Magic Finale",         ["ghym"]      = "Goddess's Hymnus",
            ["scherzo"]   = "Sentinel's Scherzo",   ["pining"]      = "Pining Nocturne",       ["zurka1"]    = "Raptor Mazurka",       ["zurka2"]    = "Chocobo Mazurka",
            ["fi1"]       = "Fire Carol",           ["fi2"]         = "Fire Carol II",         ["ic1"]       = "Ice Carol",            ["ic2"]       = "Ice Carol II",
            ["wi1"]       = "Wind Carol",           ["wi2"]         = "Wind Carol II",         ["ea1"]       = "Earth Carol",          ["ea2"]       = "Earth Carol II",
            ["th1"]       = "Lightning Carol",      ["th2"]         = "Lightning Carol II",    ["wa1"]       = "Water Carol",          ["wa2"]       = "Water Carol II",
            ["li1"]       = "Light Carol",          ["li2"]         = "Light Carol II",        ["da1"]       = "Dark Carol",           ["da2"]       = "Dark Carol II",
            ["dirg"]      = "Adventurer's Dirge",   ["dirge"]       = "Adventurer's Dirge",    ["sirv"]      = "Foe Sirvente",         ["sirvente"]  = "Foe Sirvente",

        }

    }

    -- Public Variables.

    -- Private Methods.
    local function getSongTarget(t)
        local target = (t[#t] and t[#t]:sub(1, 1) == '*') and bp.__target.get(table.remove(t, #t):sub(2)) or nil

        if target then
            target.pianissimo = true
            return target

        end
        return {id=bp.__player.id(), pianissimo=false}

    end

    local function buildSongs(songs, target)
        local max = o.getMaxSongsAllowed() -- clarion should adjust this number before finalizing.
        local songs_list = T{}

        if not songs or songs:length() == 0 then
            return nil

        end

        -- Reset priority position if no songs are queued.
        if not bp.queue.hasType('BardSong') then
            o.resetPriority(195)

        end

        do
            local complex_map = o.getComplexMap()
            local actions = o.newSongs()

            if bp.actions.canCast() and bp.actions.canAct() then

                if bp.abilities.get('auto_soul_voice') then
                    bp.queue.add('Soul Voice', bp.__player.get(), 199)
        
                end
        
                if bp.abilities.get('auto_clarion_call') then
                    bp.queue.add('Clarion Call', bp.__player.get(), 199)
        
                    if bp.queue.search("Clarion Call") or o.getSongCount() == (max + 1) then
                        max = (max + 1)
                        bp.toChat("Song count modified to:", 170, tostring(max), 217)
        
                    end
                
                end
        
                if bp.abilities.get('auto_nightingale') then
                    bp.queue.add('Nightingale', bp.__player.get(), 199)
                
                end
        
                if bp.abilities.get('auto_troubadour') then
                    bp.queue.add('Troubadour', bp.__player.get(), 199)
                
                end

                for i=1, max do
                    local song = songs[i]
                    local complex = complex_map[song]
    
                    if song and complex then
    
                        -- Adjust march if the user doesn't have Honor March.
                        if song == 'march' and complex.count == 1 and not o.hasHonorMarch() then
                            complex.count = (complex.count + 1)
    
                        end
    
                        if T{1,2}:contains(i) then
                            actions:addSong(complex.songs[complex.count], target)
    
                        elseif i == 3 and (bp.__buffs.active(499) or bp.queue.search("Clarion Call") or o.getSongCount() == max) then
                            actions:addSong(complex.songs[complex.count], target)
    
                        elseif i == 3 then
                            actions:addSong(complex.songs[complex.count], target, 1)
    
                        elseif i == 4 and (bp.__buffs.active(499) or bp.queue.search("Clarion Call") or o.getSongCount() == max) then
                            actions:addSong(complex.songs[complex.count], target, 1)
    
                        elseif i == 4 then
                            actions:addSong(complex.songs[complex.count], target, 2)
    
                        elseif i == 5 and (bp.__buffs.active(499) or bp.queue.search("Clarion Call") or o.getSongCount() == max) then
                            actions:addSong(complex.songs[complex.count], target, 2)
    
                        end
                        complex.count = (complex.count + 1)
    
                    end
    
                end
                return actions

            end

        end

    end

    -- Public Methods.
    o.getSongCount = function()
        return T(T(bp.__player.buffs()):map(function(id) return song_buff_ids:contains(id) end)):length()

    end

    o.getPlayerSongCount = function(buffs)

    end

    o.getMaxSongsAllowed = function()
        local count = 2
        local type = type

        for bag in bp.__inventory.equippable():it() do

            for item, index in T(bp.items(bag.id)):it() do

                if type(item) == 'table' and item.id and item.status and S{0,5}:contains(item.status) and S{18575,18576,21400,21401,21407,22306}:contains(item.id) and count == 2 then
                    count = 3

                elseif type(item) == 'table' and item.id and item.status and S{0,5}:contains(item.status) and S{18839,18571,22307}:contains(item.id) then
                    return 4

                end

            end

        end
        return count

    end

    o.hasHonorMarch = function()
        return bp.__inventory.canEquip("Marsyas")
    
    end

    o.getLoops = function()
        return loops:copy()

    end

    o.clearLoops = function()
        loops = T{}

    end

    o.getDummies = function()
        local singing = bp.buffs.get('auto_singing')

        if singing and singing.dummies then
            return singing.dummies

        end
        return nil

    end

    o.getComplexMap = function(key)
        return T(maps.complex):copy()

    end

    o.getSpecificSong = function(key)
        return maps.specific[key] or nil

    end

    o.getPriority = function()
        return priority

    end

    o.setPriority = function(n)
        if not tonumber(n) then
            return

        end
        priority = tonumber(n)
        return priority

    end

    o.resetPriority = function()
        priority = 195

    end

    o.newSongs = function()
        local so = {list=T{}}

        function so:addSong(song, target, dummy_index)
            local dummies = o.getDummies()
            local player = bp.__player.get()

            if song and target then

                if player.id ~= target.id and target.pianissimo and song and dummies and dummy_index and dummies[dummy_index] then
                    table.insert(self.list, {action='Pianissimo', target=player.id})
                    table.insert(self.list, {action=dummies[dummy_index], target=target.id})
                    table.insert(self.list, {action='Pianissimo', target=player.id})
                    table.insert(self.list, {action=song, target=target.id})

                elseif player.id ~= target.id and target.pianissimo and song and not dummy_index then
                    table.insert(self.list, {action='Pianissimo', target=player.id})
                    table.insert(self.list, {action=song, target=target.id})
    
                elseif player.id == target.id and song and dummies and dummy_index and dummies[dummy_index] then
                    local dummy = dummies[dummy_index]
    
                    if target.pianissimo then
                        table.insert(self.list, {action='Pianissimo', target=player.id})
                        table.insert(self.list, {action=dummies[dummy_index], target=player.id})
                        table.insert(self.list, {action=song, target=player.id})
    
                    else
                        table.insert(self.list, {action=dummies[dummy_index], target=player.id})
                        table.insert(self.list, {action=song, target=player.id})
    
                    end
    
                elseif player.id == target.id and song and not dummy_index then
    
                    if target.pianissimo then
                        table.insert(self.list, {action='Pianissimo', target=player.id})
                        table.insert(self.list, {action=song, target=player.id})
    
                    else
                        table.insert(self.list, {action=song, target=player.id})
    
                    end

                end

            end

        end

        function so:handle()
            local max = o.getMaxSongsAllowed() -- clarion should adjust this number before finalizing.

            if bp.actions.canCast() and bp.actions.canAct() then

                for item in self.list:it() do
                    
                    bp.queue.add(item.action, item.target, priority)
                    priority = (priority - 1)

                end

            end

        end
        return so

    end

    o.sing_manually = function(commands)
        local target = getSongTarget(commands)
        local actions = buildSongs(commands, target)

        if actions then
            actions:handle()

        end

    end

    -- Private Events.

    return o

end
return lib