local liftHeight = 49;
local liftLocation = Location:new("development", -262, 50, 493);
local liftCurrentHeight = 0;
local liftDirection = true; -- True: Down, False: Up
local liftMotor = Timer:new("lift_trigger", 2 * 20);
local liftTrigger = Timer:new("lift_move", 1 * 20);

local liftFormat = {
	{0, 0, 33, 1},
	{1, 1, 33, 1},
	{1, 0, 33, 1},
	{0, 1, 33, 1},
	{-1, -1, 33, 1},
	{-1, 0, 33, 1},
	{0, -1, 33, 1},
	{1, -1, 33, 1},
	{-1, 1, 33, 1}
};

function lift_clearShaft()
	for y = liftLocation.y - liftHeight - 1, liftLocation.y + 1 do	
		-- Remove things in the shaft.
		for index, node in ipairs(liftFormat) do
			local block = Location:new(liftLocation.world, liftLocation.x + node[1], y, liftLocation.z + node[2]);
			block:setBlock(0, 0);
		end
	end
end

function lift_render(offset)
	lift_clearShaft();
	for index, node in ipairs(liftFormat) do
		local block = Location:new(liftLocation.world, liftLocation.x + node[1], liftLocation.y + offset, liftLocation.z + node[2]);
		block:setBlock(node[3], node[4]);
	end
end
lift_render(liftCurrentHeight);

function lift_trigger()
	if not liftDirection and liftCurrentHeight > 0 then
		for index, node in ipairs(liftFormat) do
			local block = Location:new(liftLocation.world, liftLocation.x + node[1], liftLocation.y + (-1 - liftCurrentHeight), liftLocation.z + node[2]);
			block:setBlock(152, 0);
		end
	end
	liftTrigger:start();
end

function lift_move()
	if liftDirection then
		-- Moving down
		if liftCurrentHeight == liftHeight then
			liftDirection = false;
		else
			liftCurrentHeight = liftCurrentHeight + 1;
			lift_render(0 - liftCurrentHeight);
		end
	else
		-- Moving up
		if liftCurrentHeight == 0 then
			liftDirection = true;
		else
			liftCurrentHeight = liftCurrentHeight - 1;
			lift_render(0 - liftCurrentHeight);
		end
	end
end
--liftMotor:startRepeating();

function lift_kill()
	liftMotor:cancel();
end

registerHook("INTERACT", "lift_kill", 77, "development", -265, 6, 498);