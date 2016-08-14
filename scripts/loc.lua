function loc_func(data)
	local player = Player:new(data.player);
	local world, x, y, z, yaw, pitch = player:getLocation();
	player:sendMessage('X: ' .. x);
	player:sendMessage('Y: ' .. y);
	player:sendMessage('Z: ' .. z);
	player:sendMessage('Yaw: ' .. yaw);
	player:sendMessage('Pitch: ' .. pitch);
end

registerHook("CHAT_MESSAGE", "loc_func", "scotty");