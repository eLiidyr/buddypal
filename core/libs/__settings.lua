local function lib(bp)
    local o = {}

    o.new = function(setting, global)
        local settings, mt, __file = {}, {}, nil

        if global then
            __file = string.format('settings/%s.lua', setting:lower())

        else
            __file = string.format('settings/%s/%s/%s.lua', bp.__player.server(true), bp.__player.name(true), setting:lower())

        end

        -- Private Object Variables.
        local name = setting
        local file = bp.files.new(__file)
        local data = file and file:exists() and dofile(string.format('%s%s', bp.path, __file)) or {}
        local events = {}

        -- Public Object Variables.
        settings.isNew = data and T(data):length() == 0 and true or false

        -- Public Object Methods.
        function settings:get(key)
            if not key then
                return data

            end
            return data[key]
        
        end
        
        function settings:length()
            return T(data):length()
        
        end

        function settings:empty()
            data = {}
            return data
            
        end
        
        function settings:save(callback, ...)
            file:write(string.format('return %s', T(data):tovstring()))

            if callback and type(callback) == 'function' then
                callback(...)
            
            end
            return self

        end

        function settings:update()
            bp.socket.sendSettings({ [name]=data })
            return self

        end

        function settings:default(s, v)
            if (self[s] ~= nil) then return self[s] end
            self[s] = v
            return self[s]

        end

        function settings:clear()
            
            for id, name in T(events):it() do

                if type(id) == 'number' then
                    bp.unregister(id)
                    events[name] = nil

                end
            
            end
            return false

        end

        function settings:filter(base)
            local data = T(base):key_filter(function(key) return S{bp.__player.mjob(), bp.__player.sjob()}:contains(key) end)

            for k, v in pairs(base) do
                    
                if type(v) == 'table' then
                    
                    for kk, vv in pairs(v) do
                        
                        if kk ~= '__mainonly' and data[kk] == nil then

                            if (k == bp.__player.mjob() or (k == bp.__player.sjob() and not S(v.__mainonly):contains(kk))) then
                                data[kk] = self:default(kk, vv)

                            end

                        end

                    end

                end

            end
            self:save()
            return self

        end

        function settings:fetch(keys)
            local final = nil
            local match = nil
            local index = nil

            for i, key in ipairs(keys) do

                if i == 1 and data[key] ~= nil then
                    final = key
                    index = i

                    if type(data[key]) == 'table' then
                        match = data[key]

                    else
                        match = data

                    end

                elseif i > 1 and match[key] ~= nil then
                    final = key
                    index = i

                    if type(match[key]) == 'table' then
                        match = match[key]
                        
                    end

                end           

            end
            return final, match, T(keys):slice(index+1, #keys):concat(' ')

        end

        function settings:fromClient(commands)
            local key, data, value = self:fetch(commands)

            if data[key] ~= nil then
        
                if S{'true','false'}:contains(value) then
                    data[key] = (value == 'true')
                    self:save()
        
                elseif tonumber(value) then
                    data[key] = tonumber(value)
                    self:save()
        
                elseif type(value) == 'string' then
                    data[key] = value
                    self:save()
        
                end
        
            end
            
        end

        -- Public Functions.
        o.serialize = function(t, del)
            local s, i, length = {}, 1, T(t):length()

            for k, v in pairs(t) do
                local k = tostring(k):upper()
                local v = (type(v) == 'table') and T(v):concat():upper() or tostring(v):upper()
    
                if k and v then
    
                    if i >= length then
                        table.insert(s, string.format("%s: %s", k, v))
    
                    else
                        table.insert(s, string.format("%s: %s", k, v, del))
    
                    end
    
                end
    
            end
            return table.concat(s, string.format(" %s ", del))
    
        end

        -- Metatable Functions.
        mt.__index = function(t, k)

            if rawget(data, k) ~= nil then
                return rawget(data, k)

            elseif data.core then
                local mjob = bp.__player.mjob()
                local sjob = bp.__player.sjob()

                if rawget(data.core, k) ~= nil then
                    return rawget(data.core, k)

                elseif data.core[mjob] ~= nil and rawget(data.core[mjob], k) ~= nil then
                    return rawget(data.core[mjob], k)

                elseif data.core[sjob] ~= nil and rawget(data.core[sjob], k) ~= nil then
                    return rawget(data.core[sjob], k)

                end

            end
            return nil

        end

        mt.__newindex = function(t, k, v)
            
            if name:sub(1, 5) == 'jobs/' then
                
                if k == 'core' then
                    rawset(data, k, v)
                
                elseif data.core then
                    local mjob = bp.__player.mjob()
                    local sjob = bp.__player.sjob()
                    
                    if data.core[k] ~= nil then
                        rawset(data.core, k, v)
                    
                    elseif data.core[mjob] and data.core[mjob][k] ~= nil then
                        rawset(data.core[mjob], k, v)
                    
                    elseif data.core[sjob] and data.core[sjob][k] ~= nil then
                        rawset(data.core[sjob], k, v)
                    
                    end
                
                end

            else
                rawset(data, k, v)

            end

        end

        mt.__call = function(t, k)
            if k == nil then
                if data.core then
                    return T(data.core)
                end
            end
        end

        return setmetatable(settings, mt)

    end

    return o

end
return lib