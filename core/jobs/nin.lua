local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Ninja Tools.
    local __tools = {}
    __tools.get = function(name) return name and __tools[name] or "" end
    __tools["Mono"] = {cast={"Shikanofuda","Sanjaku-Tenugui"},  toolbags={"Toolbag (Shika)","Toolbag (Sanja)"}}
    __tools["Aish"] = {cast={"Chonofuda","Soshi"},              toolbags={"Toolbag (Cho)","Toolbag (Soshi)"}}
    __tools["Kato"] = {cast={"Inoshishinofuda","Uchitake"},     toolbags={"Toolbag (Ino)","Toolbag (Uchi)"}}
    __tools["Hyot"] = {cast={"Inoshishinofuda","Tsurara"},      toolbags={"Toolbag (Ino)","Toolbag (Tsura)"}}
    __tools["Huto"] = {cast={"Inoshishinofuda","Kawahori-Ogi"}, toolbags={"Toolbag (Ino)","Toolbag (Kawa)"}}
    __tools["Doto"] = {cast={"Inoshishinofuda","Makibishi"},    toolbags={"Toolbag (Ino)","Toolbag (Maki)"}}
    __tools["Rait"] = {cast={"Inoshishinofuda","Hiraishin"},    toolbags={"Toolbag (Ino)","Toolbag (Hira)"}}
    __tools["Suit"] = {cast={"Inoshishinofuda","Mizu-Deppo"},   toolbags={"Toolbag (Ino)","Toolbag (Mizu)"}}
    __tools["Utsu"] = {cast={"Shikanofuda","Shihei"},           toolbags={"Toolbag (Shika)","Toolbag (Shihe)"}}
    __tools["Juba"] = {cast={"Chonofuda","Jusatsu"},            toolbags={"Toolbag (Cho)","Toolbag (Jusa)"}}
    __tools["Hojo"] = {cast={"Chonofuda","Kaginawa"},           toolbags={"Toolbag (Cho)","Toolbag (Kagi)"}}
    __tools["Kura"] = {cast={"Chonofuda","Sairui-Ran"},         toolbags={"Toolbag (Cho)","Toolbag (Sai)"}}
    __tools["Doku"] = {cast={"Chonofuda","Kodoku"},             toolbags={"Toolbag (Cho)","Toolbag (Kodo)"}}
    __tools["Tonk"] = {cast={"Shikanofuda","Shinobi-Tabi"},     toolbags={"Toolbag (Shika)","Toolbag (Shino)"}}
    __tools["Gekk"] = {cast={"Shikanofuda","Ranka"},            toolbags={"Toolbag (Shika)","Toolbag (Ranka)"}}
    __tools["Yain"] = {cast={"Shikanofuda","Furusumi"},         toolbags={"Toolbag (Shika)","Toolbag (Furu)"}}
    __tools["Myos"] = {cast={"Shikanofuda","Kabenro"},          toolbags={"Toolbag (Shika)","Toolbag (Kaben)"}}
    __tools["Yuri"] = {cast={"Chonofuda","Jinko"},              toolbags={"Toolbag (Cho)","Toolbag (Jinko)"}}
    __tools["Kakk"] = {cast={"Shikanofuda","Ryuno"},            toolbags={"Toolbag (Shika)","Toolbag (Ryuno)"}}
    __tools["Miga"] = {cast={"Shikanofuda","Mokujin"},          toolbags={"Toolbag (Shika)","Toolbag (Moku)"}}

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then

            -- MIKAGE.
            if bp.core.get('mikage') and bp.core.ready("Mikage", 502) then
                bp.queue.add("Mikage", player)
            
            end

        end

        return self

    end

    function self:abilities()
        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.core.get('job-abilities') and bp.actions.canAct() then

                    -- YONIN.
                    if bp.core.get('yonin') and bp.core.ready("Yonin", 420) and bp.actions.isFacing(target) then
                        bp.queue.add("Yonin", player)

                    -- INNIN.
                    elseif bp.core.get('innin') and bp.core.ready("Innin", 421) and bp.actions.isBehind(target) then
                        bp.queue.add("Innin", player)

                    -- SANGE.
                    elseif bp.core.get('sange') and bp.core.ready("Sange", 352) then
                        bp.queue.add("Sange", player)

                    -- ISSEKIGAN.
                    elseif bp.core.get('issekigan') and bp.core.ready("Issekigan", 484) then
                        bp.queue.add("Issekigan", player)

                    end

                end

                if bp.actions.canCast() then

                    -- UTSUSEMI.
                    if bp.core.get('utsusemi') then
                        local tools = bp.__inventory.findByName(__tools.get("Utsu").cast, 0)

                        if tools and #tools > 0 then
                            local index, count, id, status, bag, res = table.unpack(tools[1])
                        
                            if index and status and status == 0 and count > 0 and not bp.queue.search('Utsusemi') then
                                
                                if bp.core.isReady("Utsusemi: San") and not bp.__buffs.hasShadows(1) then
                                    bp.queue.add("Utsusemi: San", player)
            
                                elseif bp.core.isReady("Utsusemi: Ni") and not bp.__buffs.hasShadows(0) then
                                    bp.queue.add("Utsusemi: Ni", player)
                                        
                                elseif bp.core.isReady("Utsusemi: Ichi") and not bp.__buffs.hasShadows(0) then
                                    bp.queue.add("Utsusemi: Ichi", player)

                                end

                            end

                        elseif not tools then
                            local toolbags = bp.__inventory.findByName(__tools.get("Utsu").toolbags, 0)

                            if toolbags and #toolbags > 0 then
                                local index, count, id, status, bag, res = table.unpack(toolbags[1])
                                
                                if index and status and status == 0 and count > 0 and bp.res.items[id] and not bp.core.inQueue(bp.res.items[id], player) then
                                    bp.queue.add(bp.res.items[id], player)

                                end

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- YONIN.
                    if bp.core.get('yonin') and bp.core.ready("Yonin", 420) and bp.actions.isFacing(target) then
                        bp.queue.add("Yonin", player)

                    -- INNIN.
                    elseif bp.core.get('innin') and bp.core.ready("Innin", 421) and bp.actions.isBehind(target) then
                        bp.queue.add("Innin", player)

                    -- SANGE.
                    elseif bp.core.get('sange') and bp.core.ready("Sange", 352) then
                        bp.queue.add("Sange", player)

                    -- ISSEKIGAN.
                    elseif bp.core.get('issekigan') and bp.core.ready("Issekigan", 484) then
                        bp.queue.add("Issekigan", player)

                    end

                end

                if bp.actions.canCast() then

                    -- UTSUSEMI.
                    if bp.core.get('utsusemi') then
                        local tools = bp.__inventory.findByName(__tools.get("Utsu").cast, 0)

                        if tools and #tools > 0 then
                            local index, count, id, status, bag, res = table.unpack(tools[1])
                        
                            if index and status and status == 0 and count > 0 and not bp.queue.search('Utsusemi') then
                                
                                if bp.core.isReady("Utsusemi: San") and not bp.__buffs.hasShadows(1) then
                                    bp.queue.add("Utsusemi: San", player)
            
                                elseif bp.core.isReady("Utsusemi: Ni") and not bp.__buffs.hasShadows(0) then
                                    bp.queue.add("Utsusemi: Ni", player)
                                        
                                elseif bp.core.isReady("Utsusemi: Ichi") and not bp.__buffs.hasShadows(0) then
                                    bp.queue.add("Utsusemi: Ichi", player)

                                end

                            end

                        elseif not tools then
                            local toolbags = bp.__inventory.findByName(__tools.get("Utsu").toolbags, 0)

                            if toolbags and #toolbags > 0 then
                                local index, count, id, status, bag, res = table.unpack(toolbags[1])
                                
                                if index and status and status == 0 and count > 0 and bp.res.items[id] and not bp.core.inQueue(bp.res.items[id], player) then
                                    bp.queue.add(bp.res.items[id], player)

                                end

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()
        return self

    end

    function self:enmity()
        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('nuke-mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.ready(spell) then

                    if count > 1 and bp.core.get('futae') and bp.core.ready("Futae", 441) then
                        bp.queue.add("Futae", target)
                    
                    end
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load