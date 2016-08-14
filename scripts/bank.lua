local bankWorld = World:new("spawn");

local bankEntry2Location = Location:new("spawn", 7, 14, -71);
bankEntry2Location:setYaw(0);
bankEntry2Location:setPitch(0);

local bankEntry1Location = Location:new("spawn", 398, 55, -816);
bankEntry1Location:setYaw(-180);
bankEntry1Location:setPitch(0);

function bankEntry1(data)
	local p = Player:new(data["player"]);
	p:teleport(bankEntry1Location);
end

function bankEntry2(data)
	local p = Player:new(data["player"]);
	p:teleport(bankEntry2Location);
end

-- AI
local bankGuardian = AI:new("VaultSec", "AI", "spawn");

-- VAULT ENTRY 1
local bank1_strikeLocation1 = Location:new("spawn", 403, 65, -900);
local bank1_strikeLocation2 = Location:new("spawn", 395, 65, -900);
function bank1_attempt(data)
	if bank1_checkCombo() then
		bank1_lightButtons();
	else
		if data["player"] ~= nil then
			bankGuardian:speak("Unauthorized access detected. Vaporizing target entity with fire.");
			local player = Player:new(data["player"]);
			bank1_strikeLocation1:lightningStrike();
			bank1_strikeLocation2:lightningStrike();
			player:kill();
		end
	end
end
registerHook("INTERACT", "bank1_attempt", 77, "spawn", 403, 66, -899);
registerHook("INTERACT", "bank1_attempt", 77, "spawn", 395, 66, -899);

local pressedButtons = {};

local bank1_buttonSourceLocations = {
	Location:new("spawn", 395, 66, -904),
	Location:new("spawn", 396, 66, -904),
	Location:new("spawn", 397, 66, -904),
	Location:new("spawn", 398, 66, -904),
	Location:new("spawn", 399, 66, -904),
	Location:new("spawn", 400, 66, -904),
	Location:new("spawn", 401, 66, -904),
	Location:new("spawn", 402, 66, -904),
	Location:new("spawn", 403, 66, -904)
};

function bank1_shiftButtons(newDigit)
	if newDigit ~= pressedButtons[1] then
		pressedButtons[4] = pressedButtons[3];
		pressedButtons[3] = pressedButtons[2];
		pressedButtons[2] = pressedButtons[1];
		pressedButtons[1] = newDigit;
	end
	bank1_lightButtons();
end

function bank1_lightButtons()
	local pButtons = {};
	if pressedButtons[1] ~= nil then pButtons[pressedButtons[1]] = true; end
	if pressedButtons[2] ~= nil then pButtons[pressedButtons[2]] = true; end
	if pressedButtons[3] ~= nil then pButtons[pressedButtons[3]] = true; end
	if pressedButtons[4] ~= nil then pButtons[pressedButtons[4]] = true; end
	
	for index, location in ipairs(bank1_buttonSourceLocations) do
		if pButtons[index] == true then
			location:setBlock(152, 0);
		else
			location:setBlock(0, 0);
		end
	end
end

function bank1_checkCombo()
	if pressedButtons[1] == 5 and pressedButtons[2] == 8 and pressedButtons[3] == 3 and pressedButtons[4] == 1 then
		pressedButtons = {};
		bank1_openGate();
		bankGuardian:speak("Input code correct. Level 1 clearance granted.");
		return true;
	end
	return false;
end

local bank1_gateTriggerBlock = Location:new("spawn", 396, 67, -908);
bank1_gateTriggerBlock:setBlock(0, 0); -- Reset incase we got stuck at some point.

local bank1_gateBlocks = {};
for x = 397, 401 do
	for z = -898, -896 do
		for y = 65, 67 do
			table.insert(bank1_gateBlocks, Location:new("spawn", x, y, z));
		end
	end
end

function bank1_setGate(blockID)
	for i = 1, #bank1_gateBlocks do
		bank1_gateBlocks[i]:setBlock(blockID, 0);
	end
end

function bank1_openGate()
	bank1_gateTriggerBlock:setBlock(152, 0);
	bank1_setGate(0);
end

function bank1_closeGate()
	bank1_gateTriggerBlock:setBlock(0, 0);
	bank1_setGate(101);
end
registerHook("BLOCK_GAINS_CURRENT", "bank1_closeGate", "spawn", 402, 67, -908);

function bank1_button1() bank1_shiftButtons(1); end
function bank1_button2() bank1_shiftButtons(2); end
function bank1_button3() bank1_shiftButtons(3); end
function bank1_button4() bank1_shiftButtons(4); end
function bank1_button5() bank1_shiftButtons(5); end
function bank1_button6() bank1_shiftButtons(6); end
function bank1_button7() bank1_shiftButtons(7); end
function bank1_button8() bank1_shiftButtons(8); end
function bank1_button9() bank1_shiftButtons(9); end

local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Space'};
local bank2_input = {};
local bank2_answer = {'X', 'U', 'O', 'R', 'Space', 'A', 'L'};
local bank2_strikeLocation = Location:new("spawn", 399, 62, -881);
local bank2_complete_location = Location:new("spawn", 399, 55, -878);

function bank2_shiftButtons(data, current)
	if #bank2_input == 10 then
		bank2_reset();
		local player = Player:new(data["player"]);
		bankGuardian:speak("Input exceeded limit. Exterminating intruder. Input reset.");
		player:kill();
		bank2_strikeLocation:lightningStrike();
	else
		local newInput = {};
		newInput[1] = current;
		for index, key in ipairs(bank2_input) do
			newInput[index + 1] = key;
		end
		bank2_input = newInput;
		bank2_checkInput(data);
	end
end

function bank2_reset()
	local input = '';
	for index, key in ipairs(bank2_input) do
		if key == 'Space' then
			key = ' ';
		end
		input = key .. input;
	end
	print('Bank input attempt: ' .. input);
	bank2_input = {};
end

function bank2_checkInput(data)
	local player = Player:new(data["player"]);
	if bank2_checkInput_2() then
		player:teleport(bank2_complete_location);
		bankGuardian:speak("Correct input code entered. Access to level 2 granted.");
		bank2_reset();
	end
end

function bank2_checkInput_2()	
	if #bank2_input ~= #bank2_answer then
		return false;
	end
	
	for index, key in ipairs(bank2_input) do
		if bank2_answer[index] ~= key then
			return false;
		end
	end
	return true;
end

function bank2_buttonA(data) bank2_shiftButtons(data, 'A'); end
function bank2_buttonB(data) bank2_shiftButtons(data, 'B'); end
function bank2_buttonC(data) bank2_shiftButtons(data, 'C'); end
function bank2_buttonD(data) bank2_shiftButtons(data, 'D'); end
function bank2_buttonE(data) bank2_shiftButtons(data, 'E'); end
function bank2_buttonF(data) bank2_shiftButtons(data, 'F'); end
function bank2_buttonG(data) bank2_shiftButtons(data, 'G'); end
function bank2_buttonH(data) bank2_shiftButtons(data, 'H'); end
function bank2_buttonI(data) bank2_shiftButtons(data, 'I'); end
function bank2_buttonJ(data) bank2_shiftButtons(data, 'J'); end
function bank2_buttonK(data) bank2_shiftButtons(data, 'K'); end
function bank2_buttonL(data) bank2_shiftButtons(data, 'L'); end
function bank2_buttonM(data) bank2_shiftButtons(data, 'M'); end
function bank2_buttonN(data) bank2_shiftButtons(data, 'N'); end
function bank2_buttonO(data) bank2_shiftButtons(data, 'O'); end
function bank2_buttonP(data) bank2_shiftButtons(data, 'P'); end
function bank2_buttonQ(data) bank2_shiftButtons(data, 'Q'); end
function bank2_buttonR(data) bank2_shiftButtons(data, 'R'); end
function bank2_buttonS(data) bank2_shiftButtons(data, 'S'); end
function bank2_buttonT(data) bank2_shiftButtons(data, 'T'); end
function bank2_buttonU(data) bank2_shiftButtons(data, 'U'); end
function bank2_buttonV(data) bank2_shiftButtons(data, 'V'); end
function bank2_buttonW(data) bank2_shiftButtons(data, 'W'); end
function bank2_buttonX(data) bank2_shiftButtons(data, 'X'); end
function bank2_buttonY(data) bank2_shiftButtons(data, 'Y'); end
function bank2_buttonZ(data) bank2_shiftButtons(data, 'Z'); end
function bank2_buttonSpace(data) bank2_shiftButtons(data, 'Space'); end

for i = 1, #alphabet do
	registerHook("INTERACT", "bank2_button" .. alphabet[i], 77, "spawn", 413 - i, 63, -879);
end

registerHook("INTERACT", "bank2_reset", 77, "spawn", 412, 63, -880);
registerHook("INTERACT", "bank2_reset", 77, "spawn", 386, 63, -881);

registerHook("REGION_ENTER", "bankEntry1", "spawn-bank1");
registerHook("REGION_ENTER", "bankEntry2", "spawn-bank2");

for index, location in ipairs(bank1_buttonSourceLocations) do
	registerHook("INTERACT", "bank1_button" .. index, 77, "spawn", location.x, 65, -902);
end
