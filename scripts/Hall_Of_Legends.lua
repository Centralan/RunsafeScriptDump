local world = "spawn2";
local current = 1;
local maxData = 14;
local blocks = {
	Location:new(world, 30070.0, 82.0, 30002.0),
        Location:new(world, 30070.0, 82.0, 30003.0),
        Location:new(world, 30070.0, 82.0, 30004.0),
        Location:new(world, 30071.0, 82.0, 30001.0),
        Location:new(world, 30071.0, 82.0, 30002.0),
        Location:new(world, 30071.0, 82.0, 30003.0),
        Location:new(world, 30071.0, 82.0, 30004.0),
        Location:new(world, 30071.0, 82.0, 30005.0),
        Location:new(world, 30072.0, 82.0, 30001.0),
        Location:new(world, 30072.0, 82.0, 30002.0),
        Location:new(world, 30072.0, 82.0, 30003.0),
        Location:new(world, 30072.0, 82.0, 30004.0),
        Location:new(world, 30072.0, 82.0, 30005.0),
        Location:new(world, 30073.0, 82.0, 30001.0),
        Location:new(world, 30073.0, 82.0, 30002.0),
        Location:new(world, 30073.0, 82.0, 30003.0),
        Location:new(world, 30073.0, 82.0, 30004.0),
        Location:new(world, 30073.0, 82.0, 30005.0),
        Location:new(world, 30074.0, 82.0, 30002.0),
        Location:new(world, 30074.0, 82.0, 30003.0),
        Location:new(world, 30074.0, 82.0, 30004.0),
};

function hol_enter1(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setCarpet1();
end

function hol_setCarpet1()
	for index, key in ipairs(blocks) do
		key:setBlock(171, current);
	end
end

registerHook("REGION_ENTER", "hol_enter1", "spawn-hol_enter1");

local world = "spawn";
local current = 1;
local maxData = 14;
local blocks = {
	Location:new(world, 30065.0, 81.0, 29998.0),
};

function hol_exstaffenter(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setexstaff();
end

function hol_setexstaff()
	for index, key in ipairs(blocks) do
		key:setBlock(0, current);
	end
end

registerHook("REGION_ENTER", "hol_exstaffenter", "spawn-hol_ex_1");

local world = "spawn";
local current = 15;
local maxData = 1;
local blocks = {
	Location:new(world, 30065.0, 81.0, 29998.0),
};

function hol_exstaffenter1(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setexstaff1();
end

function hol_setexstaff1()
	for index, key in ipairs(blocks) do
		key:setBlock(35, current);
	end
end

registerHook("REGION_ENTER", "hol_exstaffenter1", "spawn-hol_ex_2");
