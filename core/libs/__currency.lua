local function lib(bp)
    local o = {}

    -- Private Variables.
    local event = bp.newEvent()

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.
    o.get = function(category, name, callback)
        local catgeory = category or 1

        if category == 1 then

            if not event.active() and name then

                event.new('incoming chunk', function(id, original)
                    if not S{0x113}:contains(id) then return false end
                    local parsed = bp.packets.parse('incoming', original)

                    event.delete()
                    if parsed and parsed[name] then

                        if callback and type(callback) == 'function' then
                            callback(name, parsed[name])

                        end
                        
                    end

                end)
                bp.packets.inject(bp.packets.new('outgoing', 0x10F, {}))

            end

        elseif category == 2 then

            if not event.active() and name then

                event.new('incoming chunk', function(id, original)
                    if not S{0x118}:contains(id) then return false end
                    local parsed = bp.packets.parse('incoming', original)

                    event.delete()
                    if parsed and parsed[name] then

                        if callback and type(callback) == 'function' then
                            callback(name, parsed[name])

                        end
                        
                    end

                end)
                bp.packets.inject(bp.packets.new('outgoing', 0x115, {}))

            end

        end

    end

    -- Private Events.

    return o

end
return lib