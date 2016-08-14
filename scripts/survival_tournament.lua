function t_copy (t) -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    setmetatable(target, meta)
    return target
end

local world = World:new('survival_tournament');

function s_angled_loc(x, y, z, yaw, pitch)
	local loc = Location:new(world, x, y, z);
	loc:setYaw(yaw);
	loc:setPitch(pitch);
	return loc;
end

local matchRunning = false;
local preMatchRunning = false;
local matchCheckTimer = Timer:new('s_match_check', 20 * 60); -- 1 minute
local matchTimer = Timer:new('s_match_stale', 18000); -- 15 minutes
local lobbyLoc = s_angled_loc(-1058.5, 62, 2538.5, 268.97147, -4.3770895);
local matchTick = Timer:new('s_match_tick', 20 * 5); -- 5 seconds
local sign = Location:new(world, -1064, 64, 2538);
local playing = {};

local startLocations = {
	s_angled_loc(-1030.5, 72.5, 2534.5, 68.17312, 13.961146),
	s_angled_loc(-1028.5, 72.5, 2540.5, 89.587524, 13.36959),
	s_angled_loc(-1030.5, 72.5, 2546.5, 113.13156, 21.76974),
	s_angled_loc(-1034.5, 72.5, 2552.5, 134.19112, 6.862455),
	s_angled_loc(-1038.5, 72.5, 2556.5, 135.1376, 14.552745),
	s_angled_loc(-1042.5, 72.5, 2558.5, 145.78572, 17.155602),
	s_angled_loc(-1047.5, 72.5, 2559.5, 174.5355, 15.6175585),
	s_angled_loc(-1051.5, 72.5, 2558.5, 181.6343, 23.071205),
	s_angled_loc(-1055.5, 72.5, 2557.5, 202.57553, 13.487955),
	s_angled_loc(-1062.5, 72.5, 2555.5, 218.07436, 19.40355),
	s_angled_loc(-1067.5, 72.5, 2551.5, 227.42114, 22.479662),
	s_angled_loc(-1069.5, 72.5, 2547.5, 239.84381, 5.7977133),
	s_angled_loc(-1069.5, 72.5, 2542.5, 263.50623, 4.8512177),
	s_angled_loc(-1068.5, 72.5, 2538.5, 271.078, 4.141329),
	s_angled_loc(-1067.5, 72.5, 2532.5, 291.07285, 5.3244433),
	s_angled_loc(-1064.5, 72.5, 2527.5, 308.93817, 11.240026),
	s_angled_loc(-1061.5, 72.5, 2522.5, 325.6201, 6.7441826),
	s_angled_loc(-1056.5, 72.5, 2520.5, 341.59195, 5.5610704),
	s_angled_loc(-1052.5, 72.5, 2519.5, 353.42297, 17.510563),
	s_angled_loc(-1047.5, 72.5, 2519.5, 10.933472, 3.3131666),
	s_angled_loc(-1042.5, 72.5, 2520.5, 29.626617, 5.916018),
	s_angled_loc(-1038.5, 72.5, 2522.5, 39.919983, 13.961215),
	s_angled_loc(-1035.5, 72.5, 2526.5, 49.03009, 21.414873),
	s_angled_loc(-1032.5, 72.5, 2530.5, 54.94571, 26.147327)
};

local lootChests = {};
local lootChestStart = Location:new(world, -1051, 34, 2462);
local lootChestCount = 15;

local currentChest = 0;

while currentChest < lootChestCount do
	table.insert(lootChests, Location:new(world, lootChestStart.x - (currentChest * 2), lootChestStart.y, lootChestStart.z));
	currentChest = currentChest + 1;
end

local staticChestLocations = {
	Location:new(world, -1040, 72, 2535),
	Location:new(world, -1040, 72, 2544),
	Location:new(world, -1048, 72, 2534),
	Location:new(world, -1051, 72, 2532),
	Location:new(world, -1054, 72, 2531),
	Location:new(world, -1055, 72, 2534),
	Location:new(world, -1063, 72, 2540),
	Location:new(world, -1052, 72, 2550),
	Location:new(world, -1053, 72, 2536),
	Location:new(world, -1053, 73, 2537),
	Location:new(world, -1050, 72, 2536),
	Location:new(world, -1050, 73, 2537),
	Location:new(world, -1050, 72, 2538),
	Location:new(world, -1053, 72, 2538),
};

local randomChestLocations = {
	Location:new(world, -1036, 63, 2502),
	Location:new(world, -1019, 56, 2488),
	Location:new(world, -1027, 54, 2489),
	Location:new(world, -994, 63, 2479),
	Location:new(world, -1002, 62, 2501),
	Location:new(world, -993, 62, 2521),
	Location:new(world, -1003, 61, 2523),
	Location:new(world, -999, 62, 2551),
	Location:new(world, -995, 62, 2574),
	Location:new(world, -1024, 62, 2601),
	Location:new(world, -992, 62, 2609),
	Location:new(world, -1040, 62, 2610),
	Location:new(world, -1075, 62, 2599),
	Location:new(world, -1094, 72, 2589),
	Location:new(world, -1119, 62, 2592),
	Location:new(world, -1115, 62, 2563),
	Location:new(world, -1102, 56, 2540),
	Location:new(world, -1123, 62, 2515),
	Location:new(world, -1090, 62, 2483),
	Location:new(world, -1048, 68, 2491),
	Location:new(world, -1056, 55, 2522),
	Location:new(world, -1050, 77, 2576),
	Location:new(world, -1049, 67, 2577),
	Location:new(world, -1018, 77, 2566)
};

function s_broadcast(msg)
	world:broadcast("&2[ST] &5" .. msg);
end

function s_message(player, msg)
	player:sendMessage("&2[ST] &5" .. msg);
end

function s_within_bounds(player, lX, lY, lZ, hX, hY, hZ)
	local world, x, y, z = player:getLocation();
	return x >= lX and y >= lY and z >= lZ and x <= hX and y <= hY and z <= hZ;
end

function s_get_players_in_lobby()
	local lobbyPlayers = {};
	local players = {world:getPlayers()};

	for index, playerName in pairs(players) do
		local player = Player:new(playerName);
		if s_within_bounds(player, -1066, 61, 2532, -1054, 66, 2544) then
			table.insert(lobbyPlayers, player);
		end
	end
	return lobbyPlayers;
end

function s_get_players_in_match()
	local matchPlayers = {};
	local players = {world:getPlayers()};

	for index, playerName in pairs(players) do
		local player = Player:new(playerName);
		if s_within_bounds(player, -1133, 0, 2469, -983, 255, 2619) and not s_within_bounds(player, -1066, 61, 2532, -1054, 66, 2544) then
			table.insert(matchPlayers, player);
		end
	end
	return matchPlayers;
end

function s_match_start()
	matchRunning = true;
	
	local availableLocations = t_copy(startLocations);
	for index, player in pairs(s_get_players_in_lobby()) do
		if #availableLocations > 0 then
			local randomLocIndex = math.random(1, #availableLocations);
			player:clearInventory();
			player:teleport(availableLocations[randomLocIndex]);
			--table.insert(playing, player);
			playing[player.name] = true;
			table.remove(availableLocations, randomLocIndex);
			s_message(player, "The match has begun!");
		else
			s_message(player, "Sorry, there are no more available spaces in this match!");
		end
	end
	
	for index, chestLocation in pairs(staticChestLocations) do
		chestLocation:setBlock(54, 0);
	end
	
	for index, chestLocation in pairs(randomChestLocations) do
		chestLocation:setBlock(54, 0);
	end
	
	matchTimer:start();
	matchTick:start();
end

function s_match_tick()
	local matchPlayers = s_get_players_in_match();
	local playerCount = #matchPlayers;
	
	--for index, matchPlayer in pairs(matchPlayers) do	
--		if matchPlayer:isDead() then
	--		table.remove(matchPlayers, index);
	--	end
	--end
	
	if playerCount < 2 then
		if playerCount == 1 then
			s_match_winner(matchPlayers[1]);
		elseif playerCount == 0 then
			s_broadcast('The match ended with no winner!');
		end
		s_match_end();
	else
		matchTick:start();
	end
end

function s_match_winner(winner)
	s_message(winner, "You have won this round of Survival Tournament!");
	sign:setSign('', 'Last Winner:', winner.name, '');
end

function s_match_stale()
	s_broadcast('Time up! The match concludes with no winner.');
	s_match_end();
end

function s_match_end()
	matchTick:cancel();
	matchTimer:cancel();
	matchRunning = false;
	playing = {};
	
	for index, chestLocation in pairs(staticChestLocations) do
		chestLocation:setBlock(0, 0);
	end
	
	for index, chestLocation in pairs(randomChestLocations) do
		chestLocation:setBlock(0, 0);
	end
	
	for index, player in pairs(s_get_players_in_match()) do
		player:clearInventory();
		s_teleport_player_to_lobby(player);
	end
	
	s_match_check();
	world:removeItems();
end

function s_teleport_player_to_lobby(player)
	player:teleport(lobbyLoc);
	player:clearInventory();
end

function s_match_check()
	if not matchRunning then
		if preMatchRunning then
			preMatchRunning = false;
			if #s_get_players_in_lobby() > 1 then
				s_match_start();
			else
				s_broadcast('Not enough players for a match!');
				matchCheckTimer:start();
			end
		else
			if #s_get_players_in_lobby() > 1 then
				preMatchRunning = true;
				s_broadcast('New match starting in 60 seconds! Prepare yourselves.');
			end
			matchCheckTimer:start();
		end
	end
end
s_match_check();

function s_chest_click(data)
	local player = Player:new(data.player);
	player:closeInventory();
	Location:new(world, data.x, data.y, data.z):setBlock(0, 0);
	local chest = lootChests[math.random(1, #lootChests)];
	chest:cloneChestToPlayer(player.name);
end

registerHook("INTERACT", "s_chest_click", 54, world.name);