local world = World:new('spawn2');
local creative = World:new('creative');
local com = World:new('com');
local survival = World:new('survival3');
local worldSurvival = World:new('survival3');
local worldNether = World:new('survival3_nether');
local soundblock = Location:new(world, -1602, 129, -511);
local ai = 'DOG'


--------------
--- EFFECTS ---
--------------

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
					if player:hasItemWithName("§3Effect: §b" .. effect[1]) then
						local world, x, y, z = player:getLocation();
						local playerLoc = Location:new(world, x, y + effect[5], z);
						playerLoc:playEffect(effect[2], effect[3], effect[4], 20);
					end
				end
			end
		end
	end
end

--------------
--- Tramps ---
--------------

function tramp(data)
	local player = Player:new(data.player);
	player:setVelocity(0, 3, 0);
end


registerHook("BLOCK_GAINS_CURRENT", "fireTick", "spawn2", -1602, 129, -511);
registerHook("REGION_ENTER", "lava_hole", "spawn2-lava_hole");
registerHook("REGION_ENTER", "tramp", "spawn2-tramp");
