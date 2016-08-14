function updateFloorBlock(x, z, blockID, explo)
    engine.world.setBlock('puzzle', x, 85, z, blockID, 0);
    if explo then
        engine.effects.explosion('puzzle', x, 85, z, 2, false, false);
    end
end

function updateFloor(blockID, explo)
    updateFloorBlock(1030, 967, blockID, explo);
    updateFloorBlock(1029, 967, blockID, explo);
    updateFloorBlock(1028, 967, blockID, explo);
    updateFloorBlock(1030, 968, blockID, explo);
    updateFloorBlock(1028, 968, blockID, explo);
    updateFloorBlock(1029, 968, blockID, explo);
    updateFloorBlock(1030, 969, blockID, explo);
    updateFloorBlock(1029, 969, blockID, explo);
    updateFloorBlock(1028, 969, blockID, explo);
    updateFloorBlock(1030, 970, blockID, explo);
    updateFloorBlock(1029, 970, blockID, explo);
    updateFloorBlock(1028, 970, blockID, explo);
    updateFloorBlock(1030, 971, blockID, explo);
    updateFloorBlock(1029, 971, blockID, explo);
    updateFloorBlock(1028, 971, blockID, explo);
    updateFloorBlock(1031, 971, blockID, explo);
    updateFloorBlock(1031, 970, blockID, explo);
end

function activateMineTrap()
	updateFloor(0, true);
	engine.world.setBlock("puzzle", 1029, 87, 962, 152, 0);
end

function resetMineTrap()
	updateFloor(3, false);
	engine.world.setBlock("puzzle", 1029, 87, 962, 0, 0);
end

registerHook("INTERACT", "activateMineTrap", 69, "puzzle", 1028, 87, 967);
registerHook("BLOCK_GAINS_CURRENT", "resetMineTrap", "puzzle", 1029, 87, 955);