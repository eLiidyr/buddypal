local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local uuid      = 'TSVCB'
    local stagger   = 0.65
    local accounts  = S{}
    local calls     = T{}

    -- Public Variables.

    -- Private Methods.
    local function deliver(order)

        if order and order.player then
            bp.cmd(bp.convert(order.player))

        end

        if order and order.others and #order.others > 0 then
            local type = type

            if type(order.others) == 'table' then
                bp.ipc(bp.convert(("%s%s"):format(uuid, table.concat(order.others, ' '))))

            else
                bp.ipc(bp.convert(("%s%s"):format(uuid, order.others)))

            end

        end

    end

    local function ping()
        accounts = S{}
        bp.ipc(string.format('%s:PING', uuid))

    end

    local function pong()
        bp.ipc(string.format('%s:PONG %s', uuid, bp.__player.name()))

    end

    calls['@'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        ping()
        coroutine.schedule(function()
            order.player = string.format('wait %s; %s', 0, orders)

            for name in accounts:it() do
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))

            end
            deliver(order)
        
        end, 0.15)
    
    end

    calls['@@'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0.65
    
        ping()
        coroutine.schedule(function()
            order.player = string.format('wait %s; %s', 0, orders)

            for name in accounts:it() do
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
                delay = (delay + stagger)

            end
            deliver(order)
        
        end, 0.15)

    end

    calls['@*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        ping()
        coroutine.schedule(function()
            order.player = nil

            for name in accounts:it() do
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))

            end
            deliver(order)
        
        end, 0.15)

    end

    calls['@@*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0.65
    
        ping()
        coroutine.schedule(function()
            order.player = nil

            for name in accounts:it() do
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
                delay = (delay + stagger)

            end
            deliver(order)
        
        end, 0.15)

    end

    calls['r'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
        
        for name in bp.__party.getList():it() do
            local target = bp.__target.get(name)

            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)

            elseif target and bp.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', target.name, delay, orders))

            end
    
        end
        deliver(order)

    end

    calls['rr'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0

        for name in bp.__party.getList():it() do
            local target = bp.__target.get(name)

            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)

            elseif target and bp.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', target.name, delay, orders))
                delay = (delay + stagger)
    
            end

        end
        deliver(order)

    end

    calls['r*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
            local target = bp.__target.get(character.name)
    
            if name ~= bp.__player.name() and bp.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', target.name, delay, orders))

            end
    
        end
        deliver(order)

    end

    calls['rr*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
            local target = bp.__target.get(name)

            if name ~= bp.__player.name() and bp.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', target.name, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        deliver(order)

    end

    calls['p'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0

        for name in bp.__party.getList():it() do

            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)
    
            else
                
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
    
            end

        end
        deliver(order)

    end

    calls['pp'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do

            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)

            else
                
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
                delay = (delay + stagger)

            end
    
        end
        deliver(order)

    end

    calls['p*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name ~= bp.__player.name() then
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
            
            end
    
        end
        deliver(order)

    end

    calls['pp*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name ~= bp.__player.name() then
                table.insert(order.others, string.format('||%s wait %s; %s', character.name, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        deliver(order)

    end

    calls['z'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)
    
            elseif bp.__party.memberInZone(name) then
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
    
            end
    
        end
        deliver(order)

    end

    calls['zz'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name == bp.__player.name() then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
            elseif bp.__party.memberInZone(name) then
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        deliver(order)

    end

    calls['z*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name ~= bp.__player.name() and bp.__party.memberInZone(name) then
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))    
            
            end
    
        end
        deliver(order)

    end

    calls['zz*'] = function(orders)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name ~= bp.__player.name() and bp.__party.memberInZone(name) then
                table.insert(order.others, string.format('||%s wait %s; %s', name, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        deliver(order)

    end

    calls['j'] = function(orders, job)
        local party = bp.__party.get()
        local order = {player=false, others={}}
        local delay = 0
        
        for name in bp.__party.getList():it() do
    
            if name == bp.__player.name() and bp.__player.mjob(true) == job then
                order.player = string.format('wait %s; %s', delay, orders)
    
            else
                
                table.insert(order.others, string.format('||%s:%s wait %s; %s', name, job, delay, orders))
    
            end
    
        end
        deliver(order)

    end

    calls['jj'] = function(orders, job)
        local order = {player=false, others={}}
        local delay = 0
    
        for name in bp.__party.getList():it() do
    
            if name == bp.__player.name() and bp.__player.mjob(true) == job then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
            else
                
                table.insert(order.others, string.format('||%s:%s wait %s; %s', name, job, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        deliver(order)

    end

    -- Public Methods.
    o.send = function(call, ...)
        
        if calls[call] then
            calls[call](...)

        end

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
    
        if command and T{'ord','orders'}:contains(command:lower()) then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if #command >= 3 and S{'war','mnk','whm','blm','rdm','thf','pld','drk','bst','brd','rng','smn','sam','nin','drg','blu','cor','pup','dnc','sch','geo','run'}:contains(command:sub(1, 3)) then
                calls[(command:sub(#command, #command) == '*') and 'jj' or 'j'](table.concat(commands, ' '), command:sub(1, 3))

            elseif command and calls[command] then
                calls[command](table.concat(commands, ' '))

            end

        end

    end)

    o.events('ipc message', function(message)
        local string = string

        if message:sub(1, 10) == string.format('%s:PING', uuid) then
            pong()

        elseif message:sub(1, 10) == string.format('%s:PONG', uuid) then
            local name = T(message:split(' '))[2]

            if name and not accounts:contains(name) then
                accounts:add(name)

            end

        elseif message:sub(1, 5) == uuid then
            local name = bp.__player.name()

            for order in T(message:split('||')):it() do

                if order:sub(1, #name) == name then
                    
                    if order:sub(#name + 1, (#name) + 1) == ':' then
                        local job = order:sub((#name) + 2, (#name) + 4)
    
                        if bp.__player.mjob(true):lower() == job then                        
                            bp.cmd(order:sub((#name) + 4, #order))

                        end
    
                    else
                        
                        bp.cmd(order:sub((#name) + 2, #order))
    
                    end
    
                end
    
            end

        end        
    
    end)

    -- Class Specific Events.

    return o

end
return helper