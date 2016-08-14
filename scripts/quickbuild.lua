-----------------------
---- CONFIGURATION ----
-----------------------

-- The world which the game takes place in.
local gameWorld = World:new('quickbuild');

-- This is how long each game lasts in intervals of 30 seconds. So, 10 = 5 minutes.
local gameTime = 10;

-- This is the location players will get teleported to inside the lobby.
local lobbyTeleportLocation = Location:new(gameWorld, 2, 68, -1928);

-- This is the location players will get teleported to when it's their turn.
local gameFieldTeleportLocation = Location:new(gameWorld, 2, 62, -1902);

-- The boundaries of the lobby.
local lobbyPosition = {
	minX = -22,
	minY = 68,
	minX = -1930,
	maxX = 26,
	maxY = 77,
	maxZ = -1878
};

-- The boundaries of the game world.
local gameFieldPosition = {
	minX = -12,
	minY = 60,
	minZ = -1916,
	maxX = 16,
	maxY = 67,
	maxZ = -1888
};

-----------------------
------ GAME CODE ------
-----------------------

-- This timer ticks every 30 seconds and handles most of our stuff.
local mainTimer = Timer:new("gameCheck", 30 * 20);

-- Pointer for the current player in the game field.
local currentPlayer = nil;

-- Boolean to define if the game is currently running or not.
local gameRunning = false;

-- The player who did the last match.
local lastPlayer = nil;

-- This is how long the current match has been running. Automatically handled.
local gameRuntime = 0;

-- Checks if the given X, Y, Z are within the supplied bounds array.
-- All bounds arrays need minX, minY, minZ, maxX, maxY, maxZ defined.
function isWithinBounds(x, y, z, bounds)
	return x >= bounds.minX and y >= bounds.minY and z >= bounds.minZ and x <= bounds.maxX and y <= bounds.maxY and z <= bounds.maxZ;
end

-- Calling this function will end the current game.
function endGame()
	gameRunning = false; -- Set the game state as not running.
	
	-- Check if the player who was in this match is online and valid.
	if currentPlayer ~= nil and currentPlayer:isOnline() then
		local worldName, x, y, z = currentPlayer:getLocation();
		
		-- Check if the player is still inside the field, no need to teleport them otherwise.
		if worldName == gameWorld.name and isWithinBounds(x, y, z, gameFieldPosition) then
			-- Teleport the player to the lobby.
			currentPlayer:teleport(lobbyTeleportLocation);
		end
	end
	
	currentPlayer = nil; -- Invalidate the current player pointer.
end

-- Calling this function will start a new game with the given player.
function startGame(player)
	-- Set the game state as running.
	gameRunning = true;
	
	-- Set the current player as the one given.
	currentPlayer = player;
	
	-- Reset the game time.
	gameRuntime = 0;
	
	-- Set this player as the last player.
	lastPlayer = player.name;
	
	-- Teleport the player into the game field.
	currentPlayer:teleport(gameFieldTeleportLocation);
end

-- This is called every 30 seconds by mainTimer.
function gameCheck()
	-- Check if a game is currently running.
	if gameRunning then
		-- A game is currently running.
		if currentPlayer ~= nil and currentPlayer:isOnline() then
			-- The player is still in the field.
			
			-- Increment how long this game has been running.
			gameRuntime = gameRuntime + 1;
			
			-- Check if the time for this match has run-out.
			if gameRuntime == gameTime then
				-- Out of time, ending the game.
				endGame();
			end
		else
			-- The player has left or disconnected so we end the game.
			endGame();
		end
	else
		-- Game is not running, let's check the lobby.
		
		-- Get all players within the world.
		local worldPlayers = {myWorld:getPlayers()};
		
		-- Empty array for lobby players.
		local lobbyPlayers = {};
		
		-- Loop every player in the world.
		for index, playerName in pairs(worldPlayers) do
			local player = Player:new(playerName); -- Player pointer.
			local _, x, y, z = player:getLocation(); -- Location of the player.
			
			-- Check if this specific player is inside the lobby.
			-- We also ignore the player who had the last turn to prevent two games in a row for one player.
			if (lastPlayer == nil or playerName ~= lastPlayer) or isWithinBounds(x, y, z, lobbyPosition) then
				-- Player is in the lobby, add them to the lobby array.
				table.insert(lobbyPlayers, player);
			end
		end
		
		-- Check if we have two or more players in the lobby.
		if #lobbyPlayers >= 2 then
			-- We have two or more players in the lobby.
			
			-- Select a random player from the lobby.
			local randomPlayer = lobbyPlayers[math.random(1, #lobbyPlayers)];
			
			-- Start the game.
			startGame(randomPlayer);
		end
	end
end

-- Start out main timer.
mainTimer:startRepeating();

-----------------------
------ Effects ------
-----------------------


local qbtestEffectLocations = {
	Location:new(gameWorld, 6.0, 69.0, -1927.0),
	Location:new(gameWorld, 6.0, 69.0, -1928.0),
	Location:new(gameWorld, 3.0, 69.0, -1930.0),
	Location:new(gameWorld, 2.0, 69.0, -1930.0),
	Location:new(gameWorld, -1.0, 69.0, -1928.0),
	Location:new(gameWorld, -1.0, 69.0, -1927.0)
};

function qb_test()
	for key, value in pairs(qbtestEffectLocations) do
		value:playEffect('SPLASH', 40, 200, 5);
	end
end

registerHook("BLOCK_GAINS_CURRENT", "qb_test", "quickbuild", -1, 62, -1923);
