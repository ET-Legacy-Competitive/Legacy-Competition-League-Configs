-- change mApNAmE to mapname if needed
-- this is useful because server-side mapscripts are case-sensitive,
--+and players have control over the case of mapname

-- hazz
-- Feb 2023

local modname = "Lowercase mapname"
local version = 1.0

function getMap()
	return et.trap_Cvar_Get("mapname")
end

function setMap(map)
	et.trap_SendConsoleCommand(et.EXEC_APPEND, "map " .. map .. ";")
end

-- callbacks
function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname(modname .. " " .. version .. " " .. et.FindSelf())

	currentMap = getMap()
	if currentMap ~= string.lower(currentMap) then
		setMap(string.lower(currentMap))
	end
end

