local world = World:new('whitestone');

function a_broadcast(msg)
	world:broadcast(msg);
end

function a_broadcast_npc(npc, msg)
	a_broadcast('&b[A] &3' .. npc .. '&f: ' .. msg);
end


function a_whisper_npc(npc, msg, player)
	player:sendMessage('&b[A] &3' .. npc .. ' &3-> &f' .. msg);
end

local captain = 'Captain Sanders';

function a_within_bounds(player, lX, lY, lZ, hX, hY, hZ)
	local world, x, y, z = player:getLocation();
	
	return x >= lX and y >= lY and z >= lZ and x <= hX and y <= hY and z <= hZ;
end

local boatJumpLoc = Location:new(world, -4997, 84, -5005);
function a_player_boat_jump(data)
	local player = Player:new(data.player);
	player:teleport(boatJumpLoc);
	a_whisper_npc(captain, "Keep ya bloody ligaments on th' wretched boat lest y'want to rot in Davy Jones locker!", player);
end

registerHook("REGION_ENTER", "a_player_boat_jump", "whitestone-water_fall");

-- FIRE ROOM 1

local fireDoorOpen = false;
local fireBlocks = {};

function a_handle_button(data)
	local x = data.x;
	local z = data.z;
	local key = x .. z;
		
	if fireBlocks[key] ~= nil then
		local fireBlock = fireBlocks[key].loc;
		
		if fireBlock:getBlock() == 0 then
			fireBlock:setBlock(51, 0);
			fireBlock:playSound("GHAST_FIREBALL", 2, 0);
		else
			fireBlock:setBlock(0, 0);
			fireBlock:playSound("FIZZ", 2, 2);
		end
	end
end

function a_register_button(x, z, required)
	local fireX = 0;
	if x == 38 then fireX = 36 else fireX = 44; end
	local fireLocation = Location:new(world, fireX, 50, z);
	fireBlocks[x .. z] = {
		loc = fireLocation,
		required = required
	};
	registerHook("INTERACT", "a_handle_button", 77, world.name, x, 48, z);
end

a_register_button(38, 59, true);
a_register_button(38, 57, true);
a_register_button(38, 55, false);

a_register_button(42, 59, false);
a_register_button(42, 57, false);
a_register_button(42, 55, true);

local doorBlocks = {
	Location:new(world, 41, 47, 46),
	Location:new(world, 40, 47, 46),
	Location:new(world, 39, 47, 46)
};

local doorGravelBlocks = {
	Location:new(world, 39, 50, 46),
	Location:new(world, 39, 49, 46),
	Location:new(world, 39, 48, 46),
	Location:new(world, 40, 50, 46),
	Location:new(world, 40, 49, 46),
	Location:new(world, 40, 48, 46),
	Location:new(world, 41, 50, 46),
	Location:new(world, 41, 49, 46),
	Location:new(world, 41, 48, 46),
};

local fireLeverLocation = Location:new(world, 40, 49, 51);
local fireLeverDoorStep2Timer = Timer:new("a_fire_door_stage_two", 1 * 20);
local fireLeverDoorCloseTimer = Timer:new("a_fire_door_close", 11 * 20);

function a_fire_door_stage_two()
	for key, value in pairs(doorBlocks) do
		value:setBlock(98, 3);
	end
end

function a_fire_door_close()
	for key, value in pairs(doorGravelBlocks) do
		value:setBlock(13, 0);
	end
	fireDoorOpen = false;
end

function a_handle_fire_lever()
	if fireDoorOpen then
		return;
	end
	
	for key, value in pairs(fireBlocks) do
		if (value.required == true and value.loc:getBlock() ~= 51) or (value.required == false and value.loc:getBlock() == 51) then
			return;
		end
	end
	
	fireDoorOpen = true;
	
	fireLeverLocation:playSound('MINECART_INSIDE', 2, 0); -- Play a mechanical sound
	fireLeverDoorStep2Timer:start();
	fireLeverDoorCloseTimer:start();
	
	-- Remove the door blocks
	for key, value in pairs(doorBlocks) do
		value:setBlock(0, 0);
	end
	
	-- Unlight all the fires
	for key, value in pairs(fireBlocks) do
		value.loc:setBlock(0, 0);
	end
end

local fireChest = Location:new(world, 32, 51, 28);
local fireChestPlayers = {};
local fireChestResetTimer = Timer:new("a_reset_fire_chest", 20 * 60 * 5);
local fireChestResetTimerRunning = false;
local fireChestOpen = Location:new(world, 29, 49, 30);

function a_handle_fire_chest(data)
	local player = Player:new(data.player);
	if not fireChestPlayers[player.name] then
		fireChest:cloneChestToPlayer(player.name);
		player:closeInventory();
		player:sendMessage('&eA small book falls out onto the floor which you pick up.');
		fireChestOpen:playSound('HORSE_SADDLE', 1, 0);
		fireChestPlayers[player.name] = true; -- Flag the player
		
		if not fireChestResetTimerRunning then
			fireChestResetTimerRunning = true;
			fireChestResetTimer:start();
		end
	end
end

function a_reset_fire_chest()
	fireChestPlayers = {};
	fireChestResetTimerRunning = false;
end

registerHook("INTERACT", "a_handle_fire_lever", 69, world.name, fireLeverLocation.x, fireLeverLocation.y, fireLeverLocation.z);
registerHook("INTERACT", "a_handle_fire_chest", 54, world.name, 29, 49, 30);

local fireTeleportOut = Location:new(world, 40.38, 48, 48.64, 0.16659, 10.021252);

function a_fire_teleport_out(data)
	local player = Player:new(data.player);
	player:teleport(fireTeleportOut);
end

registerHook("INTERACT", "a_fire_teleport_out", 77, world.name, 38, 49, 44);
registerHook("INTERACT", "a_fire_teleport_out", 77, world.name, 42, 49, 44);

-- BOAT EVENT

function a_boat_locked_chest(data)
	local player = Player:new(data.player);
	player:sendMessage("&eThis chest is locked, but it looks important.");
end

registerHook("INTERACT", "a_boat_locked_chest", 54, world.name, -4996, 86, -5045);
registerHook("INTERACT", "a_boat_locked_chest", 54, world.name, -4996, 86, -5044);

local boatLocation = Location:new(world, -4997, 98, -5017);
local boatCrashLocation = Location:new(world, 0, 86, -83);
local currentStage = 0;
local boatRunning = false;
local boatStageTimer = Timer:new("a_boat_step", 20);

local boatMovingSounds = {
	{sound = 'CHEST_OPEN', pitch = 0},
	{sound = 'CHEST_CLOSE', pitch = 0},
	{sound = 'SWIM', pitch = 0},
	{sound = 'SWIM', pitch = 0},
	{sound = 'SWIM', pitch = 0},
	{sound = 'HORSE_BREATHE', pitch = 0},
	{sound = 'HORSE_BREATHE', pitch = 0},
	{sound = 'HORSE_BREATHE', pitch = 0}
};

local boatBreakSounds = {
	{sound = 'SWIM', pitch = 0},
	{sound = 'ZOMBIE_WOOD', pitch = 0},
	{sound = 'ZOMBIE_WOODBREAK', pitch = 0},
	{sound = 'SPLASH', pitch = 2},
	{sound = 'SPLASH2', pitch = 0},
	{sound = 'GLASS', pitch = 0},
	{sound = 'ARROW_HIT', pitch = 0},
}

function a_boat_play_random_sound(location, sounds)
	local sound = sounds[math.random(#sounds)];
	location:playSound(sound.sound, 10, sound.pitch);
end

local boatHasCrashed = false;
local boatLateLocation = Location:new(world, 0, 81, -118);

local boatStages = {
	{idx = 0, func = function() a_broadcast_npc(captain, "Listen 'ere y'scurvy dogs. We'll be setting sail in five minutes time so take a look 'round me ship and get ready to sail. Jus' don't be jumpin' off the edge now."); end},
	{idx = 1, func = function() end},
	{idx = 10, func = function() a_broadcast_npc(captain, "Try t'be keepin' yer voices down, makes it hard fer people t'be hearing me when yer all blabbering."); end},
	{idx = 11, func = function() end},
	{idx = 299, func = function() a_broadcast_npc(captain, "Alright, we be settin' off now. Keep yer eyes peeled, no tellin' what lies ahead in th' dark sea! Don't mind th' noises, she's a bit old me ship."); end},
	{idx = 300, func = function() boatLocation:playSound('WATER', 10, 0); a_boat_play_random_sound(boatLocation, boatMovingSounds); end},
	{idx = 600, func = function() a_broadcast_npc(captain, "Shiver me timbers! Uncharted land ahoy! Arrr.. she's sailing too fast! HOLD ONTO YER HATS, WE GOT A MEETING WITH DESTINY!!"); end},
	{idx = 601, func = function() end},
	{idx = 608, func = function() a_boat_switch_players(); a_boat_explosions(); end },
	{idx = 609, func = function() a_boat_play_random_sound(boatCrashLocation, boatBreakSounds); a_boat_play_random_sound(boatCrashLocation, boatBreakSounds); a_boat_play_random_sound(boatCrashLocation, boatBreakSounds); a_boat_play_random_sound(boatCrashLocation, boatBreakSounds); end},
	{idx = 615, func = function() a_broadcast_npc(captain, "Arrgh, me ship! She's ruined! Make yerselves useful, search around th' blasted island, find out where in oblivion we are and more importantly a way t'get out of here! SCRAM!"); end},
	{idx = 616, func = function() boatHasCrashed = true; end}
};

function a_boat_start_event()
	boatRunning = true;
	currentStage = 0;
	boatStageTimer:start();
end

function a_boat_step()
	local lastIndex = nil;
	local viableStep = nil;
	
	for index, stage in pairs(boatStages) do
		if stage.idx <= currentStage then
			viableStep = stage;
		end
		lastIndex = stage.idx;
	end
	
	if viableStep ~= nil then
		viableStep.func();
		
		if boatRunning and lastIndex > viableStep.idx then
			boatStageTimer:start();
		end
	end
	currentStage = currentStage + 1;
end

function a_boat_switch_players()
	local players = {world:getPlayers()};

	for index, playerName in pairs(players) do
		local player = Player:new(playerName);
		if a_boat_player_is_on_boat(player) then
			-- Teleport player to the broken boat.
			local world, x, y, z, yaw, pitch = player:getLocation();
			local newLocation = Location:new(world, x + 4998, y - 11, z + 4935);
			newLocation:setYaw(yaw);
			newLocation:setPitch(pitch);
			player:teleport(newLocation);
		end
	end
end

function a_boat_player_is_on_boat(player)
	local world, x, y, z = player:getLocation();
	return math.abs((x - boatLocation.x) + (z - boatLocation.z)) < 150;
end

function a_boat_explosions()
	local players = {world:getPlayers()};

	for index, playerName in pairs(players) do
		local player = Player:new(playerName);
		local world, x, y, z = player:getLocation();
		local playerLocation = Location:new(world, x, y, z);
		playerLocation:explosion(5, false, false);
	end
end

registerHook("INTERACT", "a_boat_start_event", 77, world.name, 27, 62, -62);

local boatBookChest = Location:new(world, 0, 57, -106);
local boatBookChestPlayers = {};
local boatBookChestTimer = Timer:new("a_boat_reset_chest", 20 * 5 * 60);
local boatBookChestTimerRunning = false;
local boatBookChestOpen = Location:new(world, 3, 69, -110);

function a_boat_reset_chest()
	boatBookChestPlayers = {};
	boatBookChestTimerRunning = false;
end

function a_boat_chest_open(data)
	local player = Player:new(data.player);
	if boatBookChestPlayers[player.name] == nil then
		boatBookChestPlayers[player.name] = true;
		player:sendMessage("&eReaching into the chest you pull out a book..");
		player:closeInventory();
		boatBookChestOpen:playSound('HORSE_SADDLE', 1, 0);
		boatBookChest:cloneChestToPlayer(player.name);
		
		if not boatBookChestTimerRunning then
			boatBookChestTimerRunning = true;
			boatBookChestTimer:start();
		end
	end
end

registerHook("INTERACT", "a_boat_chest_open", 54, world.name, 3, 69, -110);
registerHook("INTERACT", "a_boat_chest_open", 54, world.name, 4, 69, -110);

-- DIRT TUNNEL 1

local dirtTunnelBlock = Location:new(world, -72, 56, 112);

local dirtTunnelChest = Location:new(world, -81, 57, 120);
local dirtTunnelChestOpen = Location:new(world, -79, 56, 120);
local dirtTunnelChestPlayers = {};
local dirtTunnelChestTimerRunning = false;
local dirtTunnelChestTimer = Timer:new("a_dirt_tunnel_reset_chest", 20 * 5 * 60);

function a_dirt_tunnel_open()
	dirtTunnelBlock:setBlock(0, 0);
end

function a_dirt_tunnel_close()
	dirtTunnelBlock:setBlock(152, 0);
end

function a_dirt_tunnel_open_chest(data)
	local player = Player:new(data.player);
	if dirtTunnelChestPlayers[player.name] == nil then
		dirtTunnelChestPlayers[player.name] = true;
		player:sendMessage("&eReaching into the chest you find a journal..");
		dirtTunnelChestOpen:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		dirtTunnelChest:cloneChestToPlayer(player.name);
	end
	
	if not dirtTunnelChestTimerRunning then
		dirtTunnelChestTimerRunning = true;
		dirtTunnelChestTimer:start();
	end
end

function a_dirt_tunnel_reset_chest()
	dirtTunnelChestPlayers = {};
	dirtTunnelChestTimerRunning = false;
end

registerHook("REGION_ENTER", "a_dirt_tunnel_open", "whitestone-a_dirt_door_1");
registerHook("REGION_LEAVE", "a_dirt_tunnel_close", "whitestone-a_dirt_door_1");
registerHook("INTERACT", "a_dirt_tunnel_open_chest", 54, world.name, -79, 56, 120);


-- WIZARD TOWER

local wizardDownDoorBlock = Location:new(world, -492, 63, -210);
local wizardDownDoorTimer = Timer:new("a_wiz_close_door", 20 * 20);
local wizardDownDoorOpen = false;

function a_wiz_open_door(data)
	if not wizardDownDoorOpen then
		wizardDownDoorOpen = true;
		wizardDownDoorBlock:setBlock(0, 0);
		wizardDownDoorTimer:start();
	end
end

function a_wiz_close_door()
	wizardDownDoorBlock:setBlock(152, 0);
	wizardDownDoorOpen = false;
end

registerHook("INTERACT", "a_wiz_open_door", 77, world.name, -476, 70, -197);

function a_wiz_jump_1(data)
	local player = Player:new(data.player);
	player:setVelocity(0, 1.5, 0);
end

registerHook("INTERACT", "a_wiz_jump_1", 77, world.name, -493, 117, -209);

local wizTopChestBlock = Location:new(world, -487, 142, -209);
local wizTopChestTimer = Timer:new("a_wiz_top_chest_close", 20 * 3);
local wizTopChestOpen = false;

function a_wiz_jump_2(data)
	local player = Player:new(data.player);
	player:setVelocity(0, 2.7, 0);
	a_wiz_top_chest_open();
end

function a_wiz_top_chest_open()
	if not wizTopChestOpen then
		wizTopChestOpen = true;
		wizTopChestTimer:start();
		wizTopChestBlock:setBlock(0, 0);
	end
end

function a_wiz_top_chest_close()
	wizTopChestOpen = false;
	wizTopChestBlock:setBlock(44, 10);
end

registerHook("INTERACT", "a_wiz_jump_2", 143, world.name, -487, 110, -211);
registerHook("INTERACT", "a_wiz_jump_2", 143, world.name, -487, 110, -207);

local wizInfoBookPlayers = {};
local wizInfoBookTimer = Timer:new("a_wiz_info_reset", 20 * 5 * 60);
local wizInfoBookTimerRunning = false;
local wizInfoBookChest = Location:new(world, -496, 62, -200);
local wizInfoBookLocation = Location:new(world, -486, 87, -204);

function a_wiz_info_open(data)
	local player = Player:new(data.player);
	if wizInfoBookPlayers[player.name] == nil then
		wizInfoBookPlayers[player.name] = true;
		player:sendMessage("&eYou pull out a journal from the chest..");
		wizInfoBookLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		wizInfoBookChest:cloneChestToPlayer(player.name);
		
		if not wizInfoBookTimerRunning then
			wizInfoBookTimerRunning = true;
			wizInfoBookTimer:start();
		end
	end
end

registerHook("INTERACT", "a_wiz_info_open", 54, world.name, wizInfoBookLocation.x, wizInfoBookLocation.y, wizInfoBookLocation.z);

local talismanEarthChest = Location:new(world, -497, 62, -201);
local talismanWaterChest = Location:new(world, -499, 62, -201);
local talismanAstralChest = Location:new(world, -501, 62, -201);
local talismanMindChest = Location:new(world, -503, 62, -201);
local talismanFireChest = Location:new(world, -505, 62, -201);

local taliEarthPlayers = {};
local taliEarthTimer = Timer:new("a_tali_earth_reset",  20 * 5 * 60);
local taliEarthTimerRunning = false;
local taliEarthLocation = Location:new(world, -484, 83, -204);

function a_tali_earth_open(data)
	local player = Player:new(data.player);
	if taliEarthPlayers[player.name] == nil then
		taliEarthPlayers[player.name] = true;
		player:sendMessage("&eYou pull out a talisman block from the chest..");
		taliEarthLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		talismanEarthChest:cloneChestToPlayer(player.name);
		
		if not taliEarthTimerRunning then
			taliEarthTimer:start();
			taliEarthTimerRunning = true;
		end
	end
end

function a_tali_earth_reset()
	taliEarthTimerRunning = false;
	taliEarthPlayers = {};
end

local taliFirePlayers = {};
local taliFireTimer = Timer:new("a_tali_fire_reset",  20 * 5 * 60);
local taliFireTimerRunning = false;
local taliFireLocation = Location:new(world, -502, 104, -209);

function a_tali_fire_open(data)
	local player = Player:new(data.player);
	if taliFirePlayers[player.name] == nil then
		taliFirePlayers[player.name] = true;
		player:sendMessage("&eYou pull out a talisman block from the chest..");
		taliFireLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		talismanFireChest:cloneChestToPlayer(player.name);
		
		if not taliFireTimerRunning then
			taliFireTimer:start();
			taliFireTimerRunning = true;
		end
	end
end

function a_tali_fire_reset()
	taliFireTimerRunning = false;
	taliFirePlayers = {};
end

local taliAstralPlayers = {};
local taliAstralTimer = Timer:new("a_tali_astral_reset",  20 * 5 * 60);
local taliAstralTimerRunning = false;
local taliAstralLocation = Location:new(world, -487, 143, -209);

function a_tali_astral_open(data)
	local player = Player:new(data.player);
	if taliAstralPlayers[player.name] == nil then
		taliAstralPlayers[player.name] = true;
		player:sendMessage("&eYou pull out a talisman block from the chest..");
		taliAstralLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		talismanAstralChest:cloneChestToPlayer(player.name);
		
		if not taliAstralTimerRunning then
			taliAstralTimer:start();
			taliAstralTimerRunning = true;
		end
	end
end

function a_tali_astral_reset()
	taliAstralTimerRunning = false;
	taliAstralPlayers = {};
end

local taliWaterPlayers = {};
local taliWaterTimer = Timer:new("a_tali_water_reset",  20 * 5 * 60);
local taliWaterTimerRunning = false;
local taliWaterLocation = Location:new(world, -487, 107, -209);

function a_tali_water_open(data)
	local player = Player:new(data.player);
	if taliWaterPlayers[player.name] == nil then
		taliWaterPlayers[player.name] = true;
		player:sendMessage("&eYou pull out a talisman block from the chest..");
		taliWaterLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		talismanWaterChest:cloneChestToPlayer(player.name);
		
		if not taliWaterTimerRunning then
			taliWaterTimer:start();
			taliWaterTimerRunning = true;
		end
	end
end

function a_tali_water_reset()
	taliWaterTimerRunning = false;
	taliWaterPlayers = {};
end

local taliMindPlayers = {};
local taliMindTimer = Timer:new("a_tali_mind_reset",  20 * 5 * 60);
local taliMindTimerRunning = false;
local taliMindLocation = Location:new(world, -487, 125, -226);

function a_tali_mind_open(data)
	local player = Player:new(data.player);
	if taliMindPlayers[player.name] == nil then
		taliMindPlayers[player.name] = true;
		player:sendMessage("&eYou pull out a talisman block from the chest..");
		taliMindLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		talismanMindChest:cloneChestToPlayer(player.name);
		
		if not taliMindTimerRunning then
			taliMindTimer:start();
			taliMindTimerRunning = true;
		end
	end
end

function a_tali_mind_reset()
	taliMindTimerRunning = false;
	taliMindPlayers = {};
end

registerHook("INTERACT", "a_tali_mind_open", 54, world.name, taliMindLocation.x, taliMindLocation.y, taliMindLocation.z);
registerHook("INTERACT", "a_tali_fire_open", 54, world.name, taliFireLocation.x, taliFireLocation.y, taliFireLocation.z);
registerHook("INTERACT", "a_tali_earth_open", 54, world.name, taliEarthLocation.x, taliEarthLocation.y, taliEarthLocation.z);
registerHook("INTERACT", "a_tali_astral_open", 54, world.name, taliAstralLocation.x, taliAstralLocation.y, taliAstralLocation.z);
registerHook("INTERACT", "a_tali_water_open", 54, world.name, taliWaterLocation.x, taliWaterLocation.y, taliWaterLocation.z);

local wizardBookPlayers = {};
local wizardBookTimer = Timer:new("a_wizard_book_reset", 20 * 5 * 60);
local wizardBookTimerRunning = false;
local wizardBookLocation = Location:new(world, -486, 87, -204);
local wizardBookChest = Location:new(world, -496, 62, -200);

function a_wizard_book_open(data)
	local player = Player:new(data.player);
	if wizardBookPlayers[player.name] == nil then
		wizardBookPlayers[player.name] = true;
		player:sendMessage("&eYou find an old book in the chest..");
		wizardBookLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		wizardBookChest:cloneChestToPlayer(player.name);
		
		if not wizardBookTimerRunning then
			wizardBookTimer:start();
			wizardBookTimerRunning = true;
		end
	end
end

function a_wizard_book_reset()
	wizardBookTimerRunning = false;
	wizardBookPlayers = {};
end

local wizTrapDoorBlock = Location:new(world, -491, 86, -212);
local wizTrapDoorOpen = false;
local wizTrapDoorTimer = Timer:new("a_wiz_trap_door_close", 20 * 5);

function a_wiz_trap_door_open()
	if not wizTrapDoorOpen then
		wizTrapDoorBlock:setBlock(0, 0);
		wizTrapDoorBlock:playSound('PISTON_RETRACT', 1, 0);
		wizTrapDoorOpen = true;
		wizTrapDoorTimer:start();
	end
end

function a_wiz_trap_door_close()
	wizTrapDoorOpen = false;
	wizTrapDoorBlock:setBlock(98, 0);
	wizTrapDoorBlock:playSound('PISTON_RETRACT', 1, 0);
end

registerHook("INTERACT", "a_wiz_trap_door_open", 143, world.name, -491, 88, -212);
registerHook("INTERACT", "a_wiz_trap_door_open", 143, world.name, -491, 84, -213);

-- ENTRY TO THE ADVENTURE

local spawnWorld = World:new('spawn');
local minecartSpot = Location:new(spawnWorld, -9948.5, 127.5, -9939.5);
local minecart = Entity:new(minecartSpot);
local minecartTimer = Timer:new("a_player_timer_reset", 20 * 1);
local minecartLock = false;
local minecartAwayLocation = Location:new(spawnWorld, -9948, 127.5, -9948);
local startLocation = Location:new(world, -4997.5, 80, -5036.5);

function a_player_start(data)
	if not minecartLock then
		minecart:spawnMinecart(171, 9);
		minecart:putPlayerOn(data.player);
		minecartTimer:start();
		minecartLock = true;
		local player = Player:new(data.player);
		player:lockMount();
	end
end

function a_player_timer_reset()
	minecartLock = false;
end

function a_player_restrict(data)
end

local startChest = Location:new(world, -4995, 87, -5056);

function a_player_teleport(data)
	local player = Player:new(data.player);
	player:dismount();
	player:unlockMount();		
	player:sendMessage("&eWelcome to The Adventure! Please take a moment to read the book in your inventory before the boat sets sail!");
	
	if boatHasCrashed then
		player:teleport(boatLateLocation);
		a_whisper_npc(captain, "It appears ye be late to th' show! Our ship crashed up 'ere, we need to get off this blasted island. Explore and find out what y'can! SCRAM!", player);
	else
		player:teleport(startLocation);
	end
	startLocation:playSound('PORTAL_TRAVEL', 0.3, 2);
	startChest:cloneChestToPlayer(player.name);
end

registerHook("INTERACT", "a_player_start", 77, spawnWorld.name, -9949, 127, -9942);
registerHook("REGION_ENTER", "a_player_restrict", "spawn-adventure_restrict");
registerHook("REGION_ENTER", "a_player_teleport", "spawn-adventure_teleport");

-- TRIAL DOOR CODE

local trialEnterLoc = Location:new(world, -11.5, 63, -196);
trialEnterLoc:setYaw(180);
trialEnterLoc:setPitch(42);

function a_trial_door_error(player)
	player:sendMessage('&cThe door requires some kind of talisman to open..');
end

function a_trial_door_teleport(player, location)
	player:teleport(location);
	location:playSound('PORTAL', 1, 2);
	location:playEffect('PORTAL', 30, 200, 5);
end

function a_trial_door_check(data, talisman, location)
	local player = Player:new(data.player);
	if player:hasItemWithName('§rTalisman of ' .. talisman) then
		a_trial_door_teleport(player, location);
	else
		a_trial_door_error(player);
	end
end

-- TRIAL OF FIRE

local fireOutside = Location:new(world, -11, 64, -187);
local fireRuneChest = Location:new(world, -16, 66, -195);

function a_fire_exit(data)
	local player = Player:new(data.player);
	player:teleport(fireOutside);
	fireOutside:playSound('PORTAL_TRIGGER', 1, 2);
	fireRuneChest:cloneChestToPlayer(player.name);
	player:sendMessage("&eSearching the chest you find a rune, removing it from the chest you suddenly find yourself back outside the trial with the rune still in your hand.");
end

registerHook("INTERACT", "a_fire_exit", 54, world.name, 69, 45, -230);

function a_fire_teleport(player)
	a_trial_door_teleport(player, trialEnterLoc);
end


function a_trial_of_fire_door(data)
	a_trial_door_check(data, 'Fire', trialEnterLoc);
end

registerHook("INTERACT", "a_trial_of_fire_door", 77, world.name, -12, 65, -194);


-- Fire jump

local fireJumpSpots = {
	[1] = {
		Location:new(world, -5, 54, -238),
		Location:new(world, -4, 54, -237),
		Location:new(world, -5, 54, -237),
		Location:new(world, -4, 54, -238),
	},
	[2] = {
		Location:new(world, -5, 54, -233),
		Location:new(world, -4, 54, -232),
		Location:new(world, -5, 54, -232),
		Location:new(world, -4, 54, -233),
	},
	[3] = {
		Location:new(world, -5, 54, -228),
		Location:new(world, -4, 54, -227),
		Location:new(world, -5, 54, -227),
		Location:new(world, -4, 54, -228),
	},
	[4] = {
		Location:new(world, -5, 54, -223),
		Location:new(world, -4, 54, -222),
		Location:new(world, -5, 54, -222),
		Location:new(world, -4, 54, -223),
	},
	[5] = {
		Location:new(world, 1, 54, -238),
		Location:new(world, 0, 54, -237),
		Location:new(world, 1, 54, -237),
		Location:new(world, 0, 54, -238)
	},
	[6] = {
		Location:new(world, 1, 54, -233),
		Location:new(world, 0, 54, -232),
		Location:new(world, 1, 54, -232),
		Location:new(world, 0, 54, -233)
	},
	[7] = {
		Location:new(world, 1, 54, -228),
		Location:new(world, 0, 54, -227),
		Location:new(world, 1, 54, -227),
		Location:new(world, 0, 54, -228)
	},
	[8] = {
		Location:new(world, 1, 54, -223),
		Location:new(world, 0, 54, -222),
		Location:new(world, 1, 54, -222),
		Location:new(world, 0, 54, -223)
	},
	[9] = {
		Location:new(world, 6, 54, -238),
		Location:new(world, 5, 54, -237),
		Location:new(world, 6, 54, -237),
		Location:new(world, 5, 54, -238)
	},
	[10] = {
		Location:new(world, 6, 54, -233),
		Location:new(world, 5, 54, -232),
		Location:new(world, 6, 54, -232),
		Location:new(world, 5, 54, -233)
	},
	[11] = {
		Location:new(world, 6, 54, -228),
		Location:new(world, 5, 54, -227),
		Location:new(world, 6, 54, -227),
		Location:new(world, 5, 54, -228)
	},
	[12] = {
		Location:new(world, 6, 54, -223),
		Location:new(world, 5, 54, -222),
		Location:new(world, 6, 54, -222),
		Location:new(world, 5, 54, -223)
	},
	[13] = {
		Location:new(world, 11, 54, -238),
		Location:new(world, 10, 54, -237),
		Location:new(world, 11, 54, -237),
		Location:new(world, 10, 54, -238)
	},
	[14] = {
		Location:new(world, 11, 54, -233),
		Location:new(world, 10, 54, -232),
		Location:new(world, 11, 54, -232),
		Location:new(world, 10, 54, -233)
	},
	[15] = {
		Location:new(world, 11, 54, -228),
		Location:new(world, 10, 54, -227),
		Location:new(world, 11, 54, -227),
		Location:new(world, 10, 54, -228)
	},
	[16] = {
		Location:new(world, 11, 54, -223),
		Location:new(world, 10, 54, -222),
		Location:new(world, 11, 54, -222),
		Location:new(world, 10, 54, -223)
	},
	[17] = {
		Location:new(world, 16, 54, -238),
		Location:new(world, 15, 54, -237),
		Location:new(world, 16, 54, -237),
		Location:new(world, 15, 54, -238)
	},
	[18] = {
		Location:new(world, 16, 54, -233),
		Location:new(world, 15, 54, -232),
		Location:new(world, 16, 54, -232),
		Location:new(world, 15, 54, -233)
	},
	[19] = {
		Location:new(world, 16, 54, -228),
		Location:new(world, 15, 54, -227),
		Location:new(world, 16, 54, -227),
		Location:new(world, 15, 54, -228)
	},
	[20] = {
		Location:new(world, 16, 54, -223),
		Location:new(world, 15, 54, -222),
		Location:new(world, 16, 54, -222),
		Location:new(world, 15, 54, -223)
	},
	[21] = {
		Location:new(world, 21, 54, -238),
		Location:new(world, 20, 54, -237),
		Location:new(world, 21, 54, -237),
		Location:new(world, 20, 54, -238)
	},
	[22] = {
		Location:new(world, 21, 54, -233),
		Location:new(world, 20, 54, -232),
		Location:new(world, 21, 54, -232),
		Location:new(world, 20, 54, -233)
	},
	[23] = {
		Location:new(world, 21, 54, -228),
		Location:new(world, 20, 54, -227),
		Location:new(world, 21, 54, -227),
		Location:new(world, 20, 54, -228)
	},
	[24] = {
		Location:new(world, 21, 54, -223),
		Location:new(world, 20, 54, -222),
		Location:new(world, 21, 54, -222),
		Location:new(world, 20, 54, -223)
	}
};

local fireJumpSeq = {
	{1},
	{1, 5},
	{5, 6},
	{6, 10, 7},
	{10, 7, 8, 9},
	{9, 13},
	{13, 17},
	{17, 18},
	{18, 14},
	{14, 15},
	{15, 16},
	{16, 20},
	{20, 19},
	{19, 23},
	{23}
};

local currentSeqStep = 1;

function a_fire_jump_change()
	for key, value in pairs(fireJumpSpots) do
		value[1]:setBlock(51, 0);
		value[2]:setBlock(51, 0);
		value[3]:setBlock(51, 0);
		value[4]:setBlock(51, 0);
	end
	
	for key, value in pairs(fireJumpSeq[currentSeqStep]) do
		local blockSet = fireJumpSpots[value];
		
		blockSet[1]:setBlock(0, 0);
		blockSet[2]:setBlock(0, 0);
		blockSet[3]:setBlock(0, 0);
		blockSet[4]:setBlock(0, 0);
	end
	
	if currentSeqStep == #fireJumpSeq then
		currentSeqStep = 1;
	else
		currentSeqStep = currentSeqStep + 1;
	end
end

registerHook("BLOCK_GAINS_CURRENT", "a_fire_jump_change", world.name, -19, 22, -232);

function a_fire_jump_hit(data)
	local player = Player:new(data.player);
	if a_within_bounds(player, -8, 53, -242, 24, 58, -218) then		
		a_fire_teleport(player);
	end
end

registerHook("PLAYER_DAMAGE", "a_fire_jump_hit", world.name);

-- Fire doors

function a_fire_doors_hit(data)
	local player = Player:new(data.player);
	
	if data.cause == 'LAVA' and a_within_bounds(player, 30, 54, -240, 46, 57, -220) then
		if a_within_bounds(player, 30, 54, -234, 33, 57, -231) then
			return;
		end
		
		if a_within_bounds(player, 37, 54, -223, 40, 57, -220) then
			return;
		end
		
		if a_within_bounds(player, 44, 54, -240, 47, 57, -237) then
			return;
		end
		
		a_fire_teleport(player);
	end
end

registerHook("PLAYER_DAMAGE", "a_fire_doors_hit", world.name);

-- Lava vagina

function a_lava_vagina_hit(data)
	local player = Player:new(data.player);
	if a_within_bounds(player, 49, 48, -238, 65, 54, -222) then
		a_fire_teleport(player);
	end
end

registerHook("PLAYER_DAMAGE", "a_lava_vagina_hit", world.name);

-- TRIAL OF THE MIND

local mindOutside = Location:new(world, 350, 64, -179);
local mindRuneChest = Location:new(world, 346, 66, -187);

function a_mind_exit(data)
	local player = Player:new(data.player);
	player:teleport(mindOutside);
	mindOutside:playSound('PORTAL_TRIGGER', 1, 2);
	mindRuneChest:cloneChestToPlayer(player.name);
	player:sendMessage("&eSearching the chest you find a rune, removing it from the chest you suddenly find yourself back outside the trial with the rune still in your hand.");
end

registerHook("INTERACT", "a_mind_exit", 54, world.name, 436, 55, -216);
registerHook("INTERACT", "a_mind_exit", 54, world.name, 436, 55, -217);

local mindTrialEnterLoc = Location:new(world, 350.5, 62, -189);
mindTrialEnterLoc:setYaw(180);
mindTrialEnterLoc:setPitch(42);

function a_trial_of_mind_door(data)
	a_trial_door_check(data, 'Mind', mindTrialEnterLoc);
end

local mindEntryEffectLocations = {
	Location:new(world, 354.5, 57, -197.5),
	Location:new(world, 354.5, 57, -199.5),
	Location:new(world, 354.5, 57, -201.5),
	Location:new(world, 354.5, 57, -203.5),
	Location:new(world, 354.5, 57, -205.5),
	Location:new(world, 354.5, 57, -207.5),
	Location:new(world, 346.5, 57, -197.5),
	Location:new(world, 346.5, 57, -199.5),
	Location:new(world, 346.5, 57, -201.5),
	Location:new(world, 346.5, 57, -203.5),
	Location:new(world, 346.5, 57, -205.5),
	Location:new(world, 346.5, 57, -207.5)
};

function a_mind_entry_effect()
	for key, value in pairs(mindEntryEffectLocations) do
		value:playEffect('ENCHANTMENT_TABLE', 10, 100, 5);
	end
end

registerHook("BLOCK_GAINS_CURRENT", "a_mind_entry_effect", world.name, 325, 56, -207);
registerHook("INTERACT", "a_trial_of_mind_door", 77, world.name, 350, 65, -186);

function a_mind_maze_hit()
	local players = {world:getPlayers()};
	
	for key, value in pairs(players) do
		local player = Player:new(value);
		if a_within_bounds(player, 353, 53, -221, 369, 57, -211) then
			local world, x, y, z = player:getLocation();
			local block = Location:new(world, x, y - 1, z);
			
			local blockID = block:getBlock();
			
			if blockID == 35 then
				a_trial_door_teleport(player, mindTrialEnterLoc);
			end
		end
		
		if a_within_bounds(player, 374, 53, -221, 390, 57, -211) then
			local world, x, y, z = player:getLocation();
			local block = Location:new(world, x - 21, y - 1, z);
			
			local blockID = block:getBlock();
			if blockID == 35 then
				a_trial_door_teleport(player, mindTrialEnterLoc);
			end
		end
		
		if a_within_bounds(player, 395, 53, -221, 411, 57, -211) then
			local world, x, y, z = player:getLocation();
			local block = Location:new(world, x, y - 2, z);
			
			local blockID = block:getBlock();
			if blockID == 35 then
				a_trial_door_teleport(player, mindTrialEnterLoc);
			end
		end
	end
end

registerHook("BLOCK_GAINS_CURRENT", "a_mind_maze_hit", world.name, 354, 54, -224);

-- Lever, Sign, Woolblock, redstoneblock, currentValue
local pressureValues = {
	{
		Location:new(world, 424, 54, -213),
		Location:new(world, 424, 55, -212),
		Location:new(world, 424, 57, -211),
		Location:new(world, 424, 56, -209),
		0
	},
	{
		Location:new(world, 419, 54, -213),
		Location:new(world, 419, 55, -212),
		Location:new(world, 419, 57, -211),
		Location:new(world, 419, 56, -209),
		0
	},
	{
		Location:new(world, 424, 54, -220),
		Location:new(world, 424, 55, -221),
		Location:new(world, 424, 57, -222),
		Location:new(world, 424, 56, -224),
		0
	},
	{
		Location:new(world, 419, 54, -220),
		Location:new(world, 419, 55, -221),
		Location:new(world, 419, 57, -222),
		Location:new(world, 419, 56, -224),
		0
	}
};

local mindPressureOpenBlock = Location:new(world, 434, 55, -217);
local mindPressureOpenTimer = Timer:new("a_mind_pressure_close", 20 * 10);
local mindPressureOpenTimerRunning = false;

function a_mind_pressure_close()
	mindPressureOpenTimerRunning = false;
	mindPressureOpenBlock:setBlock(152, 0);
end

function a_mind_pressure_update()
	local canUnlock = true;
	for key, value in pairs(pressureValues) do
		value[2]:setSign("", "Pressure:", value[5], "");
		
		local block = 0;
		local dataValue = 14;
		if value[5] == 100 then
			block = 152;
			dataValue = 5;
		else
			canUnlock = false;
		end
		
		value[4]:setBlock(block, 0);
		value[3]:setBlock(35, dataValue);
	end
	
	if canUnlock then
		mindPressureOpenTimerRunning = true;
		mindPressureOpenTimer:start();
		mindPressureOpenBlock:setBlock(0, 0);
	end
end

function a_mind_pressure_lever(data)
	for key, value in pairs(pressureValues) do
		local leverLoc = value[1];
		
		if leverLoc.x == data.x and leverLoc.y == data.y and leverLoc.z == data.z then
			
			if value[5] >= 95 then
				pressureValues[key][5] = 100;
			else
				pressureValues[key][5] = value[5] + 5;
			end
			
			a_mind_pressure_update();
			return;
		end
	end
end

for key, value in pairs(pressureValues) do
	local leverLoc = value[1];
	registerHook("INTERACT", "a_mind_pressure_lever", 69, world.name, leverLoc.x, leverLoc.y, leverLoc.z);
end

function a_mind_pressure_tick()
	for key, value in pairs(pressureValues) do
	
		if value[5] > 0 then
			pressureValues[key][5] = value[5] - 1;
		end
	end
	a_mind_pressure_update();
end

registerHook("BLOCK_GAINS_CURRENT", "a_mind_pressure_tick", world.name, 426, 52, -203);


-- TRIAL OF WATER

local waterTrialEnterLoc = Location:new(world, -108.5, 62, 279);
waterTrialEnterLoc:setYaw(180);
waterTrialEnterLoc:setPitch(42);

function a_trial_of_water_door(data)
	a_trial_door_check(data, 'Water', waterTrialEnterLoc);
end

registerHook("INTERACT", "a_trial_of_water_door", 77, world.name, -108, 65, 282);

local splashLocations = {
	Location:new(world, -103.5, 56, 260.5),
	Location:new(world, -103.5, 56, 262.5),
	Location:new(world, -103.5, 56, 264.5),
	Location:new(world, -103.5, 56, 266.5),
	Location:new(world, -103.5, 56, 268.5),
	Location:new(world, -103.5, 56, 270.5),
	Location:new(world, -111.5, 56, 260.5),
	Location:new(world, -111.5, 56, 262.5),
	Location:new(world, -111.5, 56, 264.5),
	Location:new(world, -111.5, 56, 266.5),
	Location:new(world, -111.5, 56, 268.5),
	Location:new(world, -111.5, 56, 270.5)
};

function a_water_trial_splash()
	for key, value in pairs(splashLocations) do
		value:playEffect('SPLASH', 40, 200, 5);
	end
end

registerHook("BLOCK_GAINS_CURRENT", "a_water_trial_splash", world.name, -86, 53, 273);

local cauldrons = {
	{Location:new(world, -106, 53, 236), 0},
	{Location:new(world, -106, 53, 240), 0},
	{Location:new(world, -110, 53, 240), 0},
	{Location:new(world, -110, 53, 236), 0}
};

function a_water_c_update()
	for key, value in pairs(cauldrons) do
		value[1]:setBlock(118, value[2]);
	end
end

function a_water_c_increase(data)
	local cldron = Location:new(world, data.x, data.y - 1, data.z - 1);
	
	for key, value in pairs(cauldrons) do
		local cldLoc = value[1];
		if cldLoc.x == data.x and cldLoc.y == data.y - 1 and cldLoc.z == data.z - 1 then
			if value[2] < 3 then
				value[2] = value[2] + 1;
			end
			a_water_c_update();
			return;
		end
	end
end

function a_water_c_decrease(data)
	local cldron = Location:new(world, data.x, data.y - 1, data.z + 1);
	
	for key, value in pairs(cauldrons) do
		local cldLoc = value[1];
		if cldLoc.x == data.x and cldLoc.y == data.y - 1 and cldLoc.z == data.z + 1 then
			if value[2] > 0 then
				value[2] = value[2] - 1;
			end
			a_water_c_update();
			return;
		end
	end
end

for key, value in pairs(cauldrons) do
	local cldLoc = value[1];
	registerHook("INTERACT", "a_water_c_increase", 69, world.name, cldLoc.x, cldLoc.y + 1, cldLoc.z + 1);
	registerHook("INTERACT", "a_water_c_decrease", 69, world.name, cldLoc.x, cldLoc.y + 1, cldLoc.z - 1);
end

local waterOutside = Location:new(world, -107, 64, 287);
local waterRuneChest = Location:new(world, -104, 54, 220);

function a_water_exit(data)
	local player = Player:new(data.player);
	player:teleport(waterOutside);
	waterOutside:playSound('PORTAL_TRIGGER', 1, 2);
	waterRuneChest:cloneChestToPlayer(player.name);
	player:sendMessage("&eSearching the chest you find a rune, removing it from the chest you suddenly find yourself back outside the trial with the rune still in your hand.");
end

registerHook("INTERACT", "a_water_exit", 54, world.name, -108, 52, 222);

-- TRIAL OF ASTRAL

local astralTrialEnterLoc = Location:new(world, 212.5, 62, 191);
astralTrialEnterLoc:setYaw(180);
astralTrialEnterLoc:setPitch(42);

function a_trial_of_astral_door(data)
	a_trial_door_check(data, 'Astral', astralTrialEnterLoc);
end

registerHook("INTERACT", "a_trial_of_astral_door", 77, world.name, 212, 65, 194);

function a_trial_astral_jump(data)
	local player = Player:new(data.player);
	player:setVelocity(0, 3.5, 0);
end

registerHook("INTERACT", "a_trial_astral_jump", 77, world.name, 212, 2, 168);

local astralOutside = Location:new(world, 212, 64, 200);
local astralRuneChest = Location:new(world, 202, 43, 110);

function a_astral_exit(data)
	local player = Player:new(data.player);
	player:teleport(astralOutside);
	astralOutside:playSound('PORTAL_TRIGGER', 1, 2);
	astralRuneChest:cloneChestToPlayer(player.name);
	player:sendMessage("&eSearching the chest you find a rune, removing it from the chest you suddenly find yourself back outside the trial with the rune still in your hand.");
end

registerHook("INTERACT", "a_astral_exit", 54, world.name, 206, 42, 110);

-- TRIAL OF EARTH

local earthTrialEnterLoc = Location:new(world, -346.5, 62, 4);
earthTrialEnterLoc:setYaw(180);
earthTrialEnterLoc:setPitch(42);

function a_trial_of_earth_door(data)
	a_trial_door_check(data, 'Earth', earthTrialEnterLoc);
end

registerHook("INTERACT", "a_trial_of_earth_door", 77, world.name, -347, 65, 7);

local firstLogPlayers = {};
local firstLogTimer = Timer:new('a_first_log_reset', 20 * 60 * 5);
local firstLogTimerRunning = false;
local firstLogLocation = Location:new(world, -359, 3, 0);
local firstLogChest = Location:new(world, -361, 3, 1);

function a_first_log_reset()
	firstLogTimerRunning = false;
	firstLogPlayers = {};
end

function a_first_log_open(data)
	local player = Player:new(data.player);
	
	if firstLogPlayers[player.name] == nil then
		player:sendMessage('&eReaching into the chest you find a log chunk.');
		firstLogLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		firstLogChest:cloneChestToPlayer(player.name);
		firstLogPlayers[player.name] = true;
		
		if not firstLogTimerRunning then
			firstLogTimerRunning = true;
			firstLogTimer:start();
		end
	end
end

registerHook("INTERACT", "a_first_log_open", 54, world.name, firstLogLocation.x, firstLogLocation.y, firstLogLocation.z);

local secondLogPlayers = {};
local secondLogTimer = Timer:new('a_second_log_reset', 20 * 60 * 5);
local secondLogTimerRunning = false;
local secondLogLocation = Location:new(world, -302, 2, 21);
local secondLogChest = Location:new(world, -298, 3, 35);

function a_second_log_reset()
	secondLogTimerRunning = false;
	secondLogPlayers = {};
end

function a_second_log_open(data)
	local player = Player:new(data.player);
	
	if secondLogPlayers[player.name] == nil then
		player:sendMessage('&eReaching into the chest you find a log chunk.');
		secondLogLocation:playSound('HORSE_SADDLE', 1, 0);
		player:closeInventory();
		secondLogChest:cloneChestToPlayer(player.name);
		secondLogPlayers[player.name] = true;
		
		if not secondLogTimerRunning then
			secondLogTimerRunning = true;
			secondLogTimer:start();
		end
	end
end

registerHook("INTERACT", "a_second_log_open", 54, world.name, secondLogLocation.x, secondLogLocation.y, secondLogLocation.z);

local earthOutside = Location:new(world, -346, 64, 12);
local earthRuneChest = Location:new(world, -342, 5, 20);

function a_earth_exit(data)
	local player = Player:new(data.player);
	player:teleport(earthOutside);
	earthOutside:playSound('PORTAL_TRIGGER', 1, 2);
	earthRuneChest:cloneChestToPlayer(player.name);
	player:sendMessage("&eSearching the chest you find a rune, removing it from the chest you suddenly find yourself back outside the trial with the rune still in your hand.");
end

registerHook("INTERACT", "a_earth_exit", 54, world.name, -343, 3, 18);
registerHook("INTERACT", "a_earth_exit", 54, world.name, -342, 3, 18);

local keyLoc = Location:new(world, -342, 3, 16);

function a_earth_key(data)
	local player = Player:new(data.player);
	if player:hasItemWithName('Spruce Wood Keyblock') and player:hasItemWithName('Jungle Wood Keyblock') then
		player:teleport(keyLoc);
	else
		player:sendMessage('&cTwo keyblocks are required for this door!');
	end
end

registerHook("INTERACT", "a_earth_key", 77, world.name, -341, 4, 12);

-- TRIAL END

local runes = {'Fire', 'Mind', 'Astral', 'Water', 'Earth'};

function a_event_end_lever(data)
	local player = Player:new(data.player);
	
	for key, value in pairs(runes) do
		if not player:hasItemWithName('§f§bRune of ' .. value) then
			player:sendMessage('&cIt appears that five runes are required to activate this..');
			return;
		end
	end
	
	player:clearInventory();
	player:teleport(minecartAwayLocation);
	minecartAwayLocation:playSound('PORTAL_TRIGGER', 1, 2);
	player:sendMessage('&aWell done! You have completed the adventure!');
end

registerHook("INTERACT", "a_event_end_lever", 69, world.name, -169, 65, -320);