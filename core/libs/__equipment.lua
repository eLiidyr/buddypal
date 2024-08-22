local function lib(bp)
    local o = {}

    -- Private Variables.
    local equipment = T{}

    -- Public Variables.
    local equipset = windower.ffxi.set_equip

    -- Private Methods.
    local function updateo(id, original)
        if not S{0x050}:contains(id) then return false end
        local parsed = bp.packets.parse('outgoing', original)

        if parsed then
            equipment[parsed['Equip Slot']] = {index=parsed['Item Index'], slot=parsed['Equip Slot'], bag=parsed['Bag']}

        end

    end

    local function updatei(id, original)
        if not S{0x050}:contains(id) then return false end
        local parsed = bp.packets.parse('incoming', original)

        if parsed then
            equipment[parsed['Equipment Slot']] = {index=parsed['Inventory Index'], slot=parsed['Equipment Slot'], bag=parsed['Inventory Bag']}

        end

    end

    -- Public Methods.
    o.get = function(slot)
        return slot and equipment[slot] or equipment
    
    end
    
    o.remove = function(slot)
        bp.packets.inject(bp.packets.new('outgoing', 0x050, {['Item Index'] = 0, ['Equip Slot'] = slot}))

    end

    o.removeGear = function(ignore)
        local ignore = S{ignore}

        for i=0, 15 do

            if not ignore:contains(i) then
                local eq = o.get(i)

                if eq.index then
                    local index, count, id, status, bag, res = bp.__inventory.getByIndex(0, eq.index)

                    if index and status and status == 5 then
                        bp.packets.inject(bp.packets.new('outgoing', 0x050, {['Item Index']=0, ['Equip Slot']=i, ['Bag']=eq.bag}))

                    end

                end

            end

        end

    end

    o.equip = function(list, bag)
        local slots = {main=0,sub=1,range=2,ammo=3,head=4,body=5,hands=6,legs=7,feet=8,neck=9,waist=10,lear=11,rear=12,lring=13,rring=14,back=15}
        
        if list and type(list) == 'table' then

            for slot, name in pairs(list) do
                local index, count, id, status, bag, res = bp.__inventory.findByName(name, bag or 0)
            
                if index and status and bag and status == 0 and slots[slot] then
                    equipset(index, slots[slot], bag)
                    
                end

            end

        end

    end

    -- Private Events.
    bp.register('incoming chunk', updatei)
    bp.register('outgoing chunk', updateo)

    return o

end
return lib