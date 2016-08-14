function puzzleTree(data)
	local player = Player:new(data["player"]);
	player:addItem(260, 0, 1);
	player:sendMessage("&eAn apple falls from the nearby tree and lands in your bag..");
end

registerHook("REGION_ENTER", "puzzleTree", "puzzle-appletree");