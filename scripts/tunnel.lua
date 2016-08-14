function tunnel_start(data)
	local p = Player:new(data["player"]);
	p:clearInventory();
	p:removePotionEffects();
end

registerHook("REGION_ENTER", "tunnel_start", "spawn-tunnel_start");
registerHook("REGION_LEAVE", "tunnel_start", "spawn-tunnel_start");

function tunnel_complete(data, ach)
	local p = Player:new(data["player"]);
	p:sendEvent("achievement.tunnel" .. ach);
	p:addPermission("runsafe.tunnel." .. ach);
end

function tunnel_complete_one(data)
	tunnel_complete(data, "1");
end

function tunnel_complete_two(data)
	tunnel_complete(data, "2");
end

function tunnel_complete_three(data)
	tunnel_complete(data, "3");
end

function tunnel_complete_four(data)
	tunnel_complete(data, "4");
end

function tunnel_end(data)
	local p = Player:new(data["player"]);
	p:sendEvent("achievement.tunnelEnd");
end

registerHook("REGION_ENTER", "tunnel_complete_one", "spawn-t2");
registerHook("REGION_ENTER", "tunnel_complete_two", "spawn-t3");
registerHook("REGION_ENTER", "tunnel_complete_three", "spawn-t4");
registerHook("REGION_ENTER", "tunnel_complete_four", "spawn-t5");
registerHook("REGION_ENTER", "tunnel_end", "spawn-tunnel_end");
