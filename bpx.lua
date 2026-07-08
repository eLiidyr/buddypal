-- bpx FFXI Addon
-- Entry point loaded by Windower/Ashita. Loads the C++ DLL first, then
-- initiates the per-session auth + RAM-load sequence for the class bundle.
--
-- IMPORTANT: This file follows strict standard Lua 5.1 conventions.
-- Do NOT use Lua 5.2+ features (no goto, no <const>, no integer division //).
--
-- luacheck: ignore windower

---@diagnostic disable: undefined-global

_addon         = _addon or {}
_addon.name     = 'bpx'
_addon.author   = 'eLiidyr'
_addon.version  = '0.20260708'
_addon.command  = 'bpx'
_addon.commands = {'bpx', 'bp'}

-- Windower sets _addon.path to the addon folder path (with trailing slash).
-- If for any reason it is nil (e.g. loaded outside Windower), fall back to
-- a relative path so the error is clear rather than a concat crash.
if not _addon.path then
    _addon.path = windower and windower.addon_path or './'
end

-- â”€â”€ DLL Bootstrap â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

-- Load bpx.dll by full path and call the luaopen_BPX entry point explicitly.
-- package.loadlib returns the C function on success, nil + error on failure.
local dll_path  = _addon.path .. 'bpx.dll'
local loader, load_err = package.loadlib(dll_path, 'luaopen_BPX')
if not loader then
    error('[bpx] Cannot load bpx.dll: ' .. tostring(load_err))
    return
end
local bpx = loader()

-- â”€â”€ Auth + Bundle Load â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

-- bpx.init() in DEV mode: does Winsock + game-pointer scan + WS connect only.
-- Bundle loading is done HERE in bpx.lua so the chunk runs in Windower's
-- per-addon sandbox where windower.* and other proxies behave correctly.
-- In RELEASE mode the C side still loads the bundle from server bytecode.
local ok, init_warn = bpx.init()
if not ok then
    error('[bpx] Initialisation failed: ' .. tostring(init_warn))
    return
end
if init_warn then
    windower.add_to_chat(167, '[BPX] WARNING: ' .. tostring(init_warn))
end

-- RELEASE: bpx.init() fetched the bundle bytecode from the server (channel
-- selected via %APPDATA%\Buddypal\bundle_channel) and left the factory
-- function in the DLL's registry ref — retrieve it via bpx.get_bundle().
-- DEV: nothing is in the registry yet; load the bundle from disk in this
-- sandbox instead. Try bundle.luac first then fall back to bundle.lua —
-- dev ships source because our luac51.exe produces bytecode that Windower's
-- custom Lua 5.1 VM rejects with "bad code in precompiled chunk".
local factory = bpx.get_bundle and bpx.get_bundle()
if type(factory) ~= 'function' then
    local chunk, bundle_err
    for _, fname in ipairs({ 'bundle.luac', 'bundle.lua' }) do
        chunk, bundle_err = loadfile(_addon.path .. fname)
        if chunk then break end
    end
    if not chunk then
        error('[bpx] Cannot load bundle.luac/bundle.lua: ' .. tostring(bundle_err))
        return
    end
    local exec_ok
    exec_ok, factory = pcall(chunk)
    if not exec_ok then
        error('[bpx] Bundle chunk failed: ' .. tostring(factory))
        return
    end
end
if type(factory) ~= 'function' then
    error('[bpx] Bundle must return a factory function (got ' .. type(factory) .. ').')
    return
end

-- Invoke the factory with all injected dependencies. The factory body runs
-- here in bpx.lua's sandbox, so its captured upvalues for windower/bpx/etc
-- are always the correct proxies regardless of where the chunk was loaded.
local ok_factory, bundle = pcall(factory, {
    windower = windower,
    bpx      = bpx,
    addon    = _addon,
})
if not ok_factory then
    error('[bpx] Bundle factory failed: ' .. tostring(bundle))
    return
end
if type(bundle) ~= 'table' then
    error('[bpx] Bundle factory must return a table (got ' .. type(bundle) .. ').')
    return
end

-- Hand the resolved bundle table to the DLL so BPX.get_bundle() and the
-- log-forwarding path can find it.
if bpx.set_bundle then
    bpx.set_bundle(bundle)
end

-- Fire on_load directly now that everything is wired.
-- (Registering 'load' via register_event is unreliable for //lua load reloads.)
if bundle.on_load then
    local ok, err = pcall(bundle.on_load)
    if not ok then
        windower.add_to_chat(167, '[BPX] on_load error: ' .. tostring(err))
    end
end

-- â”€â”€ Event Registration â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

-- Delegate all Windower/Ashita events to the bundle's handlers if present.

windower.register_event('unload', function()
    if bundle.on_unload then
        local ok, err = pcall(bundle.on_unload)
        if not ok then
            windower.add_to_chat(167, '[BPX] on_unload error: ' .. tostring(err))
        end
    end
    -- Stop the WebSocket thread and release all DLL resources so Windower
    -- can FreeLibrary cleanly without the background thread keeping bpx.dll mapped.
    local ok, err = pcall(bpx.shutdown)
    if not ok then
        windower.add_to_chat(167, '[BPX] shutdown error: ' .. tostring(err))
    end
end)

if bundle.on_command then
    windower.register_event('addon command', function(cmd, ...)
        windower.add_to_chat(207, '[BPX-DBG] cmd received: ' .. tostring(cmd))
        local ok, err = pcall(bundle.on_command, cmd, ...)
        if not ok then
            windower.add_to_chat(167, '[BPX] command error: ' .. tostring(err))
        end
    end)
end

if bundle.on_ipc then
    windower.register_event('ipc message', function(msg)
        local ok, err = pcall(bundle.on_ipc, msg)
        if not ok then
            windower.add_to_chat(167, '[BPX] ipc error: ' .. tostring(err))
        end
    end)
end
