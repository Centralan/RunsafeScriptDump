local puzzleLocation = Location:new("puzzle", 1078, 63, 906);
local puzzleStartTexts = {
	"Stop.. stop while you still can. Leave.. LEAVE...",
	"You can't go on.. your sanity will not survive.. turn back now!",
	"What .. w-what are you doing? STOP! TURN BACK NOW! YOU HAVE YOUR LIFE AHEAD OF YOU!",
	"NO! STOP!! ARRGGHHHH!",
	"I .. I am sorry, I cannot let you go through.. it is for your own good.."
};
local varonia = AI:new("Varonia", "AI", "puzzle");

puzzleStartPlayers = {};

function startPuzzle(data)
	local player = Player:new(data["player"]);
	player:teleport(puzzleLocation);
end

function puzzleStartPlayerHasTriggered(part, player)
	local playerData = puzzleStartPlayers[player:getName()] or {};
	return playerData[part] ~= nil;
end

function puzzleStartRegisterTrigger(part, player)
	local playerData = puzzleStartPlayers[player:getName()] or {};
	playerData[part] = true;
	puzzleStartPlayers[player:getName()] = playerData;
end

function puzzleStartText(part, player)
	if not puzzleStartPlayerHasTriggered(part, player) then
		player:sendMessage("&7&o" .. puzzleStartTexts[part]);
		puzzleStartRegisterTrigger(part, player);
	end
end

function puzzleEntry1(data)
	puzzleStartText(1, Player:new(data["player"]));
end

function puzzleEntry2(data)
	puzzleStartText(2, Player:new(data["player"]));
end

function puzzleEntry3(data)
	puzzleStartText(3, Player:new(data["player"]));
end

function puzzleEntry4(data)
	puzzleStartText(4, Player:new(data["player"]));
end

function puzzleEntry5(data)
	puzzleStartText(5, Player:new(data["player"]));
end

function puzzleAI()
	varonia:speak("The Puzzle begins in 1 hour. Make use of your sanity whilst it lasts.");
end

--registerHook("INTERACT", "startPuzzle", 70, "spawn", 62, 2, 104);
registerHook("REGION_ENTER", "startPuzzle", "spawn-puzzleentry");
registerHook("REGION_ENTER", "puzzleEntry1", "spawn-puzz_e_1");
registerHook("REGION_ENTER", "puzzleEntry2", "spawn-puzz_e_2");
registerHook("REGION_ENTER", "puzzleEntry3", "spawn-puzz_e_3");
registerHook("REGION_ENTER", "puzzleEntry4", "spawn-puzzle_e_4");
registerHook("REGION_ENTER", "puzzleEntry5", "spawn-puzz_e_5");

registerHook("INTERACT", "puzzleAI", 69, "puzzle", 1128, 244, 911);

function puzzleGateOpenBlock(location)
	location.setBlock(0, 0);
	location.explosion(4, false, false);
end

function puzzleGateOpen()
	puzzleGateOpenBlock(Location:new("spawn", 11, 28, 74));
	puzzleGateOpenBlock(Location:new("spawn", 10, 28, 74));
	puzzleGateOpenBlock(Location:new("spawn", 12, 27, 74));
	puzzleGateOpenBlock(Location:new("spawn", 13, 26, 74));
	puzzleGateOpenBlock(Location:new("spawn", 9, 26, 74));
	puzzleGateOpenBlock(Location:new("spawn", 8, 26, 74));
	puzzleGateOpenBlock(Location:new("spawn", 12, 25, 74));
	puzzleGateOpenBlock(Location:new("spawn", 10, 25, 74));
	puzzleGateOpenBlock(Location:new("spawn", 13, 24, 74));
	puzzleGateOpenBlock(Location:new("spawn", 9, 24, 74));
	puzzleGateOpenBlock(Location:new("spawn", 8, 24, 74));
	puzzleGateOpenBlock(Location:new("spawn", 13, 23, 74));
	puzzleGateOpenBlock(Location:new("spawn", 12, 23, 74));
	puzzleGateOpenBlock(Location:new("spawn", 11, 23, 74));
	puzzleGateOpenBlock(Location:new("spawn", 10, 23, 74));
	puzzleGateOpenBlock(Location:new("spawn", 9, 22, 74));
	puzzleGateOpenBlock(Location:new("spawn", 8, 23, 73));
	puzzleGateOpenBlock(Location:new("spawn", 10, 27, 73));
	puzzleGateOpenBlock(Location:new("spawn", 11, 24, 73));
end

registerHook("INTERACT", "puzzleGateOpen", 69, "spawn", 9, 25, 58);