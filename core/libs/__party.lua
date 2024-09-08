local function lib(bp)
    local o = {}

    -- Update Packet Data.
    bp.packets.raw_fields.incoming[0x0DD] = L{
        {ctype='unsigned int',      label='ID',                 fn=id},             -- 04
        {ctype='unsigned int',      label='HP'},                                    -- 08
        {ctype='unsigned int',      label='MP'},                                    -- 0C
        {ctype='unsigned int',      label='TP',                 fn=percent},        -- 10
        {ctype='bit[2]',            label='Party Index'},                           -- 14:0
        {ctype='bit[1]',            label='Party Leader',       fn=bool},           -- 14:2
        {ctype='bit[1]',            label='Alliance Leader',    fn=bool},           -- 14:3
        {ctype='bit[1]',            label='PartyR Flag'},                           -- 14:4
        {ctype='bit[1]',            label='AllianceR Flag'},                        -- 14:5
        {ctype='bit[1]',            label='_unknown01'},                            -- 14:6
        {ctype='bit[1]',            label='_unknown02'},                            -- 14:7
        {ctype='unsigned char',     label='padding00'},                             -- 15
        {ctype='unsigned short',    label='_unknown03'},                            -- 16
        {ctype='unsigned short',    label='Index',              fn=index},          -- 18
        {ctype='unsigned char',     label='Member Index'},                          -- 1A
        {ctype='unsigned char',     label='Moghouse Flag'},                         -- 1B
        {ctype='unsigned char',     label='_unknown04'},                            -- 1C
        {ctype='unsigned char',     label='HP%',                fn=percent},        -- 1D
        {ctype='unsigned char',     label='MP%',                fn=percent},        -- 1E
        {ctype='unsigned char',     label='padding01'},                             -- 1F
        {ctype='unsigned short',    label='Zone',               fn=zone},           -- 20
        {ctype='unsigned char',     label='Main Job',           fn=job},            -- 22
        {ctype='unsigned char',     label='Main Job Level'},                        -- 23
        {ctype='unsigned char',     label='Sub Job',            fn=job},            -- 24
        {ctype='unsigned char',     label='Sub Job Level'},                         -- 25
        {ctype='unsigned char',     label='Master Level'},                          -- 26
        {ctype='boolbit',           label='Master Breaker'},                        -- 27
        {ctype='bit[7]',            label='_junk2'},                                -- 27
        {ctype='char*',             label='Name'},                                  -- 28
    }

    -- Private Variables.
    local uuid  = 'G32JG'
    local party = T{[1]=T{},[2]=T{},[3]=T{}}
    local leads = T{}
    local plmap = T{}
    local count = T{}
    local zones = S{}
    local seqid = nil

    -- Public Variables.

    -- Private Methods.
    local function update()
        local num = tonumber
        party = T{[1]=T{},[2]=T{},[3]=T{}}
        plmap = T{}
        zones = S{}

        coroutine.schedule(function()
            local myparty = T(bp.party())

            do -- Update static variables for party.
                leads = T{alliance=myparty.alliance_leader, party=T{[1]=myparty.party1_leader, [2]=myparty.party2_leader, [3]=myparty.party3_leader}}
                count = T{alliance=myparty.alliance_count or 0, party=T{[1]=myparty.party1_count, [2]=myparty.party2_count, [3]=myparty.party3_count}}

            end

            for v, k in myparty:it() do

                if #k <= 3 then
                    local category = k:sub(1, 1)
                    local mindex = num(k:sub(2))

                    if category == 'p' then
                        party[1][v.name] = v
                        plmap[v.name] = 1
                        zones:add(v.zone)

                    else

                        if mindex > 15 then
                            party[2][v.name] = v
                            plmap[v.name] = 2
                            zones:add(v.zone)

                        elseif mindex > 5 then
                            party[3][v.name] = v
                            plmap[v.name] = 3
                            zones:add(v.zone)

                        end

                    end
                
                end

            end

        end, 0.40)

    end

    local function party_update(id, original)
        if not S{0x0dd}:contains(id) then return false end
        local parsed = bp.packets.parse('incoming', original)

        -- If this is the same sequence id, do not update again.
        if parsed._sequence == seqid then
            return false

        end
        update()
        seqid = parsed._sequence

    end

    -- Public Methods.
    o.get = function(n)

        if n and party[n] then
            return party[n]:copy()

        end
        return party:copy()

    end

    o.getList = function(n)
        local unpack = table.unpack

        if n and S{1,2,3}:contains(n) and party[n] then
            T(party[n]:keyset())

        else

            return T(L(party[1]:keyset()):extend(L(party[2]:keyset())):extend(L(party[3]:keyset())))

        end

    end

    o.getIndex = function(name)
        return plmap[name]

    end

    o.count = function(n)

        if n and count.party[n] then
            return count.party[n]

        end
        return count.alliance

    end

    o.inSameParty = function(a, b)
        return (plmap[a] == plmap[b]) or false

    end

    o.inAlliance = function()
        return (leads.alliance ~= nil)

    end

    o.isMember = function(t, ally)
        local sindex = plmap[bp.__player.name()]
        local pindex = plmap[t]
        
        if party[pindex] and party[pindex][t] then

            if not ally and sindex == pindex then
                return true

            elseif ally then
                return true

            end

        end
        return false

    end

    o.getAllianceLeader = function()
        return leads.alliance

    end

    o.getPartyLeaders = function()
        return leads.party

    end

    o.isAllianceLeader = function(id)
        return leads.alliance and (leads.alliance == id)

    end

    o.isPartyLeader = function(id)
        return leads.party:contains(id)

    end

    o.getMember = function(name)
        local pindex = plmap[name]

        if pindex and party[pindex] then
            return party[pindex][name]

        end
        return nil

    end

    o.memberInZone = function(pname)
        local sname = bp.__player.name()
        local sindex = plmap[sname]
        local pindex = plmap[pname]

        if sindex and pindex and party[sindex] and party[pindex] and party[sindex][sname] and party[pindex][pname] then
            return (party[sindex][sname].zone == party[pindex][pname].zone)

        end
        return false

    end

    o.partyInZone = function()
        return (zones:length() == 1)

    end

    o.inRange = function(distance, ally)
        local distance = tonumber(distance) or 45

        if ally then
            local party = party[1]:extend(party[2]):extend(party[3])

            for member in party:it() do
                
                if not member.mob then
                    return false

                elseif member.mob and bp.__distance.get(member.mob.id) > distance then
                    return false

                end
                
            end

        else

            for member in party:it() do
                
                if not member.mob then
                    return false

                elseif member.mob and bp.__distance.get(member.mob.id) > distance then
                    return false

                end

            end

        end
        return true

    end

    -- Private Events.
    bp.register('incoming chunk', party_update)

    -- Build party when loaded.
    update()

    return o

end
return lib