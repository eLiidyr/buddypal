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

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.
    o.get = function(n)
        local huge, floor = math.huge, math.floor
        local data = {}

        if n then
            local party = bp.party()

            if n == 1 then

                for i=0, 5 do
                    local member = party[string.format('p%d', i)]
                    local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                    if member and missing then
                        member.party = T{true, false, false}
                        member.missing = (missing > -huge and missing < huge) and missing or 0
                        table.insert(data, member)

                    end

                end

            elseif n == 2 then

                for i=10, 15 do
                    local member = party[string.format('a%d', i)]
                    local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                    if member and missing then
                        member.party = T{false, true, false}
                        member.missing = (missing > -huge and missing < huge) and missing or 0
                        table.insert(data, member)

                    end

                end

            elseif n == 3 then

                for i=20, 25 do
                    local member = party[string.format('a%d', i)]
                    local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                    if member and missing then
                        member.party = T{false, false, true}
                        member.missing = (missing > -huge and missing < huge) and missing or 0
                        table.insert(data, member)

                    end

                end
            
            end
            return data

        else

            local party = bp.party()

            for i=0, 5 do
                local member = party[string.format('p%d', i)]
                local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                if member and missing then
                    member.party = T{true, false, false}
                    member.missing = (missing > -huge and missing < huge) and missing or 0
                    table.insert(data, member)

                end

            end

            for i=10, 15 do
                local member = party[string.format('a%d', i)]
                local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                if member and missing then
                    member.party = T{false, true, false}
                    member.missing = (missing > -huge and missing < huge) and missing or 0
                    table.insert(data, member)

                end

            end

            for i=20, 25 do
                local member = party[string.format('a%d', i)]
                local missing = (member and member.hp and member.hpp) and floor(member.hp * ((100 - member.hpp) / member.hpp)) or 0

                if member and missing then
                    member.party = T{false, false, true}
                    member.missing = (missing > -huge and missing < huge) and missing or 0
                    table.insert(data, member)

                end

            end
            return data

        end

    end

    o.getNames = function(n)

        if n and S{1,2,3}:contains(n) and o.get(n) then
            return T(T(o.get(n)):map(function(member) return member.name or nil end))

        else

            return T(T(o.get()):map(function(member) return member.name or nil end))

        end

    end

    o.count = function(n)

        if n and o.get(n) then
            return T(o.get(n)):length()

        end
        return T(o.get()):length()


    end

    o.inSameParty = function(a, b)
        local party = T(o.get())
        
        if a and b and party then
            local membera = select(2, party:find(function(m) return m.name == a end))
            local memberb = select(2, party:find(function(m) return m.name == b end))

            if membera and memberb then
                return membera.party:equals(memberb.party)

            end

        end
        return false

    end

    o.inAlliance = function()
        return (o.getAllianceLeader() ~= nil)

    end

    o.isMember = function(name, check_alliance)
        if not name then
            return

        end
        
        if check_alliance then
            return T(o.getNames()):contains(name)

        else
            return T(o.getNames(1)):contains(name)

        end

    end

    o.getAllianceLeader = function()
        return bp.party().alliance_leader or nil

    end

    o.getPartyLeaders = function()
        local party = bp.party()
        return T{ party.party1_leader, party.party2_leader, party.party3_leader }

    end

    o.isAllianceLeader = function(id)
        local leader = o.getAllianceLeader()

        if leader then
            return (leader == id)
        
        end
        return false

    end

    o.isPartyLeader = function(id)
        return o.getPartyLeaders():contains(id)

    end

    o.getMember = function(name)
        return select(2, T(o.get()):find(function(m) return m.name == name end))

    end

    o.memberInZone = function(name)
        local party = T(o.get())
        
        if name and party then
            local member = select(2, party:find(function(m) return m.name == name end))

            if member and member.zone then
                return member.zone == bp.__player.zone()

            end

        end
        return false

    end

    o.partyInZone = function(alliance_check)

        if alliance_check then
            return (S(T(o.get()):map(function(m) return m.zone end)):length() == 1)

        else
            return (S(T(o.get(1)):map(function(m) return m.zone end)):length() == 1)

        end

    end

    o.inRange = function(distance, check_alliance)

        if check_alliance then

            for member in T(o.get()):it() do

                if not member.mob then
                    return false

                elseif bp.__distance.get(member.mob.id) > (distance or 45) then
                    return false

                end

            end

        else

            for member in T(o.get(1)):it() do

                if not member.mob then
                    return false

                elseif bp.__distance.get(member.mob.id) > (distance or 45) then
                    return false

                end

            end

        end
        return true

    end

    -- Private Events.

    return o

end
return lib