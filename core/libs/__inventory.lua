local function lib(bp)
    local o = {}

    -- Private Variables.
    local attachments = {"Accelerator", "Accelerator II", "Accelerator III", "Accelerator IV", "Amplifier", "Amplifier II", "Analyzer", "Arcanic Cell", "Arcanic Cell II", "Arcanoclutch", "Arcanoclutch II", "Armor Plate", "Armor Plate II", "Armor Plate III", "Armor Plate IV", "Attuner", "Auto-Rep. Kit II", "Auto-Rep. Kit III", "Auto-Rep. Kit IV", "Auto-Repair Kit", "Barrage Turbine", "Barrier Module", "Barrier Module II", "Coiler", "Coiler II", "Condenser", "Damage Gauge", "Damage Gauge II", "Disruptor", "Drum Magazine", "Dynamo", "Dynamo II", "Dynamo III", "Economizer", "Equalizer", "Eraser", "Flame Holder", "Flashbulb", "Galvanizer", "Hammermill", "Harlequin Frame", "Harlequin Head", "Heat Capacitor", "Heat Capacitor II", "Heat Seeker", "Heatsink", "Ice Maker", "Inhibitor", "Inhibitor II", "Loudspeaker", "Loudspeaker II", "Loudspeaker III", "Loudspeaker IV", "Loudspeaker V", "Magniplug", "Magniplug II", "Mana Booster", "Mana Channeler", "Mana Channeler II", "Mana Conserver", "Mana Converter", "Mana Jammer", "Mana Jammer II", "Mana Jammer III", "Mana Jammer IV", "Mana Tank", "Mana Tank II", "Mana Tank III", "Mana Tank IV", "Optic Fiber", "Optic Fiber II", "Pattern Reader", "Percolator", "Power Cooler", "Reactive Shield", "Regulator", "Repeater", "Replicator", "Resister", "Resister II", "Scanner", "Schurzen", "Scope", "Scope II", "Scope III", "Scope IV", "Sharpshot Frame", "Sharpshot Head", "Shock Absorber", "Shock Absorber II", "Shock Absorber III", "Smoke Screen", "Soulsoother Head", "Speedloader", "Speedloader II", "Spiritreaver Head", "Stabilizer", "Stabilizer II", "Stabilizer III", "Stabilizer IV", "Stabilizer V", "Stealth Screen", "Stealth Screen II", "Steam Jacket", "Stormwaker Frame", "Stormwaker Head", "Strobe", "Strobe II", "Tact. Processor", "Target Marker", "Ten. Spring II", "Ten. Spring III", "Ten. Spring IV", "Ten. Spring V", "Tension Spring", "Tranquilizer", "Tranquilizer II", "Tranquilizer III", "Tranquilizer IV", "Truesights", "Turbo Charger", "Turbo Charger II", "Valoredge Frame", "Valoredge Head", "Vivi-Valve", "Vivi-valve II", "Volt Gun"}
    local inventory   = {gil=0, slots=T{}}
    local items       = {}
    local bags        = {}

    -- Public Variables.

    -- Private Methods.
    local function getBagType(access, equippable)
        return S(bp.res.bags):filter(function(key) return (key.access == access and key.equippable == equippable) or key.id == 0 and key end)
        
    end

    local function update(id, original)
        if not S{0x020,0x01e,0x01f,0x0d2}:contains(id) then return false end
        local parsed    = bp.packets.parse('incoming', original)
        local bazaar    = parsed['Bazaar']
        local status    = parsed['Status']
        local index     = parsed['Index']
        local item      = parsed['Item']
        local count     = parsed['Count']
        local bag       = parsed['Bag']

        if id == 0x020 then

            if bag == 0 and index == 0 then
                inventory.gil = count
                return false

            end

            if bp.res.items[item] then
                local res = bp.res.items[item]
                local item = T{id=item, index=index, bag=bag, status=status, bazaar=bazaar, count=count, en=res.en, enl=res.enl}

                if count > 0 then
                
                    if inventory.slots[bag] then
                        inventory.slots[bag][index] = item
                        return false
                    
                    end
                    
                    inventory.slots[bag] = T{[index]=item}
                    return false
                    

                else

                    if inventory.slots[bag] then
                        inventory.slots[bag][index] = nil
                        return false
                    
                    end
                    
                    inventory.slots[bag] = T{}
                    return false

                end

            end

        elseif id == 0x01e then

            if bag == 0 and index == 0 then
                inventory.gil = count
                return false

            end

            if bp.res.items[item] then
                local res = bp.res.items[item]
                local item = T{id=item, index=index, bag=bag, status=status, bazaar=bazaar, count=count, en=res.en, enl=res.enl}
                
                if item then

                    if inventory.slots[bag] then
                        inventory.slots[bag][index] = item
                        return false

                    end
                        
                    inventory.slots[bag] = T{[index]=item}
                    return false
                    
                end

            end

        elseif id == 0x01f then

            if bag == 0 and index == 0 then
                inventory.gil = count

            elseif bp.res.items[item] then
                local res = bp.res.items[item]
                local item = T{id=item, index=index, bag=bag, status=status, bazaar=bazaar, count=count, en=res.en, enl=res.enl}
                
                if item then

                    if inventory.slots[bag] then
                        inventory.slots[bag][index] = item
                        return false

                    end
                    
                    inventory.slots[bag] = T{[index]=item}
                    return false
                    
                end

            end

        elseif id == 0x0d2 and parsed then

        end

    end

    -- Public Methods.
    o.get = function(search, slot)
        if (not search or not slot or not inventory.slots[slot] or inventory.slots[slot]:empty()) then return nil end
        local bag = inventory.slots[slot]

        if type(search) == 'table' and search.index then
            local index, item = bag:find(function(item) return item.index == search.index end)

            if index and item then
                return item

            end

        elseif type(search) == 'number' or (type(search) == 'string' and tonumber(search)) then
            local index, item = bag:find(function(item) return S{item.id, item.index}:contains(search) end)

            if index and item then
                return item

            end

        elseif type(search) == 'string' and not tonumber(search) then
            local index, item = bag:find(function(item) return S{item.en, item.enl}:contains(search) end)

            if index and item then
                return item

            end

        end
        return nil

    end

    o.lot = function(slot)
        if not slot then return end
        bp.packets.inject(bp.packets.new('outgoing', 0x041, {['Slot']=slot}))

    end

    o.pass = function(slot)
        if not slot then return end
        bp.packets.inject(bp.packets.new('outgoing', 0x042, {['Slot']=slot}))

    end

    o.drop = function(index, count)
        if not (index or count) then return end
        bp.packets.inject(bp.packets.new('outgoing', 0x028, {['Bag']=0, ['Count']=count, ['Inventory Index']=index}))

    end

    o.equippable = function()
        return bags.equippable:copy()

    end

    o.getBags = function(region, equippable)
        return getBagType(region, equippable)
    
    end

    o.hasKeyItem = function(id)
        if not id then return false end
        local fetchki = windower.ffxi.get_key_items

        if type(id) == 'table' then
            local list = S(id)

            for ki in T(fetchki()):it() do

                if list:contains(ki) then
                    return true
                    
                end

            end

        else
            
            for ki in T(fetchki()):it() do

                if ki == id then
                    return true

                end
            
            end

        end
        return false
        
    end

    o.getByIndex = function(bag, index)
        local item = windower.ffxi.get_items(bag, index)

        if item then
            return index, item.count, item.id, item.status, bag, bp.res.items[item.id]

        end

    end

    o.getExtdata = function(search)

        for item, index in T(windower.ffxi.get_items(0)):it() do
            
            if type(item) == 'table' and item.id and item.extdata and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                return bp.extdata.decode(item)

            end

        end
        return nil

    end

    o.findItem = function(search)

        for bag in T(bags.equippable):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    return bag.id, index, item.id, item.status

                end

            end

        end
        return nil

    end

    o.findByName = function(search, bag)
        local items = T{}

        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if bp.res.items[item.id].en:lower():startswith(compare:lower()) then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})
                        
                    end

                end
            elseif type(search) == 'string' and type(item) == 'table' then

                if item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]

                end

            end

        end
        return items and #items > 0 and items or false

    end

    o.findByIndex = function(search, bag)
        local items = {}
        
        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if index == compare then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})

                    end

                end

            elseif (type(search) == 'number' or tonumber(search) ~= nil) then
                local search = tonumber(search)

                if type(item) == 'table' and item.id and bp.res.items[item.id] and index == search then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]

                end

            end

        end
        return items and #items > 0 and items or false

    end

    o.findByID = function(search, bag)
        local items = {}
        
        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if item.id == compare then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})

                    end

                end

            elseif (type(search) == 'number' or tonumber(search) ~= nil) then

                if type(item) == 'table' and item.id and bp.res.items[item.id] and item.id == tonumber(search) then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]

                end

            end

        end
        return items and #items > 0 and items or false

    end

    o.findUsable = function()
        local items = {}
        
        for item, index in T(windower.ffxi.get_items(0)):it() do
                
            if type(item) == 'table' and item.id and item.status and item.status == 0 and bp.res.items[item.id] and bp.res.items[item.id].flags and bp.res.items[item.id].flags:contains('Usable') then
                table.insert(items, {index=index, count=item.count, status=item.status, bag=0, res=bp.res.items[item.id]})

            end

        end
        return items

    end

    o.findScrolls = function()
        local all = bp.spells()
        local scrolls = {}
        
        for item, index in T(windower.ffxi.get_items(0)):it() do
                
            if type(item) == 'table' and item.id and item.status and item.status == 0 and bp.res.items[item.id] and bp.res.items[item.id].flags then
                local spell = bp.__res.get(bp.res.items[item.id].en)

                if spell and not bp.__player.hasSpell(spell.id) and spell.levels and (spell.levels[bp.__player.mid()] or spell.levels[bp.__player.sid()]) then
                    table.insert(scrolls, {index=index, count=item.count, status=item.status, bag=0, res=bp.res.items[item.id]})

                end

            end

        end
        return scrolls

    end

    o.findAttachments = function()
        local attachments = {}
        
        for item, index in T(windower.ffxi.get_items(0)):it() do

            if type(item) == 'table' and item.id and item.status and item.status == 0 and bp.res.items[item.id] and S(attachments):contains(bp.res.items[item.id].en) then
                table.insert(attachments, {index=index, id=item.id, res=bp.res.items[item.id]})

            end

        end
        return attachments

    end

    o.hasScrolls = function()
        local scrolls = bp.__inventory.findScrolls()

        if scrolls and #scrolls > 0 then
            return true
        
        end
        return false

    end

    o.getAmount = function(search, bag)
        return T(windower.ffxi.get_items(bag or 0)):filter(function(item) return type(item) == 'table' and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) and item end):length()

    end

    o.getCount = function(search, bag)
        local count = 0

        if type(search) == 'table' then
            return T(search):map(function(item) return item[2] and item[2] end):sum()

        else

            for item, index in T(windower.ffxi.get_items(bag or 0)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    count = (count + item.count)

                end

            end

        end
        return count

    end

    o.getTotal = function(search)
        local count = 0

        for bag in T(bags.storeable):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    count = (count + item.count)

                end

            end

        end
        return count

    end

    o.hasSpace = function(bag)
        return windower.ffxi.get_bag_info(bag or 0).count < windower.ffxi.get_bag_info(bag or 0).max and true or false

    end

    o.getSpace = function(bag)
        local bag = windower.ffxi.get_bag_info(bag or 0)

        if bag.count < bag.max then
            return (bag.max - bag.count)
            
        end
        return 0

    end

    o.ownsItems = function(search)
        local items = T{}

        for bag in T(bp.res.bags):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do

                if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] and S(search):contains(bp.res.items[item.id].en) then
                    items[bp.res.items[item.id].en] = true

                end

            end
            
        end
        return items

    end

    o.inInventory = function(search)

        if type(search) == 'table' and T(search):isarray() then

            for item, index in T(windower.ffxi.get_items(0)):it() do
                local res = bp.res.items[item.id]
                    
                if type(item) == 'table' and item.id and res and (search:contains(item.en:lower()) or search:contains(item.enl:lower())) then
                    return true

                end

            end

        elseif type(search) == 'string' then

            for item, index in T(windower.ffxi.get_items(0)):it() do
                local res = bp.res.items[item.id]
                    
                if type(item) == 'table' and item.id and res and S{res.en:lower(), res.enl:lower()}:contains(search:lower()) then
                    return true

                end

            end

        end
        return false

    end

    o.isEquippable = function(bag)
        return T(bags.equippable):contains(bag)
    
    end

    o.canEquip = function(search)

        for bag in T(bags.equippable):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    return true

                end

            end

        end
        return false

    end

    o.equipItems = function(list)
        local slots = {main=0,sub=1,range=2,ammo=3,head=4,body=5,hands=6,legs=7,feet=8,neck=9,waist=10,lear=11,rear=12,lring=13,rring=14,back=15}
        
        if list and type(list) == 'table' then

            for slot, name in pairs(list) do
                local index, count, id, status, bag, res = o.findByName(name)
            
                if index and status and bag and status == 0 and slots[slot] then
                    windower.ffxi.set_equip(index, slots[slot], bag)
                    
                end

            end

        end

    end

    o.sellItems = function(list)
        local list = list and T(list) or false

        if list and list:length() > 0 then
            local queue = {}
            
            for index=1, 80 do
                local item = windower.ffxi.get_items(0, index)

                if item and item.id and item.status and item.status == 0 and bp.res.items[item.id] and list:contains(bp.res.items[item.id].en) and not bp.res.items[item.id].flags:contains("No NPC Sale") then
                    table.insert(queue, function()
                        bp.packets.inject(bp.packets.new('outgoing', 0x084, {['Count']=item.count, ['Item']=item.id, ['Inventory Index']=index}))
                        bp.packets.inject(bp.packets.new('outgoing', 0x085))
                    
                    end)

                end

            end                
        
            if #queue > 0 then
                
                for i=1, #queue do
                    queue[i]:schedule((1.25) * i)
                
                end
                return (#queue * 1.3)

            end

        end
        return 0

    end

    -- Private Events.
    bp.register('incoming chunk', update)

    do -- Setup Bags.
        bags.equippable = T(getBagType('Everywhere', true))
        bags.storeable  = T(getBagType('Everywhere', false))

    end

    return o

end
return lib