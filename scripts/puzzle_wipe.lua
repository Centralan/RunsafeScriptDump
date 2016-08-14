function puzzleWipeInventory(data)
	local player = Player:new(data["player"]);
	player:clearInventory();
	player:addItem(331, 0, 1);
end

registerHook("REGION_ENTER", "puzzleWipeInventory", "puzzle-puzzle_wipe");