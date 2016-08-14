function resetSwitch(x, blockId, data)
    engine.world.setBlock('puzzle', x, 39, 950, blockId, data);
end

function resetSwitchFull()
	resetSwitch(953, 0, 0);
	resetSwitch(951, 0, 0);
	resetSwitch(949, 0, 0);
	resetSwitch(947, 0, 0);
	resetSwitch(945, 0, 0);
	resetSwitch(943, 0, 0);

	resetSwitch(934, 0, 0);
	resetSwitch(932, 0, 0);
	resetSwitch(930, 0, 0);
	resetSwitch(928, 0, 0);
	resetSwitch(926, 0, 0);
	resetSwitch(924, 0, 0);
end

--registerHook("BLOCK_GAINS_CURRENT", "resetSwitchFull", "puzzle", 937, 33, 915);
registerHook("BLOCK_GAINS_CURRENT", "resetSwitchFull", "puzzle", 939, 33, 915);