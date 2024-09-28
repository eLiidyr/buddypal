local function load(bp)
    local self = {}

    if not bp then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()

        if bp.combat.get('auto_one_hours') and bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local target = bp.targets.get('player')

            if bp.abilities.get('auto_invincible') and bp.core.ready("Invincible", 50) and target then
                bp.queue.add("Invincible", bp.__player.get())

            end
            
            if bp.abilities.get('auto_intervene') and bp.core.ready("Intervene", 496) and target then
                bp.queue.add("Intervene", target)

            end

        end

        return self

    end

    function self:abilities()

        if bp.combat.get('auto_job_abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- SHIELD BASH.
                if bp.abilities.get('auto_shield_bash') and bp.core.ready("Shield Bash") then
                    
                    if bp.__equipment.hasShield() then
                        bp.queue.add("Shield Bash", target)

                    end

                end

                -- CHIVALRY.
                if bp.abilities.get('auto_chivalry') and bp.abilities.get('auto_chivalry').enabled then
                    local chivalry = bp.abilities.get('auto_chivalry')
                    
                    if bp.core.ready("Chivalry") and bp.__player.mpp() <= chivalry.mpp and bp.__player.tp() >= chivalry.tp then
                        bp.queue.add("Chivalry", player)

                    end

                -- COVER.
                elseif bp.abilities.get('auto_cover') and bp.abilities.get('auto_cover').enabled then
                    local cover = bp.abilities.get('auto_cover')

                    if bp.core.ready("Cover", 114) then
                        local target = bp.core.getTarget(cover.target)

                        if target and bp.__distance.get(target) <= 10 then -- UPDATE.
                            bp.queue.add("Cover", target)

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

            end

        end

        return self

    end

    function self:buff()

        if bp.combat.get('auto_buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    if target and bp.combat.get('auto_job_abilities') then

                        -- MAJESTY.
                        if bp.abilities.get('auto_majesty') and bp.core.ready("Majesty", 621) then
                            bp.queue.add("Majesty", player)

                        end

                        -- SENTINEL.
                        if bp.abilities.get('auto_sentinel') and bp.core.ready("Sentinel", 62) then
                            bp.queue.add("Sentinel", player)

                        -- RAMPART.
                        elseif bp.abilities.get('auto_rampart') and bp.core.ready("Rampart", 623) then
                            bp.queue.add("Rampart", player)

                        -- FEALTY.
                        elseif bp.abilities.get('auto_fealty') and bp.core.ready("Fealty", 344) then
                            bp.queue.add("Fealty", player)

                        -- PALISADE.
                        elseif bp.abilities.get('auto_palisade') and bp.core.ready("Palisade", 478) then
                            bp.queue.add("Palisade", player)

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.buffs.get('auto_crusade') and bp.core.ready("Crusade", 289) then
                        bp.queue.add("Crusade", player)
                    end

                    -- REPRISAL.
                    if bp.buffs.get('auto_reprisal') and bp.core.ready("Reprisal", 403) and target then
                        bp.queue.add("Reprisal", player)

                    -- PHALANX.
                    elseif bp.buffs.get('auto_phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", player)

                    -- ENLIGHT.
                    elseif bp.buffs.get('auto_enlight') then
                        local jp = bp.__player.jp().jp_spent

                        if jp >= 100 then

                            if bp.core.ready("Enlight II", 274) then
                                bp.queue.add("Enlight II", player)

                            end

                        elseif bp.__player.mlvl() >= 85 then

                            if bp.core.ready("Enlight", 274) then
                                bp.queue.add("Enlight", player)

                            end

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    if target and bp.combat.get('auto_job_abilities') then

                        -- MAJESTY.
                        if bp.abilities.get('auto_majesty') and bp.core.ready("Majesty", 621) then
                            bp.queue.add("Majesty", player)

                        end

                        -- SENTINEL.
                        if bp.abilities.get('auto_sentinel') and bp.core.ready("Sentinel", 62) then
                            bp.queue.add("Sentinel", player)

                        -- RAMPART.
                        elseif bp.abilities.get('auto_rampart') and bp.core.ready("Rampart", 623) then
                            bp.queue.add("Rampart", player)

                        -- FEALTY.
                        elseif bp.abilities.get('auto_fealty') and bp.core.ready("Fealty", 344) then
                            bp.queue.add("Fealty", player)

                        -- PALISADE.
                        elseif bp.abilities.get('auto_palisade') and bp.core.ready("Palisade", 478) then
                            bp.queue.add("Palisade", player)

                        end

                    end

                end

                if bp.actions.canCast() then

                    -- CRUSADE.
                    if bp.buffs.get('auto_crusade') and bp.core.ready("Crusade", 289) then
                        bp.queue.add("Crusade", player)
                    end

                    -- REPRISAL.
                    if bp.buffs.get('auto_reprisal') and bp.core.ready("Reprisal", 403) and target then
                        bp.queue.add("Reprisal", player)

                    -- PHALANX.
                    elseif bp.buffs.get('auto_phalanx') and bp.core.ready("Phalanx", 116) then
                        bp.queue.add("Phalanx", player)

                    -- ENLIGHT.
                    elseif bp.buffs.get('auto_enlight') then
                        local jp = bp.__player.jp().jp_spent

                        if jp >= 100 then

                            if bp.core.ready("Enlight II", 274) then
                                bp.queue.add("Enlight II", player)

                            end

                        elseif bp.__player.mlvl() >= 85 then

                            if bp.core.ready("Enlight", {274,275}) then
                                bp.queue.add("Enlight", player)

                            end

                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()
        return self

    end

    function self:enmity()
        local enmity = bp.combat.get('auto_enmity_generation')

        if enmity and enmity.enabled and bp.core.timer('enmity'):ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.combat.get('auto_flash') and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if bp.abilities.get('auto_divine_emblem') and bp.core.ready("Divine Emblem", 438) then
                            bp.queue.add("Divine Emblem", target)
                        
                        end
                        bp.queue.add("Flash", target)
                        bp.core.timer('enmity'):update()

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canCast() then

                    -- FLASH.
                    if bp.combat.get('auto_flash') and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if bp.abilities.get('auto_divine_emblem') and bp.core.ready("Divine Emblem", 438) then
                            bp.queue.add("Divine Emblem", target)
                        
                        end
                        bp.queue.add("Flash", target)
                        bp.core.timer('enmity'):update()

                    end

                end

            end

        end

        return self

    end

    function self:nuke()
        return self

    end
    
    return self

end
return load