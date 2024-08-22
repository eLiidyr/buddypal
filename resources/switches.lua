local function set_enabled(bp, settings, key, value)
    settings[key] = (value == '!')

end

local function set_number(bp, settings, key, value)
    settings[key] = tonumber(value)

end

local function set_target(bp, settings, key, value)
    print('update set target method')

end

local function set_spell(bp, settings, key, value)
    local res = bp.res.spells[tonumber(value)]

    if res then
        settings[key] = res.en

    end

end

local function set_ability(bp, settings, key, value)
    local res = bp.res.job_abilities[tonumber(value)]

    if res then
        settings[key] = res.en

    end

end

local function set_skill(bp, settings, key, value)
    local res = bp.res.weapon_skills[tonumber(value)]

    if res then
        settings[key] = res.en

    end

end

local switches = {}
switches['auto_aftermath'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, tp=set_number, level=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_melee_weaponskill'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, tp=set_number, name=set_skill}
    methods[key](bp, settings, key, value)

end

switches['auto_range_weaponskill'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, tp=set_number, name=set_skill}
    methods[key](bp, settings, key, value)

end

switches['auto_food'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)

end

switches['weaponskill_limiter'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods.option = function()
        settings[key] = (value == '<') and '<' or '>'

    end
    methods[key](bp, settings, key, value)

end

switches['auto_enmity_generation'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, delay=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_sanguine_blade'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_myrkr'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_moonlight'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_chakra'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_benediction'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number, weight=set_number, targets=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_martyr'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_devotion'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_boost'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_cascade'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, tp=set_number, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_stratagems'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)

    print('update: auto_stratagems')

end

switches['auto_spikes'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_drain'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_aspir'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_convert'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_gain'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_enspell'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_cover'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_chivalry'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mp=set_number, tp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_absorb'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_reward'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update: auto_reward')

end

switches['auto_ready'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update: auto_ready')

end

switches['auto_decoy_shot'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_elemental_siphon'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_summon'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_bp_rage'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_ability}
    methods[key](bp, settings, key, value)

end

switches['auto_bp_ward'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_ability}
    methods[key](bp, settings, key, value)

end

switches['auto_shikikoyo'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, tp=set_number, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_diffusion'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_rolls'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update rolls')

end

switches['auto_quick_draw'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_ability}
    methods[key](bp, settings, key, value)

end

switches['auto_double_up'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, max=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_repair'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_maneuvers'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_maneuvers')

end

switches['auto_secondary_maneuvers'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_secondary_maneuvers')

end

switches['auto_sambas'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_ability}
    methods[key](bp, settings, key, value)

end

switches['auto_steps'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_ability}
    methods[key](bp, settings, key, value)

end

switches['auto_skillchain'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_skillchain')

end

switches['auto_sublimation'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_embrava'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, target=set_target}
    methods[key](bp, settings, key, value)

end

switches['auto_helix'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_storms'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_bubbles'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_bubbles')

end

switches['auto_full_circle'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, distance=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_radial_arcana'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_mending_halation'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_runes'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_runes')

end

switches['auto_vivacious_pulse'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, hpp=set_number, mpp=set_number}
    methods[key](bp, settings, key, value)

end

switches['auto_embolden'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled, name=set_spell}
    methods[key](bp, settings, key, value)

end

switches['auto_nukes'] = function(bp, settings, key, value)
    local methods = {enabled=set_enabled}
    methods[key](bp, settings, key, value)
    print('update auto_nukes')

end
return switches