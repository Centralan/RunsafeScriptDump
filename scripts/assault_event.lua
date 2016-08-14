----------------------
---- DEPENDENCIES ----
----------------------

local PATH = "plugins/EventEngine/scripts/";
local serialize = dofile(PATH .. "Ser.lua");

-------------------------
----- CONFIGURATION -----
-------------------------

-- The world which our event takes place in.
local world = World:new('Project33');

local dataFile = PATH .. "assault.data";

-- Player progress array.
local playerProgress = {};

world.makeLoc = function(x, y, z)
	return Location:new(world, x, y, z);
end

--------------------------
--- PROGRESS HANDLING ----
--------------------------

-- Load the progress of players from file.
local progressData = dofile(dataFile);

-- If nothing was found, create an empty array.	
if progressData ~= nil then
	playerProgress = progressData;
end

local function SaveProgress()
	local file = io.open(dataFile, "w");
	file:write(serialize(playerProgress));
	file:close();
end

local function GetPlayerProgressTable(player)
	if playerProgress[player.name] ~= nil then
		return playerProgress[player.name];
	end
	
	playerProgress[player.name] = {};
	return playerProgress[player.name];
end

local function GetPlayerProgressValue(player, key)
	return GetPlayerProgressTable(player)[key];
end

local function SetPlayerProgressValue(player, key, value)
	local playerProgress = GetPlayerProgressTable(player);
	playerProgress[key] = value;
	SaveProgress();
end

-----------------------
--- CHEST HANDLING ----
-----------------------

-- Main data regarding lootable chests in the world.
local lootChests = {
	{
		["Location"] = world.makeLoc(-1594, 66, -1366),
		["Message"] = "&aReaching into the chest you find a mission log.",
		["Func"] = function(player)
			local chestLoc = world.makeLoc(-1795, 50, -1349);
			chestLoc:cloneChestToPlayer(player.name);
		end,
	}
};

local function GenerateLocationString(location)
	return "L" .. location.x .. location.y .. location.z;
end

local function Chest_IsDone(locString, player)
	local chestData = GetPlayerProgressValue(player, "chests");
	
	if chestData == nil then
		return false;
	end
	
	if chestData[locString] ~= nil then
		return true;
	end
	
	return false;
end

local function Chest_MarkAsDone(locString, player)
	local chestData = GetPlayerProgressValue(player, "chests");
	if chestData == nil then
		chestData = {};
	end
	
	chestData[locString] = true;
	SetPlayerProgressValue(player, "chests", chestData);
end

function AssaultEvent_LootChest(data)
	local location = world.makeLoc(data.x, data.y, data.z);
	local locString = GenerateLocationString(location);
	
	for index, lootChest in pairs(lootChests) do
		if lootChest.ID == locString then
			local player = Player:new(data.player);
			player:closeInventory();
			if not Chest_IsDone(locString, player) then
				lootChest.Func(player);
				player:sendMessage(lootChest.Message);
				Chest_MarkAsDone(locString, player);
			else
				player:sendMessage("&cYou've already looted this chest!");
			end
			break;
		end
	end
end

-- Register all the hooks we need for our chests.
for index, chest in pairs(lootChests) do
	local location = chest.Location;
	chest.ID = GenerateLocationString(location);
	
	registerHook("INTERACT", "AssaultEvent_LootChest", 54, world.name, location.x, location.y, location.z);
end