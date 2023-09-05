-- simple save/load mod tested on Legacy
-- saves position on /save
-- restores position on /load
-- resets speed to 0
-- saves and loads amount of stamina
-- loads angles (/load_noangles to only load position)

-- hazz
-- May 2023

local modname = "SaveLoad"
local version = 1.1
local playerPositions = {}
local playerAngles = {}
local playerSprints = {}
-- dummy teleporter, keep far away so people don't accidentally run into it
local teleporterPosition = {60606, 60606, 60606}

function savePosition(clientNum)
	pos = et.gentity_get(clientNum, "ps.origin")
	playerPositions[clientNum] = pos
	sprint = et.gentity_get(clientNum, "ps.stats", et.STAT_SPRINTTIME)
	playerSprints[clientNum] = sprint +.0
	angles = et.gentity_get(clientNum, "ps.viewangles")
	playerAngles[clientNum] = angles
end

function loadPosition(clientNum, withAngles)
	if playerPositions[clientNum] == nil then
		return
	end

	-- using teleporter also when not loading angles,
	--+because it prevents lerping (trigger_teleport is predicted)
	et.G_SetSpawnVar(destNum, "origin", playerPositions[clientNum])
	if withAngles then
		et.G_SetSpawnVar(destNum, "angle", playerAngles[clientNum])
	else
		currentAngles = et.gentity_get(clientNum, "ps.viewangles")
		et.G_SetSpawnVar(destNum, "angle", currentAngles)
	end
	et.gentity_set(clientNum, "ps.origin", teleporterPosition)

	-- reset speed so you don't have to load more than once
	et.gentity_set(clientNum, "ps.velocity", {0, 0, 0})

	-- restore sprint to what it was when saved
	-- could also load with full sprint, but
	-- sometimes you wanna try jumps with a certain amount of sprint
	sprint = playerSprints[clientNum]
	et.gentity_set(clientNum, "ps.stats", et.STAT_SPRINTTIME, sprint)
end

-- callbacks
function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname(modname .. " " .. version .. " " .. et.FindSelf())
end

function et_ClientCommand(clientNum, command)
	command = string.lower(command)
	if command == "save" then
		savePosition(clientNum)
		return 1
	end
	if command == "load" then
		loadPosition(clientNum, true)
		return 1
	end
	if command == "load_noangles" then
		loadPosition(clientNum, false)
		return 1
	end
end

function et_SpawnEntitiesFromString()
	destNum = et.G_CreateEntity("scriptname \"load_dest\" origin \"1234 123 123\" angle \"123 123 123\" classname \"misc_teleporter_dest\" targetname \"saveload_dest\"")
	et.G_CreateEntity("scriptname \"load_trig\" origin \""..table.concat(teleporterPosition, " ").."\" mins \"-8 -8 -32\" maxs \"8 8 32\" classname \"trigger_teleport\" target \"saveload_dest\"")
end

