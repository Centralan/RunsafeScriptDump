local world = World:new('spawn2');
local bookChest = Location:new(world, 29995, 82, 29981);
local bookPlayers = {};

function giveBook(data)
	local player = Player:new(data.player);
	if bookPlayers[player.name] == nil then
		bookPlayers[player.name] = true;
		bookChest:cloneChestToPlayer(player.name);
		player:sendMessage("&bPlease make sure you read the signs. This is only feedback from the players, Admins will still pick the player they want. Your feedback may help so make it good.");
	end
end

registerHook("INTERACT", "giveBook", 77, world.name, 29998, 86, 29982);