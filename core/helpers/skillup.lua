local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings          = bp.__settings.new('skillup')
    local current_spells    = {}

    do -- Setup default setting values.
        settings.skillup_duration   = settings:default('skillup_duration',    1)        -- How long to skillup for before stopping.
        settings.skillup_cooldown   = settings:default('skillup_cooldown',    0)        -- How long to pause before starting skill-ups again.
        settings.auto_use_food      = settings:default('auto_use_food',       -1)       -- Automatically use food when doing skill-ups.
        settings.randomize_timers   = settings:default('randomize_timers',    false)    -- Randomize the duration & cooldown times.
        settings.skillup_enabled    = settings:default('skillup_enabled',     false)    -- Enable skill-up mode.
        settings.spells             = settings:default('spells',              {})       -- Spells to use when doing skill-ups.

    end

    -- Public Variables.

    -- Private Methods.
    local function randomize(a, b)
        return math.floor(math.random(a, b))
        
    end

    local function onload()
        settings.enabled = false

        if settings.randomize_timers then
            o.timer('duration', ((randomize(1, 24) * 60) * 60))
            o.timer('cooldown', ((randomize(0, 06) * 60) * 60))
            o.timer('duration'):update()

        else

            o.timer('duration', ((settings.skillup_duration * 60) * 60))
            o.timer('cooldown', ((settings.skillup_cooldown * 60) * 60))
            o.timer('duration'):update()

        end
        settings:save():update()

        do -- Convert Spells list.
            current_spells = S(settings.spells)

        end

    end

    local function handle_skillup()
        if not o.isEnabled() then return end

        local duration  = o.timer('duration')
        local cooldown  = o.timer('cooldown')
        local player    = bp.__player.get()
        local target    = bp.targets.get('player')

        if not cooldown:ready() then
            return

        end

        if not duration:ready() and cooldown:ready() then

            if bp.__player.mjob() == 'SMN' and bp.__player.pet() then
                bp.queue.add("Release", player)

            else
                
                if (S{'RDM','RUN'}:contains(bp.__player.mjob()) or S{'RDM','RUN'}:contains(bp.__player.sjob())) and not bp.__buffs.active(43) then

                    if bp.__player.mjob() == 'RDM' and not bp.__buffs.active({43,187,188}) then
                        local spent = bp.__player.jp().jp_spent

                        if spent >= 1200 and bp.core.ready("Refresh III") then
                            bp.queue.add("Refresh III", player)

                        elseif bp.__player.mlvl() >= 82 and spent < 1200 and bp.core.ready("Refresh II") then
                            bp.queue.add("Refresh II", player)

                        elseif bp.__player.mlvl() < 82 and bp.core.ready("Refresh") then
                            bp.queue.add("Refresh", player)
                        
                        end

                    else

                        if bp.core.ready("Refresh") then
                            bp.queue.add("Refresh", player)

                        end

                    end

                end

                -- Handle food first.
                --[[
                if settings.auto_use_food ~= "" and not bp.__buffs.active(251) then
                    local index, count, id, status, bag, res = bp.__inventory.findByName(settings.auto_use_food, 0)
        
                    if index and status and status == 0 then
                        bp.queue.add(res, bp.__player.get(), 100)
                        return
        
                    end
        
                end
                ]]

                for spell in current_spells:it() do
                    local spell = bp.__res.get(spell)

                    if spell then

                        if target and bp.__target.castable(target, spell) and bp.actions.isReady(spell) and not bp.queue.inQueue(spell, player) then
                            bp.queue.force(spell, target)

                        elseif bp.__target.castable(player, spell) and bp.actions.isReady(spell) and not bp.queue.inQueue(spell, player) then
                            bp.queue.force(spell, player)

                        end
                        
                    end

                end

            end

        elseif duration:ready() and cooldown:ready() then
            duration:update((settings.randomize_timers and randomize(1, 6) or settings.skillup_cooldown * 60) * 60)
            cooldown:update()

        end

    end

    -- Public Methods.
    o.isEnabled = function()
        return (settings.skillup_enabled == true)

    end

    o.handle = function()
        handle_skillup()

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and (string.match(command, 'abilities/%a%a%a%a%a%a')) then

            if settings[commands[1]] ~= nil then
                settings:fromClient(commands)

            else

                local command = commands[1] and table.remove(commands, 1):lower()

                if command then

                end

            end

        end

    end)

    -- Class Specific Events.

    return o

end
return helper