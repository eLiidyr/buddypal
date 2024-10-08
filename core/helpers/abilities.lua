local function helper(bp, events)
    local o = {events=events}

    -- Private Variables.
    local settings = bp.__settings.new(string.format("abilities/%s%s", bp.__player.mjob(true), bp.__player.sjob(true)))
    local base = {

        WAR={
            __mainonly              ={'auto_mighty_strikes','auto_brazen_rush','auto_retaliation','auto_tomahawk','auto_restraint','auto_blood_rage'},
            auto_provoke            =false,
            auto_berserk            =false,
            auto_defender           =false,
            auto_warcry             =false,
            auto_aggressor          =false,
            auto_retaliation        =false,
            auto_warriors_charge    =false,
            auto_tomahawk           =false,
            auto_restraint          =false,
            auto_blood_rage         =false,
            auto_mighty_strikes     =false,
            auto_brazen_rush        =false
        },
    
        MNK={
            __mainonly              ={''},
            auto_chakra             ={enabled=false, hpp=45},
            auto_impetus            =false,
            auto_footwork           =false,
            auto_chi_blast          =false,
            auto_dodge              =false,
            auto_focus              =false,
            auto_counterstance      =false,
            auto_mantra             =false,
            auto_formless_strikes   =false,
            auto_perfect_counter    =false,
            auto_hundred_fists      =false,
            auto_inner_strength     =false,
        },
    
        WHM={
            __mainonly              ={''},
            auto_benediction        ={enabled=false, mpp=35, targets=3, weight=1800},
            auto_martyr             ={enabled=false, hpp=45, target=""},
            auto_devotion           ={enabled=false, mpp=45, target=""},
            auto_divine_seal        =false,
            auto_solace             =false,
            auto_misery             =false,
            auto_sacrosanctity      =false,
            auto_sacrifice          =false,
            auto_asylum             =false,
        },
    
        BLM={
            __mainonly              ={''},
            auto_cascade            ={enabled=false, target="", tp=1000},
            auto_elemental_seal     =false,
            auto_mana_wall          =false,
            auto_enmity_douse       =false,
            auto_manawell           =false,
            auto_manafont           =false,
            auto_subtle_sorcery     =false,
        },
    
        RDM={
            __mainonly              ={''},
            auto_convert            ={enabled=false, mpp=55, hpp=55},
            auto_composure          =false,
            auto_saboteur           =false,
            auto_spontaneity        =false,
            auto_chainspell         =false,
            auto_stymie             =false,
        },
    
        THF={
            __mainonly              ={''},
            auto_steal              =false,
            auto_sneak_attack       =false,
            auto_trick_attack       =false,
            auto_mug                =false,
            auto_assassins_charge   =false,
            auto_feint              =false,
            auto_despoil            =false,
            auto_conspirator        =false,
            auto_bully              =false,
            auto_perfect_dodge      =false,
            auto_larceny            =false,
        },
    
        PLD={
            __mainonly              ={''},
            auto_chivalry           ={enabled=false, mpp=55, tp=1500},
            auto_cover              ={enabled=false, target=""},
            auto_divine_emblem      =false,
            auto_holy_circle        =false,
            auto_shield_bash        =false,
            auto_sentinel           =false,
            auto_rampart            =false,
            auto_majesty            =false,
            auto_fealty             =false,
            auto_sepulcher          =false,
            auto_palisade           =false,
            auto_invincible         =false,
            auto_intervene          =false,
        },
    
        DRK={
            __mainonly              ={''},
            auto_dark_seal          ={enabled=false, name="Drain III"},
            auto_arcane_circle      =false,
            auto_last_resort        =false,
            auto_weapon_bash        =false,
            auto_souleater          =false,
            auto_consume_mana       =false,
            auto_diabolic_eye       =false,
            auto_nether_void        =false,
            auto_arcane_crest       =false,
            auto_scarlet_delirium   =false,
            auto_blood_weapon       =false,
            auto_soul_enslavement   =false,
        },
    
        BST={
            __mainonly              ={''},
            auto_reward             ={enabled=false, hpp=55},
            auto_ready              ={enabled=false, moves=""},
            auto_call_beast         =false,
            auto_bestial_loyalty    =false,
            auto_killer_instinct    =false,
            auto_fight              =false,
            auto_snarl              =false,
            auto_spur               =false,
            auto_run_wild           =false,
            auto_unleash            =false,
        },
    
        RNG={
            __mainonly              ={''},
            auto_decoy_shot         ={enabled=false, target=""},
            auto_sharpshot          =false,
            auto_scavenge           =false,
            auto_camouflage         =false,
            auto_barrage            =false,
            auto_velocity_shot      =false,
            auto_unlimited_shot     =false,
            auto_flashy_shot        =false,
            auto_stealth_shot       =false,
            auto_double_shot        =false,
            auto_bounty_shot        =false,
            auto_hover_shot         =false,
            auto_eagle_eye_shot     =false,
            auto_overkill           =false,
        },
    
        SMN={
            __mainonly              ={''},
            auto_elemental_siphon   ={enabled=false, mpp=55},
            auto_apogee             =false,
            auto_mana_cede          =false,
            auto_assault            =false,
            auto_astral_flow        =false,
            auto_astral_conduit     =false,
        },
    
        SAM={
            __mainonly              ={''},
            auto_shikikoyo          ={enabled=false, tp=1500, target=""},
            auto_warding_circle     =false,
            auto_third_eye          =false,
            auto_hasso              =false,
            auto_meditate           =false,
            auto_seigan             =false,
            auto_sekkanoki          =false,
            auto_konzen_ittai       =false,
            auto_blade_bash         =false,
            auto_sengikori          =false,
            auto_hamanoha           =false,
            auto_hagakure           =false,
            auto_meikyo_shisui      =false,
            auto_yaegasumi          =false,
        },
    
        NIN={
            __mainonly              ={''},
            auto_yonin              =false,
            auto_innin              =false,
            auto_sange              =false,
            auto_futae              =false,
            auto_issekigan          =false,
            auto_mikage             =false,
        },
    
        DRG={
            __mainonly              ={''},
            auto_restoring_breath   ={enabled=false, hpp=55},
            auto_call_wyvern        =false,
            auto_ancient_circle     =false,
            auto_jump               =false,
            auto_high_jump          =false,
            auto_super_jump         =false,
            auto_spirit_jump        =false,
            auto_soul_jump          =false,
            auto_angon              =false,
            auto_dragon_breaker     =false,
            auto_deep_breathing     =false,
            auto_smiting_breath     =false,
            auto_steady_wing        =false,
            auto_spirit_surge       =false,
            auto_fly_high           =false,
        },
    
        BLU={
            __mainonly              ={'auto_diffusion','auto_unbridled_wisdom','auto_unbridled_learning','auto_convergence','auto_azure_lore'},
            auto_diffusion          ={enabled=false, name="Mighty Guard"},
            auto_unbridled_wisdom   ={enabled=false, mode=1},
            auto_unbridled_learning ={enabled=false, mode=1},
            auto_burst_affinity     =false,
            auto_chain_affinity     =false,
            auto_convergence        =false,
            auto_efflux             =false,
            auto_azure_lore         =false,
        },
    
        COR={
            __mainonly              ={''},
            auto_quick_draw         ={enabled=false, name="Light Shot"},
            auto_crooked_cards      =false,
            auto_random_deal        =false,
            auto_triple_shot        =false,
            auto_wild_card          =false,
            auto_cutting_cards      =false,
        },
    
        PUP={
            __mainonly              ={''},
            auto_repair             ={enabled=false, hpp=55},
            auto_activate           =false,
            auto_cooldown           =false,
            auto_deploy             =false,
            auto_overdrive          =false,
            auto_heady_artifice     =false,
        },
    
        DNC={
            __mainonly              ={''},
            auto_sambas             ={enabled=false, name="Haste Samba"},
            auto_steps              ={enabled=false, name="Quickstep", delay=30},
            auto_animated_flourish  =false,
            auto_violent_flourish   =false,
            auto_reverse_flourish   =false,
            auto_building_flourish  =false,
            auto_wild_flourish      =false,
            auto_climactic_flourish =false,
            auto_striking_flourish  =false,
            auto_ternary_flourish   =false,
            auto_contradance        =false,
            auto_saber_dance        =false,
            auto_fan_dance          =false,
            auto_no_foot_rise       =false,
            auto_presto             =false,
            auto_trance             =false,
            auto_grand_pas          =false,
        },
    
        SCH={
            __mainonly              ={''},
            auto_embrava            ={enabled=false, target=""},
            auto_sublimation        ={enabled=false, mpp=65},
            auto_light_arts         =false,
            auto_addendum           =false,
            auto_modus_veritas      =false,
            auto_enlightenment      =false,
            auto_tabula_rasa        =false,
            auto_kaustra            =false,
        },
    
        GEO={
            __mainonly              ={''},
            auto_full_circle        ={enabled=false, distance=22},
            auto_radial_arcana      ={enabled=false, mpp=55},
            auto_mending_halation   ={enabled=false, hpp=55},
            auto_life_cycle         ={enabled=false, hpp=55},
            auto_theurgic_focus     =false,
            auto_lasting_emanation  =false,
            auto_ecliptic_attrition =false,
            auto_blaze_of_glory     =false,
            auto_dematerialize      =false,
            auto_bolster            =false,
            auto_widened_compass    =false,
        },
    
        RUN={
            __mainonly              ={''},
            auto_vivacious_pulse    ={enabled=false, hpp=55, mpp=55},
            auto_embolden           ={enabled=false, name="Temper"},
            auto_vallation          =false,
            auto_swordplay          =false,
            auto_swipe              =false,
            auto_lunge              =false,
            auto_pflug              =false,
            auto_valiance           =false,
            auto_gambit             =false,
            auto_battuta            =false,
            auto_rayke              =false,
            auto_liement            =false,
            auto_one_for_all        =false,
            auto_elemental_sforzo   =false,
            auto_odyllic_subterfuge =false,
        },

    }

    -- Public Variables.

    -- Private Methods.
    local function onload()
        settings:check(base):update()

    end

    -- Public Methods.
    o.get = function(k)
        return settings:get(k)

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

            end

        end

    end)

    -- Class Specific Events.
    o.onLoad = onload

    return o

end
return helper