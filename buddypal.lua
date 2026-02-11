_addon.name    = 'buddypal'
_addon.author  = 'Eliidyr'
_addon.command = 'bp'
local buddypal = assert(package.loadlib(string.format("%splugin.dll", windower.addon_path):gsub('\\', '/'), "luaopen_Buddypal"))()
local init     = buddypal.install(windower.addon_path, 1)
init(buddypal)
buddypal.connect(windower.addon_path)
