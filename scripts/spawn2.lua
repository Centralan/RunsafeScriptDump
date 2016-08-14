function applySpawnSpeed(data)
        local player = Player:new(data.player);
        EventEngine.player.addPotionEffect(player.name, 'SPEED', 10, 30);
end

function revertSpawnSpeed(data)
        local player = Player:new(data.player);
        player:removePotionEffects();
end

local worldPre = "spawn2-";
local applyFunction = "applySpawnSpeed";
local revertFunction = "revertSpawnSpeed";

registerHook("REGION_ENTER", applyFunction, worldPre .. "creative_speed");
registerHook("REGION_LEAVE", revertFunction, worldPre .. "creative_speed");

registerHook("REGION_ENTER", applyFunction, worldPre .. "Minigames_Speed");
registerHook("REGION_LEAVE", revertFunction, worldPre .. "Minigames_Speed");

registerHook("REGION_ENTER", applyFunction, worldPre .. "Survival_Speed");
registerHook("REGION_LEAVE", revertFunction, worldPre .. "Survival_Speed");

registerHook("REGION_ENTER", applyFunction, worldPre .. "Info_Speed");
registerHook("REGION_LEAVE", revertFunction, worldPre .. "Info_Speed");


function tramp_low(data)
	local player = Player:new(data.player);
	player:setVelocity(0, 3, 0);
end

registerHook("REGION_ENTER", "tramp_low", "spawn2-tramp_hol");
registerHook("REGION_ENTER", "tramp_low", "spawn2-tramp_bank");
registerHook("REGION_ENTER", "tramp_low", "spawn2-tramp_market");
registerHook("REGION_ENTER", "tramp_low", "spawn2-tramp_event");
