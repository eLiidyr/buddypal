local manager = {}
function manager:new(core)

    -- Private Variables.
    local DIR_LIBS      = string.format("%s%s", windower.addon_path, 'core/libs/')
    local DIR_HELPERS   = string.format("%s%s", windower.addon_path, 'core/helpers/')
    local classEvents   = {

        __call = function(t, ...)
            local event, callback = table.unpack(T{...})
            
            if event and callback and type(callback) == 'function' then
                
                if S{'incoming','outgoing'}:contains(event) then
                    table.insert(t, core.register((event == 'incoming' and 'incoming chunk' or 'outgoing chunk'), callback))

                else
                    table.insert(t, core.register(event, callback))

                end

            end

        end,

    }

    -- Private Methods.
    local function buildHelpers()

        for filename in S(windower.get_dir(DIR_HELPERS)):it() do
            local file = filename:match('.lua') and filename:gsub('.lua', '') or false
        
            if file then
                local build = dofile(string.format('%s%s.lua', DIR_HELPERS, file))
        
                if type(build) == 'function' then
                    core.helpers[file] = build(core, setmetatable({}, classEvents))
                    
                    core.helpers[file].__timers = {}
                    core.helpers[file].timer = function(n, d)

                        if n then

                            if not d and core.helpers[file].__timers[n] then
                                return core.helpers[file].__timers[n]

                            end

                            core.helpers[file].__timers[n] = {last=0, delay=d or 0}
                            core.helpers[file].__timers[n].update = function(t, d)
                                local d = (d and tonumber(d)) and tonumber(d) or 0
                                
                                if t and t.last then
                                    t.last = (os.clock() + d)

                                end

                            end

                            core.helpers[file].__timers[n].ready = function(t)
                                if t and t.last and t.delay and (os.clock() - t.last) > t.delay then
                                    return true

                                end
                                return false

                            end
                            return core.helpers[file].__timers[n]

                        end

                    end
                    
                end
        
            end
        
        end

        -- Trigger onLoad functions for helpers after everything is loaded.
        core.socket.onLoad()
        for name, class in pairs(core.helpers) do
            
            if not S{'socket'}:contains(name) and class.onLoad then
                class.onLoad()

            end

        end

    end

    local function buildLibraries()

        for filename in S(windower.get_dir(DIR_LIBS)):it() do
            local file = filename:match('.lua') and filename:gsub('.lua', '') or false
        
            if file then
                local build = dofile(string.format('%s%s.lua', DIR_LIBS, file))
        
                if type(build) == 'function' then
                    core.libs[file] = build(core)
                    
                end
        
            end
        
        end

    end

    local function buildAliases()
        local keybinds = T{'@b / toggle', '@f / follow initiate-follow', '@s / follow stop-following', '@a / assist set', '@t / target set', '@p / interact', '@, / bubbles geomancy-target', '@. / bubbles entrust-target', '@[ / ord p / on', '@] / ord p / off'}
        local aliases = T{
            ["wring"]       = "/ wring",
            ["dring"]       = "/ dring",
            ["hring"]       = "/ hring",
            ["mring"]       = "/ mring",
            ["cring"]       = "/ cring",
            ["wrings"]      = "/ ord p / wring",
            ["drings"]      = "/ ord p / dring",
            ["hrings"]      = "/ ord p / hring",
            ["mrings"]      = "/ ord p / mring",
            ["crings"]      = "/ ord p / cring",
            ["up"]          = "/ ord p / mounts",
            ["down"]        = "/ ord p dismount"
        }

        for bind in keybinds:it() do
            core.cmd(('bind %s'):format(bind))
        
        end

        for command, name in aliases:it() do
            core.cmd(('alias %s %s'):format(name, command))
        
        end


    end

    -- Public Methods.
    self.build = function()
        buildLibraries()
        buildHelpers()
        buildAliases()

        -- Apply Fast CS Hook.
        core.api.hookFastCS()

    end

    return self

end
return manager