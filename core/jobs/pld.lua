local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        if bp.core.get('auto_job_abilities') and bp.core.get('auto_one_hours') and bp.actions.canAct() then
            local target = bp.targets.get('player')

            if bp.core.get('invincible') and bp.core.ready("Invincible", 50) and target then
                bp.queue.add("Invincible", bp.__player.get())

            end
            
            if bp.core.get('intervene') and bp.core.ready("Intervene", 496) and target then
                bp.queue.add("Intervene", target)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- SHIELD BASH.
                if bp.core.get('auto_shield_bash') and bp.core.ready("Shield Bash") then
                    local shield = bp.__equipment.get(1)

                    if shield then
                        local index, count, id, status, bag, res = bp.__inventory.getByIndex(shield.bag, shield.index)

                        if index and res and res.shield_size then
                            bp.queue.add("Shield Bash", target)

                        end

                    end

                end

                -- CHIVALRY.
                if bp.core.get('chivalry') and bp.core.get('chivalry').enabled and bp.core.ready("Chivalry") then

                    if bp.__player.mpp() <= bp.core.get('chivalry').mpp and bp.__player.tp() >= bp.core.get('chivalry').tp then
                        bp.queue.add("Chivalry", bp.__player.get())

                    end

                -- COVER.
                elseif bp.core.get('cover') and bp.core.get('cover').enabled and bp.core.ready("Cover", 114) then
                    local target = bp.core.getTarget(bp.core.get('cover').target)

                    if target and bp.__distance.get(target) <= 4 then -- NEEDS UPDATE!
                        bp.queue.add("Cover", target)

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

            end

        end

        return self

    end

    function self:buff()

        if bp.core.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- MAJESTY.
                    if bp.core.get('majesty') and bp.core.ready("Majesty", 621) then
                        bp.queue.add("Majesty", bp.__player.get())

                    end

                    if target and bp.core.get('auto_job_abilities') then

                        -- SENTINEL.
                        if bp.core.get('sentinel') and bp.core.ready("Sentinel", 62) then
                            bp.queue.add("Sentinel", bp.__player.get())

                        -- RAMPART.
                        elseif bp.core.get('rampart') and bp.core.ready("Rampart", 623) then
                            bp.queue.add("Rampart", bp.__player.get())

                        -- FEALTY.
                        elseif bp.core.get('fealty') and bp.core.ready("Fealty", 344) then
                            bp.queue.add("Fealty", bp.__player.get())

                        -- PALISADE.
                        elseif bp.core.get('palisade') and bp.core.ready("Palisade", 478) then
                            bp.queue.add("Palisade", bp.__player.get())

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.core.get('crusade') and bp.core.ready("Crusade", 289) then
                        bp.queue.add("Crusade", bp.__player.get())
                    end

                    -- REPRISAL.
                    if bp.core.get('reprisal') and bp.core.ready("Reprisal", 403) and target then
                        bp.queue.add("Reprisal", bp.__player.get())

                    -- PHALANX.
                    elseif bp.core.get('auto_phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", bp.__player.get())

                    -- ENLIGHT.
                    elseif bp.core.get('enlight') then
                        local jp = bp.__player.jp().jp_spent

                        if jp >= 100 then

                            if bp.core.ready("Enlight II", 274) then
                                bp.queue.add("Enlight II", bp.__player.get())

                            end

                        elseif bp.__player.mlvl() >= 85 then

                            if bp.core.ready("Enlight", 274) then
                                bp.queue.add("Enlight", bp.__player.get())

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- MAJESTY.
                    if bp.core.get('majesty') and bp.core.ready("Majesty", 621) then
                        bp.queue.add("Majesty", bp.__player.get())

                    end

                    if target and bp.core.get('auto_job_abilities') then

                        -- SENTINEL.
                        if bp.core.get('sentinel') and bp.core.ready("Sentinel", 62) then
                            bp.queue.add("Sentinel", bp.__player.get())

                        -- RAMPART.
                        elseif bp.core.get('rampart') and bp.core.ready("Rampart", 623) then
                            bp.queue.add("Rampart", bp.__player.get())

                        -- FEALTY.
                        elseif bp.core.get('fealty') and bp.core.ready("Fealty", 344) then
                            bp.queue.add("Fealty", bp.__player.get())

                        -- PALISADE.
                        elseif bp.core.get('palisade') and bp.core.ready("Palisade", 478) then
                            bp.queue.add("Palisade", bp.__player.get())

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.core.get('crusade') and bp.core.ready("Crusade", 289) then
                        bp.queue.add("Crusade", bp.__player.get())
                    end

                    -- REPRISAL.
                    if bp.core.get('reprisal') and bp.core.ready("Reprisal", 403) and target then
                        bp.queue.add("Reprisal", bp.__player.get())

                    -- PHALANX.
                    elseif bp.core.get('auto_phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", bp.__player.get())

                    -- ENLIGHT.
                    elseif bp.core.get('enlight') then
                        local jp = bp.__player.jp().jp_spent

                        if jp >= 100 then

                            if bp.core.ready("Enlight II", 274) then
                                bp.queue.add("Enlight II", bp.__player.get())

                            end

                        elseif bp.__player.mlvl() >= 85 then

                            if bp.core.ready("Enlight", 274) then
                                bp.queue.add("Enlight", bp.__player.get())

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()

        if bp.debuffs.enabled() and bp.actions.canCast() then
            bp.debuffs.cast()

        end

        return self

    end

    function self:enmity()
        local timer = bp.core.timer('enmity')

        if bp.core.get('auto_enmity_generation') and bp.core.get('auto_enmity_generation').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.core.get('flash') and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if bp.core.get('auto_divine_emblem') and bp.core.ready("Divine Emblem", 438) then
                            bp.queue.add("Divine Emblem", target)
                        
                        end
                        bp.queue.add("Flash", target)
                        timer:update()

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.core.get('flash') and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if bp.core.get('auto_divine_emblem') and bp.core.ready("Divine Emblem", 438) then
                            bp.queue.add("Divine Emblem", target)
                        
                        end
                        bp.queue.add("Flash", target)
                        timer:update()

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('auto_nuke_mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.isReady(spell) and not bp.core.inQueue(spell) then
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load