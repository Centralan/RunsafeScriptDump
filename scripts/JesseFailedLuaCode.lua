function hol_song(location, songFile, volume)
    local loc = Location:new('spawn', 30060, 83, 30003);
    local song = Song:initialize(loc, 'Take Back The Night - CaptainSparklez.nbs', 5);
end


registerHook("REGION_ENTER", "hol_song", "spawn-hol_doorway");


function flint_boardpass_take(itemName)
    return EventEngine.player.hasItemWithName(self.name, Captain Flint's Boarding Pass);
end

registerHook("INTERACT", "flint_boardpass_take", 77, world.name, 27996, 65, 27955);
