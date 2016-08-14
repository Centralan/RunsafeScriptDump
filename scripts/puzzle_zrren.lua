local players = {};

function zrren(data)
	local playerName = data["player"];
	if players[playerName] == nil then
		local z = AI:new("Zrren", "AI", "puzzle");
		z:speak(".. w-what .. " .. playerName .. "? What are you doing here! LEAVE THIS PLACE! I must .. I must figure this out.. GET OUT! GET OUT!");
		players[playerName] = true;
	end
end

registerHook("REGION_ENTER", "zrren", "puzzle-zrren");