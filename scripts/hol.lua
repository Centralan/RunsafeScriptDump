local world = "spawn";
local current = 1;
local maxData = 14;
local blocks = {
	Location:new(world, 30068.0, 82.0, 30003.0),
        Location:new(world, 30069.0, 82.0, 30002.0),
        Location:new(world, 30069.0, 82.0, 30003.0),
        Location:new(world, 30069.0, 82.0, 30004.0),
        Location:new(world, 30070.0, 82.0, 30001.0),
        Location:new(world, 30070.0, 82.0, 30002.0),
        Location:new(world, 30070.0, 82.0, 30003.0),
        Location:new(world, 30070.0, 82.0, 30004.0),
        Location:new(world, 30070.0, 82.0, 30005.0),
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
        Location:new(world, 30074.0, 82.0, 30001.0),
        Location:new(world, 30074.0, 82.0, 30002.0),
        Location:new(world, 30074.0, 82.0, 30003.0),
        Location:new(world, 30074.0, 82.0, 30004.0),
        Location:new(world, 30074.0, 82.0, 30005.0),
        Location:new(world, 30075.0, 82.0, 30001.0),
        Location:new(world, 30075.0, 82.0, 30002.0),
        Location:new(world, 30075.0, 82.0, 30003.0),
        Location:new(world, 30075.0, 82.0, 30004.0),
        Location:new(world, 30075.0, 82.0, 30005.0),
        Location:new(world, 30076.0, 82.0, 30002.0),
        Location:new(world, 30076.0, 82.0, 30003.0),
        Location:new(world, 30076.0, 82.0, 30004.0),
        Location:new(world, 30077.0, 82.0, 30003.0),
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

registerHook("REGION_ENTER", "hol_enter1", "spawn-hol_enter_1");


local world = World:new('spawn');
local current = 1;
local maxData = 14;
local blocks = {
        Location:new(world, 30067.0, 82.0, 30002.0),
        Location:new(world, 30067.0, 82.0, 30003.0),
        Location:new(world, 30067.0, 82.0, 30004.0),
        Location:new(world, 30068.0, 82.0, 30001.0),
        Location:new(world, 30068.0, 82.0, 30002.0),
        Location:new(world, 30068.0, 82.0, 30004.0),
        Location:new(world, 30068.0, 82.0, 30005.0),
        Location:new(world, 30069.0, 82.0, 30000.0),
        Location:new(world, 30069.0, 82.0, 30001.0),
        Location:new(world, 30069.0, 82.0, 30005.0),
        Location:new(world, 30069.0, 82.0, 30006.0),
        Location:new(world, 30070.0, 82.0, 30000.0),
        Location:new(world, 30070.0, 82.0, 30006.0),
        Location:new(world, 30071.0, 82.0, 30000.0),
        Location:new(world, 30071.0, 82.0, 30006.0),
        Location:new(world, 30072.0, 82.0, 30000.0),
        Location:new(world, 30072.0, 82.0, 30006.0),
        Location:new(world, 30073.0, 82.0, 30000.0),
        Location:new(world, 30073.0, 82.0, 30006.0),
        Location:new(world, 30074.0, 82.0, 30000.0),
        Location:new(world, 30074.0, 82.0, 30006.0),
        Location:new(world, 30075.0, 82.0, 30000.0),
        Location:new(world, 30075.0, 82.0, 30006.0),
        Location:new(world, 30076.0, 82.0, 30000.0),
        Location:new(world, 30076.0, 82.0, 30001.0),
        Location:new(world, 30076.0, 82.0, 30005.0),
        Location:new(world, 30076.0, 82.0, 30006.0),
        Location:new(world, 30077.0, 82.0, 30001.0),
        Location:new(world, 30077.0, 82.0, 30002.0),
        Location:new(world, 30077.0, 82.0, 30004.0),
        Location:new(world, 30077.0, 82.0, 30005.0),
        Location:new(world, 30078.0, 82.0, 30002.0),
        Location:new(world, 30078.0, 82.0, 30003.0),
        Location:new(world, 30078.0, 82.0, 30004.0),
};

function hol_enter2(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setCarpet2();
end

function hol_setCarpet2()
	for index, key in ipairs(blocks) do
		key:setBlock(171, current);
	end
end

registerHook("INTERACT", "hol_enter2", 77, world.name, 30064, 88, 30003);

local world = World:new('spawn');
local current = 1;
local maxData = 15;
local blocks = {
        Location:new(world, 30065.0, 81.0, 29998.0),
        Location:new(world, 30065.0, 81.0, 29999.0),
        Location:new(world, 30065.0, 81.0, 30000.0),
        Location:new(world, 30065.0, 81.0, 30001.0),
        Location:new(world, 30065.0, 81.0, 30002.0),
        Location:new(world, 30065.0, 81.0, 30003.0),
        Location:new(world, 30065.0, 81.0, 30004.0),
        Location:new(world, 30065.0, 81.0, 30005.0),
        Location:new(world, 30065.0, 81.0, 30006.0),
        Location:new(world, 30065.0, 81.0, 30007.0),
        Location:new(world, 30065.0, 81.0, 30008.0),
        Location:new(world, 30066.0, 81.0, 29998.0),
        Location:new(world, 30066.0, 81.0, 29999.0),
        Location:new(world, 30066.0, 81.0, 30000.0),
        Location:new(world, 30066.0, 81.0, 30001.0),
        Location:new(world, 30066.0, 81.0, 30002.0),
        Location:new(world, 30066.0, 81.0, 30003.0),
        Location:new(world, 30066.0, 81.0, 30004.0),
        Location:new(world, 30066.0, 81.0, 30005.0),
        Location:new(world, 30066.0, 81.0, 30006.0),
        Location:new(world, 30066.0, 81.0, 30007.0),
        Location:new(world, 30066.0, 81.0, 30008.0),
        Location:new(world, 30067.0, 81.0, 30005.0),
        Location:new(world, 30067.0, 81.0, 30006.0),
        Location:new(world, 30067.0, 81.0, 30007.0),
        Location:new(world, 30067.0, 81.0, 30008.0),
        Location:new(world, 30067.0, 81.0, 29998.0),
        Location:new(world, 30067.0, 81.0, 29999.0),
        Location:new(world, 30067.0, 81.0, 30000.0),
        Location:new(world, 30067.0, 81.0, 30001.0),
        Location:new(world, 30068.0, 81.0, 30006.0),
        Location:new(world, 30068.0, 81.0, 30007.0),
        Location:new(world, 30068.0, 81.0, 30008.0),
        Location:new(world, 30068.0, 81.0, 29998.0),
        Location:new(world, 30068.0, 81.0, 29999.0),
        Location:new(world, 30068.0, 81.0, 30000.0),
        Location:new(world, 30069.0, 81.0, 29998.0),
        Location:new(world, 30069.0, 81.0, 29999.0),
        Location:new(world, 30070.0, 81.0, 29998.0),
        Location:new(world, 30070.0, 81.0, 29999.0),
        Location:new(world, 30071.0, 81.0, 29998.0),
        Location:new(world, 30071.0, 81.0, 29999.0),
        Location:new(world, 30072.0, 81.0, 29998.0),
        Location:new(world, 30072.0, 81.0, 29999.0),
        Location:new(world, 30073.0, 81.0, 29998.0),
        Location:new(world, 30073.0, 81.0, 29999.0),
        Location:new(world, 30074.0, 81.0, 29998.0),
        Location:new(world, 30074.0, 81.0, 29999.0),
        Location:new(world, 30075.0, 81.0, 29998.0),
        Location:new(world, 30075.0, 81.0, 29999.0),
        Location:new(world, 30076.0, 81.0, 29998.0),
        Location:new(world, 30076.0, 81.0, 29999.0),
        Location:new(world, 30069.0, 81.0, 30007.0),
        Location:new(world, 30069.0, 81.0, 30008.0),
        Location:new(world, 30070.0, 81.0, 30007.0),
        Location:new(world, 30070.0, 81.0, 30008.0),
        Location:new(world, 30071.0, 81.0, 30007.0),
        Location:new(world, 30071.0, 81.0, 30008.0),
        Location:new(world, 30072.0, 81.0, 30007.0),
        Location:new(world, 30072.0, 81.0, 30008.0),
        Location:new(world, 30073.0, 81.0, 30007.0),
        Location:new(world, 30073.0, 81.0, 30008.0),
        Location:new(world, 30074.0, 81.0, 30007.0),
        Location:new(world, 30074.0, 81.0, 30008.0),
        Location:new(world, 30075.0, 81.0, 30007.0),
        Location:new(world, 30075.0, 81.0, 30008.0),
        Location:new(world, 30076.0, 81.0, 30007.0),
        Location:new(world, 30076.0, 81.0, 30008.0),
        Location:new(world, 30077.0, 81.0, 29998.0),
        Location:new(world, 30077.0, 81.0, 29999.0),
        Location:new(world, 30077.0, 81.0, 30000.0),
        Location:new(world, 30077.0, 81.0, 30006.0),
        Location:new(world, 30077.0, 81.0, 30007.0),
        Location:new(world, 30077.0, 81.0, 30008.0),
        Location:new(world, 30078.0, 81.0, 29999.0),
        Location:new(world, 30078.0, 81.0, 30000.0),
        Location:new(world, 30078.0, 81.0, 30001.0),
        Location:new(world, 30078.0, 81.0, 30005.0),
        Location:new(world, 30078.0, 81.0, 30006.0),
        Location:new(world, 30078.0, 81.0, 30007.0),
        Location:new(world, 30079.0, 81.0, 30000.0),
        Location:new(world, 30079.0, 81.0, 30001.0),
        Location:new(world, 30079.0, 81.0, 30002.0),
        Location:new(world, 30079.0, 81.0, 30003.0),
        Location:new(world, 30079.0, 81.0, 30004.0),
        Location:new(world, 30079.0, 81.0, 30005.0),
        Location:new(world, 30079.0, 81.0, 30006.0),
};

function hol_floor(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setfloor();
end

function hol_setfloor()
	for index, key in ipairs(blocks) do
		key:setBlock(35, current);
	end
end

registerHook("INTERACT", "hol_floor", 77, world.name, 30082, 89, 30003);

local world = World:new('spawn');
local current = 1;
local maxData = 5;
local blocks = {
	Location:new(world, 30082.0, 85.0, 30002.0),
        Location:new(world, 30082.0, 85.0, 30003.0),
        Location:new(world, 30082.0, 85.0, 30004.0)
};

function hol_enter5(data)
	if current == maxData then
		current = 1;
	else
		current = current + 1;
	end
	hol_setCarpet5();
end

function hol_setCarpet5()
	for index, key in ipairs(blocks) do
		key:setBlock(126, current);
	end
end

registerHook("INTERACT", "hol_enter5", 77, world.name, 30082, 90, 30003);
