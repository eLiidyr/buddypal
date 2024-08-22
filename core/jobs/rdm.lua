local function load(bp, settings)
    local self = {}

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return false

    end

    -- Public Methods.
    function self:specials()
        local player = bp.__player.get()
        local target = bp.targets.get('player')

        if player and target and bp.core.get('job-abilities') and bp.core.get('one-hours') and bp.actions.canAct() then
            local target = bp.targets.get('player')

            -- ONE-HOURS.
            if bp.core.get('chainspell') and bp.core.ready("Chainspell", 48) then
                bp.queue.add("Chainspell", player)

            end
            
            if bp.core.get('stymie') and bp.core.ready("Stymie", 494) then
                bp.queue.add("Stymie", player)

            end

        end

        return self

    end

    function self:abilities()

        if bp.core.get('job-abilities') and bp.actions.canAct() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                -- CONVERT.
                if bp.core.get('convert') and bp.core.get('convert').enabled and bp.__player.hpp() >= bp.core.get('convert').hpp and bp.__player.mpp() <= bp.core.get('convert').mpp then
                                
                    if bp.core.ready("Convert") then
                        bp.queue.add("Convert", player)

                    end
                    
                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                -- CONVERT.
                if bp.core.get('convert') and bp.core.get('convert').enabled and bp.__player.hpp() >= bp.core.get('convert').hpp and bp.__player.mpp() <= bp.core.get('convert').mpp then
                                
                    if bp.core.ready("Convert") then
                        bp.queue.add("Convert", player)

                    end
                    
                end

            end

        end

        return self

    end

    function self:buff()

        if bp.core.get('buffing') then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

                if bp.actions.canAct() then

                    -- COMPOSURE.
                    if bp.core.get('composure') and bp.core.ready("Composure", 419) then
                        bp.queue.add("Composure", player)

                    end

                end

                if bp.actions.canCast() then
                    local composure = bp.core.get('composure')

                    if ((composure and bp.__buffs.active(419)) or not composure) then
                    
                        -- HASTE.
                        if bp.core.get('haste') and not bp.__buffs.active(33) and bp.__player.mlvl() >= 48 then
                            
                            if bp.__player.mlvl() >= 96 then
                                
                                if bp.core.ready("Haste II") then
                                    bp.queue.add("Haste II", player)

                                end

                            elseif bp.__player.mlvl() < 96 and bp.core.ready("Haste") then
                                bp.queue.add("Haste", player)

                            end
                        
                        end

                        -- TEMPER.
                        if bp.core.get('temper') and not bp.__buffs.active(432) and bp.__player.mlvl() >= 95 and target then
                            local spent = bp.__player.jp().jp_spent

                            if spent >= 1200 and bp.core.ready("Temper II") then
                                bp.queue.add("Temper II", player)

                            elseif spent < 1200 and bp.core.ready("Temper") then
                                bp.queue.add("Temper", player)

                            end

                        end

                        -- GAINS.
                        if bp.core.get('gain') and bp.core.get('gain').enabled and not bp.__buffs.hasWHMBoost() and bp.core.ready(bp.core.get('gain').name) then
                            bp.queue.add(bp.core.get('gain').name, player)

                        end
                        
                        -- PHALANX.
                        if bp.core.get('phalanx') and bp.core.ready("Phalanx", 116) then
                            bp.queue.add("Phalanx", player)

                        end
                            
                        -- REFRESH.
                        if bp.core.get('refresh') and not bp.__buffs.active({43,187,188}) then
                            local spent = bp.__player.jp().jp_spent

                            if spent >= 1200 and bp.core.ready("Refresh III") then
                                bp.queue.add("Refresh III", player)

                            elseif bp.__player.mlvl() >= 82 and spent < 1200 and bp.core.ready("Refresh II") then
                                bp.queue.add("Refresh II", player)

                            elseif bp.__player.mlvl() < 82 and bp.core.ready("Refresh") then
                                bp.queue.add("Refresh", player)
                            
                            end

                        end
        
                        -- ENSPELLS.
                        if bp.core.get('en') and bp.core.get('en').enabled and bp.core.ready(bp.core.get('en').name) and not bp.__buffs.hasEnspell() and target then
                            bp.queue.add(bp.core.get('en').name, player)

                        end

                    end

                end

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

                if bp.actions.canAct() then

                    -- COMPOSURE.
                    if bp.core.get('composure') and bp.core.ready("Composure", 419) then
                        bp.queue.add("Composure", player)

                    end

                end

                if bp.actions.canCast() then
                    local composure = bp.core.get('composure')

                    if ((composure and bp.__buffs.active(419)) or not composure) then
                    
                        -- HASTE.
                        if bp.core.get('haste') and not bp.__buffs.active(33) and bp.__player.mlvl() >= 48 then
                            
                            if bp.__player.mlvl() >= 96 then
                                
                                if bp.core.ready("Haste II") then
                                    bp.queue.add("Haste II", player)

                                elseif not bp.__player.hasSpell('Haste II') then
                                    bp.queue.add("Haste", player)

                                end

                            elseif bp.__player.mlvl() < 96 and bp.core.ready("Haste") then
                                bp.queue.add("Haste", player)

                            end
                        
                        end

                        -- TEMPER.
                        if bp.core.get('temper') and not bp.__buffs.active(432) and bp.__player.mlvl() >= 95 and target then
                            local spent = bp.__player.jp().jp_spent

                            if spent >= 1200 and bp.core.ready("Temper II") then
                                bp.queue.add("Temper II", player)

                            elseif spent < 1200 and bp.core.ready("Temper") then
                                bp.queue.add("Temper", player)

                            end

                        end

                        -- GAINS.
                        if bp.core.get('gain') and bp.core.get('gain').enabled and not bp.__buffs.hasWHMBoost() and bp.core.ready(bp.core.get('gain').name) then
                            bp.queue.add(bp.core.get('gain').name, player)

                        end
                        
                        -- PHALANX.
                        if bp.core.get('phalanx') and bp.core.ready("Phalanx", 116) then
                            bp.queue.add("Phalanx", player)

                        end
                            
                        -- REFRESH.
                        if bp.core.get('refresh') and not bp.__buffs.active({43,187,188}) then
                            local spent = bp.__player.jp().jp_spent

                            if spent >= 1200 and bp.core.ready("Refresh III") then
                                bp.queue.add("Refresh III", player)

                            elseif bp.__player.mlvl() >= 82 and spent < 1200 and bp.core.ready("Refresh II") then
                                bp.queue.add("Refresh II", player)

                            elseif bp.__player.mlvl() < 82 and bp.core.ready("Refresh") then
                                bp.queue.add("Refresh", player)
                            
                            end

                        end
        
                        -- ENSPELLS.
                        if bp.core.get('en') and bp.core.get('en').enabled and bp.core.ready(bp.core.get('en').name) and not bp.__buffs.hasEnspell() and target then
                            bp.queue.add(bp.core.get('en').name, player)

                        end

                        -- SPIKES.
                        if bp.core.get('spikes') and bp.core.get('spikes').enabled and not bp.__buffs.hasSpikes() then
                            local spikes = bp.__res.get(bp.core.get('spikes').name)

                            if spikes and bp.core.ready(spikes) then
                                bp.queue.add(spikes, player)
                            end
                            
                        -- BLINK.
                        elseif bp.core.get('blink') and not bp.__buffs.hasShadows() and bp.core.ready("Blink", 36) then
                            bp.queue.add("Blink", player)

                        -- AQUAVEIL.
                        elseif bp.core.get('aquaveil') and bp.core.ready("Aquaveil", 39) then
                            bp.queue.add("Aquaveil", player)

                        -- STONESKIN.
                        elseif bp.core.get('stoneskin') and bp.core.ready("Stoneskin", 37) then
                            bp.queue.add("Stoneskin", player)
                            
                        end

                    end

                end

            end

        end

        return self

    end

    function self:debuff()

        if bp.debuffs.isEnabled() and bp.actions.canCast() then
            bp.debuffs.cast()

        end

        return self

    end

    function self:enmity()
        local timer = bp.core.timer('enmity')

        if bp.core.get('hate') and bp.core.get('hate').enabled and timer:ready() then
            local player = bp.__player.get()

            if player and player.status == 1 then
                local target = bp.__target.get('t')

            elseif player and player.status == 0 then
                local target = bp.targets.get('player')

            end

        end

        return self

    end

    function self:nuke()
        local target = bp.targets.get('player')

        if bp.core.get('nuke-mode') and target and bp.core.nukes:length() > 0 and bp.actions.canCast() then

            for spell in bp.core.nukes:it() do

                if bp.core.ready(spell) then
                    bp.queue.add(spell, target)

                end

            end

        end

        return self

    end
    
    return self

end
return load