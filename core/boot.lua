require('strings')
require('vectors')
require('logger')
require('tables')
require('lists')
require('chat')
require('pack')

-- Create a metatable that lets us shorten up helper & library calls.
local mana = dofile(string.format("%score/manager.lua", windower.addon_path))
local core = setmetatable({}, {

    __index = function(t, key)

        if rawget(t.libs, key) then
            return rawget(t.libs, key)
        
        elseif rawget(t.helpers, key) then
            return rawget(t.helpers, key)
        
        end
        return nil

    end,

})

-- Public Variables.
core.packets    = require('packets')
core.res        = require('resources')
core.extdata    = require('extdata')
core.texts      = require('texts')
core.queues     = require('queues')
core.files      = require('files')
core.sets       = require('sets')
core.api        = assert(package.loadlib(string.format("%sbin/bp.dll", windower.addon_path):gsub('\\', '/'), "luaopen_Buddypal"))()
core.manager    = mana:new(core)
core.helpers    = {}
core.libs       = {}
core.enabled    = false

-- Clean Functions.
core.fmt        = string.format
core.path       = windower.addon_path
core.register   = windower.register_event
core.unregister = windower.unregister_event
core.cmd        = windower.send_command
core.ipc        = windower.send_ipc_message
core.tochat     = windower.add_to_chat
core.run        = windower.ffxi.run
core.mob_array  = windower.ffxi.get_mob_array
core.turn       = windower.ffxi.turn
core.info       = windower.ffxi.get_info
core.item       = windower.ffxi.get_item
core.items      = windower.ffxi.get_items
core.ja         = windower.ffxi.get_abilities
core.spells     = windower.ffxi.get_spells
core.ja_recast  = windower.ffxi.get_ability_recasts
core.ma_recast  = windower.ffxi.get_spell_recasts
core.mjdata     = windower.ffxi.get_mjob_data
core.sjdata     = windower.ffxi.get_sjob_data
core.convert    = windower.convert_auto_trans
core.player     = windower.ffxi.get_player
core.target     = windower.ffxi.get_mob_by_target
core.party      = windower.ffxi.get_party
core.keyitems   = windower.ffxi.get_key_items
core.inject_o   = windower.packets.inject_outgoing
core.baginfo    = windower.ffxi.get_bag_info

-- Public Core Functions.
core.enable = function()
    core.enabled = true

end

core.disable = function()
    core.enabled = false
    core.queue.clear()
    core.actions.setCastLocked(false)
    
end

core.toggle = function()
    core.enabled = (core.enabled ~= true)
    
    if not core.enabled then
        core.queue.clear()
        core.actions.setCastLocked(false)
    
    end

end

core.newEvent = function()
    local o = {}
    o.new = function(id, callback)
        if o.event then return end
        o.event = core.register(id, callback)
        return o.event

    end

    o.delete = function()
        core.unregister(o.event)
        o.event = nil

    end

    o.active = function()
        return o.event ~= nil

    end

    o.id = function()
        local e = o.event
        return e

    end
    return o

end

core.toChat = function(...)
    local message = T{...}

    if #message > 0 and #message % 2 == 0 then
        local build = {}

        for i=1, (#message / 2) do
            table.insert(build, string.format("%s", message[(i * 2) - 1]:color(message[i * 2])))
        
        end
        core.tochat(1, table.concat(build, ' '))

    end

end

core.parse = function(s)
    local t = loadstring(string.format('return %s', s))
    
    if t and type(t) == 'function' then
        return t()
    
    end

end

core.stringify = function(t)
    return T(t):tostring()

end

core.register('addon command', function(...)
    local commands = T{...}
    local command = commands[1] and table.remove(commands, 1):lower() or nil

    if command then
        
        if command == 'toggle' then
            core.toggle()

            if not core.enabled then
                return core.toChat("Buddypal:", 170, "Disabled", 217)

            end
            core.toChat("Buddypal:", 170, "Enabled", 217)

        elseif command == 'on' then
            core.enable()
            core.toChat("Buddypal:", 170, "Enabled", 217)

        elseif command == 'off' then
            core.disable()
            core.toChat("Buddypal:", 170, "Disabled", 217)

        elseif command == 'trade' then
            local target = core.__target.get('t')

            if target and target.id ~= core.__player.id() and core.__distance.get(target) < 7 then
                local items = {}
                local num = tonumber

                for i=1, #commands do
                    local item, quant = unpack(commands[i]:split(':'))
                    
                    if item then
                        local index, count = core.__inventory.findByName(item)

                        if index and count and count >= (num(quant) or 1) then
                            table.insert(items, {index, num(quant) or 1})

                        end

                    end

                end
                
                if #items > 0 then
                    core.actions.tradeItems(target, unpack(items))

                end

            end

        elseif command == 'gil' and commands[1] then
            local amount = tonumber(table.remove(commands, 1))
            local target = core.__target.get('t')

            if amount and target then
                core.actions.tradeGil(target, amount)

            end

        elseif command == 'wring' then
            local delay = core.actions.castItem("Warp Ring", 13)
            core.toChat("Attempting to use:", 170, "Warp Ring", 217, "in", 170, tostring(delay), 217, "seconds.", 170)

        elseif command == 'cring' then
            local delay = core.actions.useDimensionalRing()
            core.toChat("Attempting to use:", 170, "Dimensional Ring", 217, "in", 170, tostring(delay), 217, "seconds.", 170)

        elseif command == 'dring' then
            local delay = core.actions.castItem("Dim. Ring (Dem)", 13)
            core.toChat("Attempting to use:", 170, "Dimensional Ring (Dem)", 217, "in", 170, tostring(delay), 217, "seconds.", 170)

        elseif command == 'mring' then
            local delay = core.actions.castItem("Dim. Ring (Mea)", 13)
            core.toChat("Attempting to use:", 170, "Dimensional Ring (Mea)", 217, "in", 170, tostring(delay), 217, "seconds.", 170)

        elseif command == 'hring' then
            local delay = core.actions.castItem("Dim. Ring (Holla)", 13)
            core.toChat("Attempting to use:", 170, "Dimensional Ring (Holla)", 217, "in", 170, tostring(delay), 217, "seconds.", 170)

        elseif command == 'coords' then
            print(core.__player.position())

        end

    end

end)

core.manager.build()
return core