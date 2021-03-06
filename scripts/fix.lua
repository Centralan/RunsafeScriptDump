-- This is a fix for the creative -> spawn inventory bug.
-- Do not remove it and do not remove the associated region.

local timer = Timer:new("forceMode", 1);
local timerClean = Timer:new("worldClean", 2);
local world = World:new("spawn2");
local knownPlayers = {};
local sendSpot = Location:new(world, -1602, 84, -348);

function forceMode()
	local players = {world:getPlayers()};

	for index, playerName in pairs(players) do
		if knownPlayers[playerName] == nil then
			local player = Player:new(playerName);
			player:teleport(sendSpot);
			knownPlayers[playerName] = true;
		end
	end
end

function worldClean()
	local worldPlayers = {world:getPlayers()};
	local players = {};

	for index, playerName in pairs(worldPlayers) do
		players[playerName] = true;
	end

	for playerName, value in pairs(knownPlayers) do
		if players[playerName] == nil then
			knownPlayers[playerName] = nil;
		end
	end
end

timer:startRepeating();
timerClean:startRepeating();
