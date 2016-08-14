local world = World:new('code4');

function GreenTeamScore()
	local chance = 8;
	for x = 909, 970 do
		for z = 956, 1100 do
			if math.random(1, 100) < chance then
				engine.effects.firework('puzzle', x, 64, z, 'BALL_LARGE', 14, 12, true, true, math.random(0,4));
			end
		end
	end

registerHook("INTERACT", "GreenTeamScore", 70, "code4", 990, 86, 991);