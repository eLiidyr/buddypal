local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local socket            = bp.api.createSocket('127.0.0.1', 30000)
    local incoming_allowed  = S{0x020,0x050,0x056,0x063,0x0DD,0x113,0x118,0x0AA}

    -- Public Variables.

    -- Private Methods.
    local function onload()
        o.updatePlayer()
        bp.packets.inject(bp.packets.new('outgoing', 0x10F, {}))
        bp.packets.inject(bp.packets.new('outgoing', 0x115, {}))

    end

    local function getPlayerData(mid, mlevel, sid, slevel)
        local player = bp.__player.get()
        
        if player then
            local jobdata = {}

            if mid and mlevel then
                jobdata = {mjob=bp.res.jobs[mid].ens, mlevel=mlevel, mfull=bp.res.jobs[mid].en, mid=mid, sjob=(bp.res.jobs[sid]) and bp.res.jobs[sid].ens or nil, slevel=slevel, sfull=(bp.res.jobs[sid]) and bp.res.jobs[sid].en or nil, sid=sid}
                return {id=player.id, server=bp.__player.server(), name=player.name, skills=player.skills, job=jobdata, jobs=player.jobs, merits=player.merits, job_points=player.job_points, nation=player.nation, key_items=bp.keyitems(), abilities=bp.abilities()}

            end
            return {id=player.id, server=bp.__player.server(), name=player.name, skills=player.skills, job={mjob=player.main_job, mlevel=player.main_job_level, mfull=player.main_job_full, mid=player.main_job_id, sjob=player.sub_job or nil, slevel=player.sub_job_level or nil, sfull=player.sub_job_full or nil, sid=player.sub_job_id or nil}, jobs=player.jobs, merits=player.merits, job_points=player.job_points, nation=player.nation, key_items=bp.keyitems(), abilities=bp.abilities()}

        end
        return {}

    end

    local function sendIncoming(_, original)
        bp.api.socketSend(0x2, original)

    end

    local function sendOutgoing(_, original)
        bp.api.socketSend(0x3, original)

    end

    local function handleIncoming(id, original)
        if not incoming_allowed:contains(id) then
            if id == 0x0AC then
                o.updateAbilities()

            end
            return false
        end
        sendIncoming(nil, original)

    end

    local function receiveData()
        local data = bp.api.socketReceive()
        
        if data then
            print(data)
            bp.cmd(data)

        end

    end

    local function job_change(mid, mlevel, sid, slevel)
        o.sendStandard(0x1, {event=0x01, original=getPlayerData(mid, mlevel, sid, slevel)})

    end

    -- Public Methods.
    o.isReady = function()
        return bp.api.socketReady()

    end

    o.sendStandard = function(id, data)
        bp.api.socketSend(0x1, bp.__json.encode(data))

    end

    o.updatePlayer = function()
        local player = bp.__player.get()
        o.sendStandard(0x1, {event=0x01, original=getPlayerData()})

    end

    o.updateRecast = function()
        local recast = bp.ma_recast()
        local spells = T(T(bp.ma_recast()):keyset():filter(function(k) return recast[k] > 0 end))
        o.sendStandard(0x1, {event=0x04, original=spells})

    end

    o.updateAbilities = function()
        o.sendStandard(0x1, {event=0x05, original=bp.abilities()})

    end

    o.sendSettings = function(data)
        o.sendStandard(0x1, {event=0x03, settings=data})

    end

    -- Private Events.
    o.events('prerender', receiveData)
    o.events('incoming', handleIncoming)
    o.events('job change', job_change)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper