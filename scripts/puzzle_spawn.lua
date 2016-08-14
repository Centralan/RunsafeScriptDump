function spawnButtonPress()
	engine.world.setBlock('puzzle', 990, 52, 965, 0, 0);
	engine.world.setBlock('puzzle', 990, 51, 965, 0, 0);
end

function spawnButtonReset()
	engine.world.setBlock('puzzle', 990, 52, 965, 79, 0);
	engine.world.setBlock('puzzle', 990, 51, 965, 79, 0);
end

registerHook("INTERACT", "spawnButtonPress", 77, "spawn", 56, 13, 11);
registerHook("REGION_ENTER", "spawnButtonReset", "puzzle-ice1");
registerHook("REGION_ENTER", "spawnButtonReset", "puzzle-ice2");