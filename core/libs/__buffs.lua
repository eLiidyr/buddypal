local function lib(bp)
    local o = {}

    -- Private Variables.
    local uuid          = '9NP00'
    local auras_list    = T{}
    local removal_buffs = T{}
    local current_buffs = T{}
    local count         = 0

    -- Public Variables.

    -- Private Methods.
    local function add_aura(id)
        if not id then return end
        auras_list:insert(id)

    end

    local function remove_aura(id)

        if id and auras_list:contains(id) then

            for aura, index in auras_list:it() do
                
                if aura == id then
                    return table.remove(auras_list, index)

                end

            end

        end
        return nil

    end

    local function update_buffs(id, buffs)
        if not id then return end

        local template = ("/ %s+{ID}+{BUFFS}"):format(uuid)
        local buffs = buffs and table.concat(buffs, ':') or false
        local message = buffs and (template:gsub('{ID}', id):gsub('{BUFFS}', buffs)) or (template:gsub('{ID}', id))
        
        if message then
            bp.ipc(message)
            bp.cmd(message)

        end

    end

    local function update_auras(buff, remove)
        local template = ("/ %s+{FLAG}+{BUFF}"):format(uuid)
        local removal = (remove == true) and 'REMOVE' or 'ADD'
        
        if template and buff then
            bp.ipc((template:gsub('{FLAG}', removal):gsub('{BUFF}', buff)))
            
            if remove == true then
                add_aura(buff)

            else
                remove_aura(buff)

            end

        end

    end

    local function exists(id)
        
        for member in current_buffs:it() do

            if member.id == id then
                return true
            end

        end
        return false

    end

    local function send_buffs(buffs)

        for player in buffs:it() do
            
            if #player.list > 0 then
                update_buffs(player.id, player.list)

            else
                update_buffs(player.id, {})

            end

        end

    end

    local function parse_player(id, original, modified)
        if not S{0x063}:contains(id) then return false end

        local parsed = bp.packets.parse('incoming', original)
        local buffs = T{}

        if bp.__player.get() and parsed and parsed['Order'] == 9 then
            table.insert(buffs, {id=bp.__player.id(), list={}})

            for i=1, 32 do
                local buff = tonumber(parsed[('Buffs %s'):format(i)])
                local time = tonumber(parsed[('Time %s'):format(i)])
                
                if buff and buff > 0 and buff ~= 255 then

                    if not auras_list:contains(buff) and math.ceil(1009810800 + (time / 60) + 0x100000000 / 60 * 9) - os.time() <= 5 then
                        update_auras(buff, false)

                    end
                    table.insert(buffs[1].list, buff)

                end

            end
            send_buffs(buffs)

        end

    end

    local function parse_party(id, original)
        if not S{0x076}:contains(id) then return false end

        local parsed = bp.packets.parse('incoming', original)
        local buffs = T{}

        for i=1, 5 do
            table.insert(buffs, {id=parsed[('ID %s'):format(i)], list={}})

            for b=1, 32 do
                local buff = original:byte((i-1)*48+5+16+b-1) + 256 * (math.floor(original:byte((i-1)*48+5+8 + math.floor((b-1)/4)) / 4^((b-1)%4)) %4) -- Credit: Byrth.

                if buff > 0 and buff ~= 255 then
                    table.insert(buffs[i].list, buff)

                end

            end

        end
        send_buffs(buffs)

    end

    local function handle_auras(options)
        local command = (options and options[1]) and table.remove(options, 1) or nil

        if options and #options > 1 and S{'ADD','REMOVE'}:contains(options[1]) and tonumber(options[2])  then
            local buff = tonumber(options[3])
                
            if options[1] == 'ADD' and not auras_list:contains(buff) then
                add_aura(buff)

            elseif options[1] == 'REMOVE' and auras_list:contains(buff) then
                remove_aura(buff)

            end

        end

    end

    local function addon_command(command)
        local options = command and command:split('+')
        local command = options and options[1] and table.remove(options, 1) or false
        local num = tonumber
        
        if command and command == uuid and options[1] then
            local removable = T(bp.statusfix.removable)

            if options[1] == 'AURA' then
                handle_auras(options)

            else
                local member = bp.__target.get(num(options[1]))
                local buffs = options[2] and options[2]:split(':') or false
                
                if member and exists(member.id) then

                    for player, index in current_buffs:it() do

                        if player.id == member.id then
                            current_buffs[index] = {id=member.id, list={}}
                            removal_buffs[index] = {id=member.id, list={}}

                            for buff in T(buffs):it() do
                                local buff = num(buff)
                                
                                if removable:contains(buff) then
                                    table.insert(removal_buffs[index].list, buff)

                                else
                                    table.insert(current_buffs[index].list, buff)

                                end

                            end
                            break
                        
                        end

                    end

                elseif member and not exists(member.id) then
                    table.insert(current_buffs, {id=member.id, list={}})
                    table.insert(removal_buffs, {id=member.id, list={}})

                    for buff in T(buffs):it() do
                        local buff = num(buff)

                        if removable:contains(buff) then
                            table.insert(removal_buffs[#removal_buffs].list, buff)

                        else
                            table.insert(current_buffs[#current_buffs].list, buff)
                        
                        end

                    end

                end

            end

        end

    end

    -- Public Methods.
    o.getBuffs = function()
        return current_buffs:copy()
    
    end
    
    o.hasSpikes = function()
        return o.active({34,35,38,173})
    
    end
    
    o.hasShadows = function(count)

        if count then

            if count == 0 then
                return o.active({66,444,445,446})

            elseif count > 1 then
                return o.active({444,445,446})

            end

        else
            return o.active({444,445,446})

        end
    
    end
    
    o.hasWHMBoost = function()
        return o.active({119,120,121,122,123,124,125})
    
    end
    
    o.hasGain = function()
        return o.hasWHMBoost() end
    
    o.hasAbsorb = function()
        return o.active({90,119,120,121,122,123,124,125})
    
    end
    
    o.hasStorm = function()
        return o.active({178,179,180,181,182,183,184,185})
    
    end
    
    o.hasEnspell = function()
        return o.active({94,95,96,97,98,99,277,278,279,280,281,282})
    
    end
    
    o.hasDOT = function()
        return o.active({3,23,128,129,130,131,132,133,134,135,192,540})
    
    end

    o.hasReiveMark = function()
        return o.active(511)

    end
    
    o.hasVorseals = function()
        return o.active(602)
    
    end

    o.hasElvorseal = function()
        return o.active(603)
    
    end
    
    o.hasRads = function()
        return bp.__inventory.hasKeyItem(3031)
    
    end
    
    o.hasTribs = function()
        return bp.__inventory.hasKeyItem(2894)
    
    end
    
    o.hasAura = function(id)
        return auras_list:contains(id)
    
    end

    o.isWeak = function()
        return o.active({0,1})

    end

    o.isSilent = function()
        return o.active({69,71})
    
    end

    o.isLvRestricted = function()
        return o.active(143)
    
    end

    o.active = function(search)

        if search and type(search) == 'table' then

            for buff in T(search):it() do
                
                if bp.__player.buffs():contains(buff) then
                    return true
                
                end

            end
            return false

        else

            for buff in bp.__player.buffs():it() do

                if buff == search then
                    return true

                end

            end

        end
        return false

    end

    o.hasBuff = function(pid, bid)
        if not bp or not pid or not bid then return false end

        for player in current_buffs:it() do

            if player.id == pid and player.list and #player.list > 0 then

                for buff in T(player.list):it() do
                    
                    if buff == bid then
                        return true
                        
                    end

                end
            
            end

        end
        return false

    end

    o.cancel = function(id)
        bp.inject_o(0xF1, string.char(0xF1, 0x04, 0, 0, id % 256, math.floor(id/256), 0, 0))

    end

    o.isProtected = function()

        for player in current_buffs:it() do

            if player.id and player.list and #player.list > 0 and bp.__party.isMember(player.name) then
                
                if not T(player.list):contains(40) then
                    return false
                end
            
            end

        end
        return true

    end

    o.isShelled = function()

        for player in current_buffs:it() do

            if player.id and player.list and #player.list > 0 and bp.__party.isMember(player.name) then

                if not T(player.list):contains(41) then
                    return false
                end
            
            end

        end
        return true

    end

    o.getFinishingMoves = function()
            
        for buff in bp.__player.buffs():it() do

            if buff == 381 then
                return 1

            elseif buff == 382 then
                return 2

            elseif buff == 383 then
                return 3

            elseif buff == 384 then
                return 4

            elseif buff == 385 then
                return 5

            elseif buff == 588 then
                return 6

            end

        end
        return 0

    end

    -- Private Events.
    --bp.register('time change', function() table.vprint(current_buffs) end)
    bp.register('lose buff', remove_aura)
    bp.register('addon command', addon_command)
    bp.register('incoming chunk', parse_party)
    bp.register('incoming chunk', parse_player)
    bp.register('ipc message', function(message)
    
        if message and message:sub(1, 5) == uuid then
            addon_command(message)

        end

    end)

    return o

end
return lib