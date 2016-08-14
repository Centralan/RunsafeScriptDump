function resetSwitchOne(x, blockId, data)
    engine.world.setBlock('puzzle', x, 39, 950, blockId, data);
end

function resetSwitchFullOne()
	resetSwitch(953, 69, 4);
	resetSwitch(951, 69, 4);
	resetSwitch(949, 69, 4);
	resetSwitch(947, 69, 4);
	resetSwitch(945, 69, 4);
	resetSwitch(943, 69, 4);

	resetSwitch(934, 69, 4);
	resetSwitch(932, 69, 4);
	resetSwitch(930, 69, 4);
	resetSwitch(928, 69, 4);
	resetSwitch(926, 69, 4);
	resetSwitch(924, 69, 4);
end

--registerHook("BLOCK_GAINS_CURRENT", "resetSwitchFullOne", "puzzle", 939, 33, 915);
registerHook("BLOCK_GAINS_CURRENT", "resetSwitchFullOne", "puzzle", 937, 33, 915);