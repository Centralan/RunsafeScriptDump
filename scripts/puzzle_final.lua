function puzzleFinal(data)
	local playerName = data["player"];
	local kru = Player:new("Kruithne");
	kru:sendMessage("&c" .. playerName .. " has entered the final stretch");
end

--registerHook("REGION_ENTER", "puzzleFinal", "puzzle-puzzfinal");