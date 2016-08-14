function puzzleFloorEntry_updateFloorTile(z, blockID)
    engine.world.setBlock('puzzle', 1023, 79, z, blockID, 0);
end

function puzzleFloorEntry_updateFloor(blockID)
    puzzleFloorEntry_updateFloorTile(996, blockID);
    puzzleFloorEntry_updateFloorTile(997, blockID);
    puzzleFloorEntry_updateFloorTile(998, blockID);
    puzzleFloorEntry_updateFloorTile(999, blockID);
    puzzleFloorEntry_updateFloorTile(1000, blockID);
    puzzleFloorEntry_updateFloorTile(1001, blockID);
end

function puzzleFloorEntry()
	engine.world.setBlock("puzzle", 1023, 80, 997, 0, 0);
	puzzleFloorEntry_updateFloor(0);
	engine.world.setBlock("puzzle", 1012, 80, 996, 152, 0);
end

function puzzleFloorEntry_close()
	puzzleFloorEntry_updateFloor(5);
	engine.world.setBlock("puzzle", 1012, 80, 996, 0, 0);
	engine.world.setBlock("puzzle", 1023, 80, 997, 70, 0);
end

registerHook("INTERACT", "puzzleFloorEntry", 70, "puzzle", 1023, 80, 997);
registerHook("BLOCK_GAINS_CURRENT", "puzzleFloorEntry_close", "puzzle", 1019, 80, 996);