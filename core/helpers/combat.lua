local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings = bp.__settings.new(string.format("combat/%s%s", bp.__player.mjob(true), bp.__player.sjob(true)))
    local base = {

        WAR={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            set_max_buff_limit = 0,
            auto_sanguine_blade = {enabled=false, hpp=45},
            auto_moonlight = {enabled=false, mpp=45},
        },
    
        MNK={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            set_max_buff_limit = 0,
        },
    
        WHM={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            set_max_buff_limit = 0,
            auto_status_fixes = false,
            auto_moonlight = {enabled=false, mpp=45},
            auto_repose = false,
        },
    
        BLM={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_drain = {enabled=false, hpp=55},
            auto_aspir = {enabled=false, mpp=55},
            auto_myrkr = {enabled=false, mpp=45},
            auto_sleep = false,
            auto_sleepga = false,
        },
    
        RDM={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_sanguine_blade = {enabled=false, hpp=55},
            auto_dispel = false,
            auto_sleep = false,
        },
    
        THF={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            force_sneak_attack_ws = false,
            force_trick_attack_ws = false,
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        PLD={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_sanguine_blade = {enabled=false, hpp=55},
            auto_moonlight = {enabled=false, mpp=45},
            auto_flash = false,
        },
    
        DRK={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_drain = {enabled=false, hpp=55},
            auto_aspir = {enabled=false, mpp=55},
            auto_sanguine_blade = {enabled=false, hpp=55},
            auto_moonlight = {enabled=false, mpp=45},
        },
    
        BST={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },

        BRD={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_foe_lullaby = false,
            auto_horde_lullaby = false,
            auto_finale = false,
        },
    
        RNG={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        SMN={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_buffing = false,
            auto_debuffing = false,
            set_max_buff_limit = 0,
            auto_summon = {enabled=false, name="Carbuncle"},
            auto_bp_rage = {enabled=false, pacts={["Ifrit"]="Flaming Crush"}},
            auto_bp_ward = {enabled=false, pacts={["Ifrit"]="Crimson Howl"}},
            auto_myrkr = {enabled=false, mpp=45},
            auto_rotate = false,
            auto_pact_magic_burst = false,
        },
    
        SAM={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_moonlight = {enabled=false, mpp=45},
        },
    
        NIN={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        DRG={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        BLU={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_sanguine_blade = {enabled=false, hpp=55},
            auto_moonlight = {enabled=false, mpp=45},
            auto_magic_hammer = false,
            auto_sleepga = false,
        },
    
        COR={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        PUP={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_deploy_on_aggro = false,
            auto_target_on_aggro = false,
            auto_assist_master = false,
            dad_method_enabled = false,
        },
    
        DNC={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
        },
    
        SCH={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_status_fixes = false,
            auto_drain = {enabled=false, hpp=55},
            auto_aspir = {enabled=false, mpp=55},
            auto_myrkr = {enabled=false, mpp=45},
            auto_schchain = {enabled=false, mode="Fusion"},
        },
    
        GEO={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_drain = {enabled=false, hpp=55},
            auto_aspir = {enabled=false, mpp=55},
            auto_moonlight = {enabled=false, mpp=45},
        },
    
        RUN={
            __mainonly ={''},
            auto_aftermath = {enabled=false, level=3},
            auto_range_weaponskill = {enabled=false, tp=1000, name="Hot Shot"},
            auto_melee_weaponskill = {enabled=false, tp=1000, name="Combo"},
            weaponskill_limiter = {enabled=false, hpp=10, option=">"},
            auto_food = {enabled=false, name=""},
            auto_enmity_generation = {enabled=false, delay=2},
            allow_aoe_enmity_spells = false,
            auto_one_hours = false,
            auto_job_abilities = false,
            auto_ranged_attacks = false,
            auto_buffing = false,
            auto_debuffing = false,
            tank_mode = false,
            nuke_mode = false,
            set_max_buff_limit = 0,
            auto_sanguine_blade = {enabled=false, hpp=55},
        },

    }

    do -- Setup default setting values.

    end

    -- Public Variables.

    -- Private Methods.
    local function updateSettings()
        local data = T(base):key_filter(function(key) return S{bp.__player.mjob(), bp.__player.sjob()}:contains(key) end)

        for k, v in pairs(base) do
                
            if type(v) == 'table' then
                
                for kk, vv in pairs(v) do
                    
                    if kk ~= '__mainonly' and settings[kk] == nil then

                        if (k == bp.__player.mjob() or (k == bp.__player.sjob() and not S(v.__mainonly):contains(kk))) then
                            settings[kk] = settings:default(kk, vv)

                        end

                    end

                end

            end

        end
        settings:save()

    end

    local function onload()
        updateSettings()
        settings:update()

    end

    local function handle_weaponskills()
        local target = bp.targets.get('player')
        local status = bp.__player.status()

        if status == 1 or (status == 0 and target) then
            local target = (status == 1) and bp.__target.get('t') or target or false
            local limits = settings:get('weaponskill_limiter')
            local wskill = settings:get('auto_melee_weaponskill')
            local rskill = settings:get('auto_range_weaponskill')

            -- Handle HP% Limiting weapon skills.
            if target and limits and limits.enabled then

                if limits.option == '>' and target.hpp < limits.hpp then
                    return

                elseif limits.option == '<' and target.hpp > limits.hpp then
                    return

                end

            end

            -- Handle Skillchains.

            -- Handle melee distance weapon skills.
            if target and wskill and wskill.enabled and bp.__target.inRange(target) and bp.actions.canAct() then

                -- Handle Sanguine Blade.
                if settings:get('auto_sanguine_blade') then
                    local sanguine  = settings:get('auto_sanguine_blade')

                    if sanguine.enabled and bp.__player.hpp() <= sanguine.hpp then
                        
                        if bp.actions.isReady("Sanguine Blade") and bp.actions.inActionRange("Sanguine Blade", target) then

                            if bp.__player.tp() >= wskill.tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                                bp.queue.add("Sanguine Blade", target)

                            end

                        end
                        return

                    end

                end

                -- Handle Myrkr.
                if settings:get('auto_myrkr') then
                    local myrkr = settings:get('auto_myrkr')

                    if myrkr.enabled and bp.__player.mpp() <= myrkr.mpp and bp.core.ready("Myrkr") and bp.actions.inActionRange("Myrkr", target) then

                        if bp.__player.tp() >= wskill.tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                            bp.queue.add("Myrkr", bp.__player.get())
                            return

                        end

                    end

                end

                -- Handle Moonlight/Starlight.
                if settings:get('auto_moonlight') then
                    local moonlight = settings:get('auto_moonlight')

                    if moonlight.enabled and bp.__player.mpp() <= moonlight.mpp and (bp.core.ready("Moonlight") or bp.core.ready("Starlight")) and (bp.actions.inActionRange("Moonlight", target) or bp.actions.inActionRange("Starlight", target)) then

                        if bp.__player.tp() >= wskill.tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
    
                            if bp.core.ready("Moonlight") then
                                bp.queue.add("Moonlight", bp.__player.get())
                                return
    
                            elseif bp.core.ready("Starlight") then
                                bp.queue.add("Starlight", bp.__player.get())
                                return
    
                            end
    
                        end

                    end

                end

                do

                    local index, count, id, status, bag, resource = bp.__aftermath.getWeapon()
                    local aftermath = settings:get('auto_aftermath')
                    
                    if index and resource and aftermath and not bp.__aftermath.active() and bp.__player.tp() >= (aftermath.level * 1000) and bp.__aftermath.weaponskill(resource.en) and bp.actions.inActionRange(bp.__aftermath.weaponskill(resource.en), target) then
                        bp.queue.add(bp.__aftermath.weaponskill(resource.en), target)

                    elseif (aftermath and bp.__aftermath.active()) or not aftermath or not bp.__aftermath.weaponskill(resource.en) or bp.__buffs.active({168,189}) then

                        if bp.__player.tp() >= wskill.tp then
                            bp.queue.add(wskill.name, target)

                        end

                    end
                    
                end

            -- Handle ranged distance weapon skills.
            elseif target and rskill and rskill.enabled and bp.actions.canAct() then

                -- Handle Myrkr.
                if settings:get('auto_myrkr') then
                    local myrkr = settings:get('auto_myrkr')

                    if myrkr.enabled and bp.__player.mpp() <= myrkr.mpp and bp.core.ready("Myrkr") and bp.actions.inActionRange("Myrkr", target) then

                        if bp.__player.tp() >= wskill.tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
                            bp.queue.add("Myrkr", bp.__player.get())
                            return

                        end

                    end

                end

                -- Handle Moonlight/Starlight.
                if settings:get('auto_moonlight') then
                    local moonlight = settings:get('auto_moonlight')

                    if moonlight.enabled and bp.__player.mpp() <= moonlight.mpp and (bp.core.ready("Moonlight") or bp.core.ready("Starlight")) and (bp.actions.inActionRange("Moonlight", target) or bp.actions.inActionRange("Starlight", target)) then

                        if bp.__player.tp() >= wskill.tp or (bp.__player.tp() >= 1000 and bp.__buffs.active({168,189})) then
    
                            if bp.core.ready("Moonlight") then
                                bp.queue.add("Moonlight", bp.__player.get())
                                return
    
                            elseif bp.core.ready("Starlight") then
                                bp.queue.add("Starlight", bp.__player.get())
                                return
    
                            end
    
                        end

                    end

                end

                do

                    local index, count, id, status, bag, resource = bp.__aftermath.getWeapon()
                    local aftermath = settings:get('auto_aftermath')
                    
                    if index and resource and aftermath and not bp.__aftermath.active() and bp.__player.tp() >= (aftermath.level * 1000) and bp.__aftermath.weaponskill(resource.en) and bp.actions.inActionRange(resource.en, target) then
                        bp.queue.add(bp.__aftermath.weaponskill(resource.en), target)

                    elseif (aftermath and bp.__aftermath.active()) or not aftermath or not bp.__aftermath.weaponskill(resource.en) or bp.__buffs.active({168,189}) then

                        if bp.__player.tp() >= rskill.tp then
                            bp.queue.add(rskill.name, target)

                        end

                    end
                    
                end

            end
            
        end

    end

    local function handle_ranged()
        local ranged    = settings:get('auto_ranged_attacks')
        local target    = bp.targets.get('player')
        local weapon    = bp.__equipment.get(2)
        local ammo      = bp.__equipment.get(3)

        if ranged and weapon and ammo and target and ranged.enabled and weapon.index > 0 and bp.__queue.length() then
            local index, count, id, status, bag, resource = bp.__inventory.getByIndex(weapon.bag, weapon.index)
            
            if resource and bp.res.items[id] and T{25,26}:contains(resource.skill) and not bp.__queue.inQueue({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}) then
                bp.queue.add({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}, target, 1)

            end

        end

    end

    -- Public Methods.
    o.handle_weaponskills = handle_weaponskills
    o.handle_ranged = handle_ranged

    o.get = function(k)
        return settings:get(k)

    end

    -- Private Events.
    o.events('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()

        if command and (string.match(command, 'combat/%a%a%a%a%a%a')) then

            if settings[commands[1]] ~= nil then
                local key, data, value = settings:fetch(commands)

                if data[key] ~= nil then

                    if S{'true','false'}:contains(value) then
                        data[key] = (value == 'true')
                        settings:save()

                    elseif tonumber(value) then
                        data[key] = tonumber(value)
                        settings:save()

                    elseif type(value) == 'string' then
                        data[key] = value
                        settings:save()

                    end

                end

            else

                local command = commands[1] and table.remove(commands, 1):lower()

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper