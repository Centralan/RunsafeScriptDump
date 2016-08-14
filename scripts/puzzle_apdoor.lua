function puzzleApDoor_ignite()
	engine.world.setBlock('puzzle', 1015, 64, 1001, 51, 0);
	engine.world.setBlock("puzzle", 1012, 64, 1005, 152, 0);
end

function puzzleApDoor_reset()
	engine.world.setBlock("puzzle", 1012, 64, 1005, 0, 0);
	engine.world.setBlock('puzzle', 1015, 64, 1001, 148, 0);
end

registerHook("INTERACT", "puzzleApDoor_ignite", 70, "puzzle", 1015, 64, 1006);
registerHook("BLOCK_GAINS_CURRENT", "puzzleApDoor_reset", "puzzle", 1009, 64, 1005);