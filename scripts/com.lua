local world = World:new('com');
local netherWorld = World:new('com_nether');
local worldSurvival = World:new('com');

local effects = {
	{"Molten Spewing", "LAVA", 0.1, 5, 2},
	{"Touch of End", "PORTAL", 1, 50, 1},
	{"Emerald Charm", "HAPPY_VILLAGER", 10, 30, 1},
	{"Molten Touch", "FLAME", 0.05, 20, 1},
	{"Opal Projection", "FIREWORKS_SPARK", 0.05, 10, 1},
	{"Slime Spray", "SLIME", 10, 100, 1},
	{"Rain Cloud", "SPLASH", 10, 100, 5},
	{"Rain Cloud", "CLOUD", 0.05, 20, 5},
	{"Black Magic", "WITCH_MAGIC", 10, 30, 0},
	{"Black Magic", "SPELL", 10, 30, 0}
};

function fireTick()
	processPlayers({world:getPlayers()});
	processPlayers({worldSurvival:getPlayers()});
	processPlayers({worldNether:getPlayers()});
end

function processPlayers(players)
	for index, playerName in pairs(players) do
		for key, effect in pairs(effects) do
			if playerName ~= nil then
				local player = Player:new(playerName);
				if player ~= nil and player:isOnline() then
					if player:hasItemWithName("" .. effect[1]) then
						local world, x, y, z = player:getLocation();
						local playerLoc = Location:new(world, x, y + effect[5], z);
						playerLoc:playEffect(effect[2], effect[3], effect[4], 20);
					end
				end
			end
		end
	end
end

registerHook("BLOCK_GAINS_CURRENT", "fireTick", "com", -127, 66, 195);

local netherLocation = Location:new(netherWorld, -0.2, 72, -6);
local spawnPoint = Location:new(world, -138, 71, 210);

function netherPortal(data)
	local player = Player:new(data.player);
	player:teleport(netherLocation);
end

function mainPortal(data)
	local player = Player:new(data.player);
	if player:hasPermission("runsafe.com.entry") then
		player:teleport(spawnPoint);
	else
		player:sendMessage("You need to be a higher rank to go here.");
	end
end

registerHook("REGION_ENTER", "netherPortal", "com-netherPortal");
registerHook("REGION_ENTER", "mainPortal", "spawn2-comPortal");

-- Daytime Button

local sunlightBannedPlayers = {};
local sunlightBanTimer = Timer:new("sunlightBanClear", 60 * 20);

function sunlightBanClear()
	for index, value in pairs(sunlightBannedPlayers) do
		sunlightBannedPlayers[index] = nil;
	end
end

function daytimeButtonClick(data)
	local player = Player:new(data.player);
	
	if sunlightBannedPlayers[player.name] ~= nil then
		player:sendMessage("§cYou are banned from buying sunlight at this moment.");
		return;
	end
	
	local balance = getBalance(player, true);
	if balance >= 1 then
		sunlightBannedPlayers[player.name] = true;
		updateBalance(player, -10);
		player:sendMessage("§aIt's now daytime! Ten coins have been deducted from you!");
		world:broadcast("§6" .. player.name .. " has purchased daytime. Praise the sun!");
		world:setTime(600);
	else
		player:sendMessage("§cYou need at least ten coins to make it daytime!");
	end
end

sunlightBanTimer:startRepeating();

registerHook("INTERACT", "daytimeButtonClick", 143, world.name, -142, 72, 206);

function shopConvertSponge(data)
	local player = Player:new(data.player);
	if player:hasItem("sponge", 1) then
		player:removeItem("sponge", 1);
		updateBalance(player, 1);
		player:sendMessage("&aOne sponge converted to coin!");
	else
		player:sendMessage("&cYou have no sponge to exchange!");
	end
end

registerHook("INTERACT", "shopConvertSponge", 143, world.name, -114, 73, 190);