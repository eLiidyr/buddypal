local function lib(bp)
    local o = {}

    -- Private Variables.
    local nations = {"San d'Oria","Bastok","Windurst"}

    -- Public Variables.
    local petstats = {}
    local iszoning = false

    -- Private Methods.
    local function setZoning(b)

        if type(b) == 'boolean' then
            iszoning = b

        end

    end

    local function handleIncoming(id, original)
        if not S{0x00a,0x00b}:contains(id) then return false end

        if id == 0x00a then
            setZoning:schedule(5, false)

        elseif id == 0x00b then
            setZoning(true)

        elseif id == 0x068 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['Owner ID'] == o.id() then
                petstats = {hpp=parsed['Current HP%'], mpp=parsed['Current MP%'], tp=parsed['Pet TP']}

            end

        end

    end

    -- Public Methods.
    o.get = function(b)
        return b and bp.target('me') or bp.player()

    end

    o.pet = function()
        return bp.target('pet') or nil

    end

    o.server = function(b)
        local server = bp.res.servers[bp.info().server] and bp.res.servers[bp.info().server].en or "Unknown Server"
        return b and server or bp.info().server

    end

    o.id = function()
        local player = o.get()
        if player then
            return player.id

        end
        return nil

    end

    o.index = function()
        local player = o.get()
        if player then
            return player.index

        end
        return nil

    end

    o.name = function(b)
        local player = o.get()
        if player then
            return b and player.name:lower() or player.name

        end
        return ""

    end

    o.status = function(b)
        local player = o.get()
        if player then

            if b then
                return bp.res[player.status] and bp.res[player.status].en or "Unknown Status"

            end
            return player.status or -1

        end
        return b and "Unknown Status" or -1

    end

    o.mjob = function(b)
        local player = o.get()
        if player then
            return b and player.main_job:lower() or player.main_job

        end
        return "UKN"

    end

    o.mlvl = function()
        return o.get().main_job_level or -999

    end

    o.mid = function()
        return o.get().main_job_id or -999

    end

    o.mfull = function(b)
        local player = o.get()
        if player then
            return b and player.main_job_full:lower() or player.main_job_full

        end
        return b and "unknown" or "Unknown"

    end

    o.sjob = function(b)
        local player = o.get()
        if player and player.sub_job then
            return b and player.sub_job:lower() or player.sub_job

        end
        return "UKN"

    end

    o.slvl = function()
        return o.get().sub_job_level or -999

    end

    o.sid = function()
        return o.get().sub_job_id or -999

    end

    o.sfull = function(b)
        local player = o.get()
        if player then
            return b and player.sub_job_full:lower() or player.sub_job_full

        end
        return b and "unknown" or "Unknown"

    end

    o.hp = function()
        local player = o.get()
        if player and player.vitals then
            return player.vitals.hp or -999

        end
        return -999

    end

    o.mp = function()
        local player = o.get()
        if player and player.vitals then
            return player.vitals.mp or -999

        end
        return -999

    end

    o.hpp = function()
        local player = o.get()
        if player and player.vitals then
            return player.vitals.hpp or -999

        end
        return -999

    end

    o.mpp = function()
        local player = o.get()
        if player and player.vitals then
            return player.vitals.mpp or -999

        end
        return -999

    end

    o.tp = function()
        local player = o.get()
        if player and player.vitals then
            return player.vitals.tp or -999
        
        end
        return -999

    end

    o.modelsize = function()
        local player = o.get()
        if player and player.vitals then
            return player.model_size or -999

        end
        return -999

    end

    o.modelscale = function()
        local player = o.get()
        if player and player.vitals then
            return player.model_scale or -999

        end
        return -999

    end

    o.speed = function()

        if bp.api then
            return bp.api.getPlayerSpeed(o.index())

        end
        return -1

    end

    o.facing = function()
        local player = o.get()
        if player and player.vitals then
            return player.facing or 0

        end
        return -999

    end

    o.heading = function()
        local player = o.get()
        if player then
            return player.heading or 0
        end
        return -999

    end

    o.linkshell = function(b)
        local player = o.get()
        if player and player.linkshell and #player.linkshell > 0 then
            return b and player.linkshell:lower() or player.linkshell

        end
        return ""

    end

    o.itemlevel = function()
        return o.get().item_level or -999

    end

    o.sulevel = function()
        return o.get().superior_level or -999

    end

    o.inCombat = function()
        return o.get().in_combat or false

    end

    o.inParty = function()
        return o.get(true) and o.get(true).in_party or false

    end

    o.inAlliance = function()
        return o.get(true) and o.get(true).in_alliance or false

    end

    o.valid = function()
        return o.get(true) and o.get(true).valid_target or false

    end

    o.locked = function()
        return o.get().target_locked or nil

    end

    o.skills = function()
        local player = o.get()
        if player then
            return T(player.skills) or {}

        end
        return T{}

    end

    o.jobs = function()
        local player = o.get()
        if player then
            return T(player.jobs) or {}

        end
        return T{}

    end

    o.buffs = function(b)
        local player = o.get()
        if player then
            return b and T(player.buffs) or T(player.buffs):map(function(id) return bp.res.buffs[id].en or nil end)

        end
        return T{}

    end

    o.vitals = function()
        local player = o.get()
        if player then
            return T(player.vitals)

        end
        return T{}

    end

    o.merits = function()
        local player = o.get()
        if player then
            return T(player.merits)

        end
        return T{}

    end

    o.jp = function()
        local player = o.get()
        if player then
            return T(player.job_points[o.mjob(true)])

        end
        return T{}

    end

    o.jobdata = function(b)
        return b and T(bp.sjdata()) or T(bp.mjdata())

    end

    o.orientation = function(target)
        local target = bp.__target.get(target)
        local player = o.get(true)

        if target and player then
            local m_degrees = ((player.facing % math.tau*180)/math.pi)
            local t_degrees = ((target.facing % math.tau*180/math.pi))

            if m_degrees and t_degrees then
                return math.abs(m_degrees - t_degrees)
                
            end

        end
        return 0

    end

    o.zone = function(b)
        local zone = bp.info().zone
        if zone then

            if b and bp.res.zones[zone] then
                return bp.res.zones[zone].en or "Unknown Zone"

            end
            return zone or -1

        end
        return b and "Unknown Zone" or -1

    end

    o.target = function(b)
        return b and o.get().target_index or bp.__target.get(o.get().target_index)
    
    end

    o.buffs = function(b)
        local player = o.get()
        if player then
            return b and T(S(o.get().buffs):map(function(id) return bp.__res.gets.buffs[id].en or nil end)) or T(o.get().buffs)

        end
        return T{}

    end

    o.position = function()
        local player = o.get(true)
        if player then
            return T{x=player.x, y=player.y, z=player.z}

        end
        return T{x=0, y=0, z=0}

    end

    o.coords = function()
        local player = o.get(true)
        if player then
            return T{player.x, player.y, player.z}

        end
        return T{0, 0, 0}

    end

    o.gil = function()
        return bp.items().gil or -1

    end

    o.nation = function(b)
        local player = o.get()
        if player and player.nation then
            return b and nations[player.nation] or player.nation

        end
        return b and "Unknown Nation" or -1

    end

    o.isZoning = function()
        return (iszoning == true) and true or false

    end

    o.day = function(b)
        local info = bp.info()
        if info.day then
            
            if b and bp.res.days[info.day] then
                return bp.res.days[info.day].en

            end
            return info.day

        end
        return b and "Unknown Day" or -1

    end

    o.moon = function()
        return bp.info().moon or -1

    end

    o.moonphase = function(b)
        local phase = bp.info().moon_phase
        if bp.res.moon_phases[phase] then
            return bp.res.moon_phases[phase].en
            
        end
        return b and "Unknown Moon Phase" or -1

    end

    o.time = function()
        return bp.info().time or -1

    end

    o.zone = function(b)
        local zone = bp.info().zone
        if zone then

            if b and bp.res.zones[zone] then
                return bp.res.zones[zone].en or "Unknown Zone"

            end
            return b and "Unknown Zone" or zone

        end
        return -1

    end

    o.moghouse = function()
        return bp.info().mog_house

    end

    o.connected = function()
        return bp.info().logged_in

    end

    o.menu = function()
        return bp.info().menu_open

    end

    o.chat = function()
        return bp.info().chat_open

    end

    o.weather = function(b)
        local weather = bp.info().weather
        if weather then

            if b and bp.res.weather[weather] then
                return bp.res.weather[weather].en or "Unknown Weather"

            end
            return b and "Unknown Weather" or weather

        end
        return -1

    end

    o.language = function()
        return bp.info().language

    end

    o.hasSubjob = function()
        return o.get().sub_job and true or false

    end

    o.hasSpell = function(spell)
        local spell = bp.res.spells[spell] or bp.__res.get(spell)

        if spell and spell.id then
            local levels = spell and spell.levels
            local recast = bp.ma_recast()
            local all = bp.spells()

            if spell and levels and all[spell.id] and recast[spell.recast_id] then
                local mjob = o.mid()
                local sjob = o.sid()

                if (levels[mjob] or levels[sjob]) then
                    local m = levels[mjob] or -1
                    local s = levels[sjob] or -1
                    if s > 99 then return false end

                    if (m > 0 or s > 0) then
                        local jpoints = o.jp()

                        if m > 99 then
                            local spent = jpoints and jpoints.jp_spent or nil

                            if spent and spent >= m then
                                return true

                            end

                        else
                            return ((m > 0 and o.mlvl() >= m) or (s > -1 and o.slvl() >= s))

                        end

                    end

                end

            end
            
        end
        return false

    end

    -- Private Events.
    bp.register('incoming chunk', handleIncoming)

    return o

end
return lib