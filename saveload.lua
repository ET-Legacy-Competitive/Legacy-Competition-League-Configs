-- simple save/load mod tested on Legacy
-- saves position on /save
-- restores position on /load
-- resets speed to 0
-- saves and loads amount of stamina

-- hazz
-- Feb 2023

local modname = "SaveLoad"
local version = 1.0
local playerPositions = {}
local playerSprints = {}

function savePosition(clientNum)
	pos = et.gentity_get(clientNum, "ps.origin")
	playerPositions[clientNum] = pos
	sprint = et.gentity_get(clientNum, "ps.stats", et.STAT_SPRINTTIME)
	playerSprints[clientNum] = sprint
end

-- will print error to console if target hasn't saved yet, but won't crash
function loadPosition(clientNum)
	pos = playerPositions[clientNum]
	et.gentity_set(clientNum, "ps.origin", playerPositions[clientNum])

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
	et.RegisterModname(modname .. version .. " " .. et.FindSelf())
end

function et_ClientCommand(clientNum, command)
	if command == "save" then
		savePosition(clientNum)
	end
	if command == "load" then
		loadPosition(clientNum)
	end
end
