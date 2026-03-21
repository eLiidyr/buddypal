_addon.name     = 'BuddyPal'
_addon.author   = 'eLiidyr'
_addon.version  = '0.20260321.085835'
_addon.commands = {'buddypal', 'bp'}

require('logger')

-- ─── DLL Loading ─────────────────────────────────────────────────────────────
-- Locate and load plugin.dll which provides the native API table (Buddypal).
-- The DLL handles WebSocket, HTTP requests, DPAPI token storage, entity
-- scanning, packet interception, and remote bundle fetching.
-- ─────────────────────────────────────────────────────────────────────────────

local BSLASH = string.char(92)
local FSLASH = string.char(47)

local function clean_path(base)
    if not base or base == '' then return nil end
    local p = base:gsub(BSLASH, FSLASH):gsub(FSLASH .. '+', FSLASH)
    if p:sub(-1) ~= FSLASH then p = p .. FSLASH end
    return p .. 'plugin.dll'
end

local function unique_paths(paths)
    local seen = {}
    local out = {}
    for i = 1, #paths do
        local p = paths[i]
        if p and not seen[p] then
            seen[p] = true
            out[#out + 1] = p
        end
    end
    return out
end

local dll_candidates = unique_paths({
    clean_path(windower and windower.addon_path),
    clean_path(_addon and _addon.path),
})

local ok_dll = false
local loader_or_err = nil
local selected_dll_path = nil

for i = 1, #dll_candidates do
    local dll_path = dll_candidates[i]
    local f = io.open(dll_path, 'rb')
    if f then
        f:close()
        local ok_load, load_result = pcall(function()
            return assert(package.loadlib(dll_path, 'luaopen_Buddypal'))
        end)
        if ok_load then
            ok_dll = true
            loader_or_err = load_result
            selected_dll_path = dll_path
            break
        else
            loader_or_err = tostring(load_result)
        end
    end
end

local Buddypal = nil
if ok_dll and loader_or_err then
    local ok_open, open_result = pcall(loader_or_err)
    if ok_open then
        local candidate = open_result or rawget(_G, 'Buddypal') or (package.loaded and package.loaded.Buddypal)
        if type(candidate) == 'table'
            and type(candidate.configure) == 'function'
            and type(candidate.connect) == 'function'
            and type(candidate.unhookIncoming) == 'function' then
            Buddypal = candidate
        else
            ok_dll = false
            loader_or_err = 'plugin loaded but API table was invalid'
        end
    else
        ok_dll = false
        loader_or_err = open_result
    end
end

if not ok_dll or not Buddypal then
    return
end

_G.Buddypal = Buddypal

-- ─── Configuration ───────────────────────────────────────────────────────────
-- Resolve the addon data path and server URL, then hand them to the DLL
-- via configure().  The server URL defaults to production but can be
-- overridden for local development by placing a single-line URL in
-- <addon>/data/server.txt.
-- ─────────────────────────────────────────────────────────────────────────────

local addon_data_root = (windower and windower.addon_path)
    or (_addon and _addon.path)
    or ('addons/' .. ((_addon and _addon.name) or 'buddypal') .. '/')
if addon_data_root:sub(-1) ~= '/' and addon_data_root:sub(-1) ~= '\\' then
    addon_data_root = addon_data_root .. '/'
end

local server_url = 'https://www.buddypal.live'
local server_override_path = addon_data_root .. 'data/server.txt'

local ok_sf, sf = pcall(io.open, server_override_path, 'r')
if ok_sf and sf then
    local line = sf:read('*l')
    sf:close()
    if line and line ~= '' then
        server_url = line:gsub('%s+', '')
    end
end

Buddypal.configure(server_url, addon_data_root .. 'data/')

-- ─── Remote Bundle Fetch ─────────────────────────────────────────────────────
-- The DLL's fetchBundle() performs an authenticated HTTP GET to
-- /api/v1/addon/bundle, compiles the response as Lua, and executes it in
-- the current state.  The bundle contains package.preload entries for every
-- lib/ module plus the full application entry-point (app.lua).
--
-- On failure the DLL raises a Lua error; we catch it here so the addon
-- can still respond to //bp commands with a helpful message.
-- ─────────────────────────────────────────────────────────────────────────────

local bundle_ok, bundle_err = pcall(Buddypal.fetchBundle)
if not bundle_ok then
    local msg = tostring(bundle_err or 'unknown error')
    windower.add_to_chat(167, 'BuddyPal: Failed to load remote bundle.')
    windower.add_to_chat(167, '  ' .. msg)
    windower.add_to_chat(167, 'Use //lua reload buddypal to retry.')
end
