local function lib(bp)
    local o = {}

    -- Public Variables.
    o.JA    = {}
    o.MA    = {}
    o.WS    = {}
    o.IT    = {}
    o.BUFFS = {}

    -- Private Methods.
    local function get(name, id)
        return bp.res[name][id] or nil
    
    end

    local function buildResources()
        
        for res in T(bp.res.job_abilities):it() do
            
            if res.en then
                o.JA[res.en] = function() return get('job_abilities', res.id) or nil end

            end

        end

        for res in T(bp.res.spells):it() do
            
            if res.en and not res.unlearnable then
                o.MA[res.en] = function() return get('spells', res.id) end

            end

        end

        for res in T(bp.res.weapon_skills):it() do
            
            if res.en then
                o.WS[res.en] = function() return get('weapon_skills', res.id) end

            end

        end

        for res in T(bp.res.items):it() do
            
            if res.en then
                o.IT[res.en] = function() return get('items', res.id) end

            end

        end

        for res in T(bp.res.buffs):it() do
            
            if res.en then
                o.BUFFS[res.en] = function() return get('buffs', res.id) end

            end
        
        end

    end
    buildResources()

    -- Public Methods.
    o.get = function(name)
        local resource = o.MA[name] or o.JA[name] or o.WS[name] or o.IT[name] or o.BUFFS[name]

        if resource then
            return resource()
        
        end
        return nil

    end

    return o

end
return lib