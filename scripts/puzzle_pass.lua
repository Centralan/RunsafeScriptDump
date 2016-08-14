local doorPassKeyBlock = Location:new('puzzle', 1056, 87, 991);
local doorPassRedstoneBlock = Location:new('puzzle', 1048, 87, 984);
local doorPassParts = {
	Location:new('puzzle', 1056, 88, 992),
	Location:new('puzzle', 1056, 88, 991),
	Location:new('puzzle', 1056, 88, 990),
	Location:new('puzzle', 1056, 87, 992),
	Location:new('puzzle', 1056, 87, 991),
	Location:new('puzzle', 1056, 87, 990),
	Location:new('puzzle', 1056, 86, 992),
	Location:new('puzzle', 1056, 86, 991),
	Location:new('puzzle', 1056, 86, 990),
	Location:new('puzzle', 1055, 87, 991),
};

function openDoorPass()
	if doorPassKeyBlock:getBlock() == 42 then
		for k, v in pairs(doorPassParts) do
			engine.world.setBlock(v.world, v.x, v.y, v.z, 0, 0);
		end
		doorPassRedstoneBlock:setBlock(152, 0);
	end
end

function closeDoorPass()
	doorPassRedstoneBlock:setBlock(0, 0);
	for k, v in pairs(doorPassParts) do
		engine.world.setBlock(v.world, v.x, v.y, v.z, 5, 1);
	end
	engine.world.setBlock(doorPassKeyBlock.world, doorPassKeyBlock.x, doorPassKeyBlock.y, doorPassKeyBlock.z, 0, 0);
end

registerHook("INTERACT", "openDoorPass", 77, "puzzle", 1057, 87, 990);
registerHook("BLOCK_GAINS_CURRENT", "closeDoorPass", "puzzle", 1057, 87, 984);
