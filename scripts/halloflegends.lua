function setStairBlock(x, y, z, type, data)
   engine.world.setBlock('spawn', x, y, z, type, data);
end

function updateStairStrip(x, y, z, type, data)
   setStairBlock(x + 1, y, z, type, data);
   setStairBlock(x, y, z, type, data);
   setStairBlock(x - 1, y, z, type, data);
end

function updateStairs()
	local blockID = engine.world.getBlock('spawn', 61, 16, -15);
if blockID == 155 then
   -- Open stairs
   updateStairStrip(61, 16, -15, 44, 7);
   updateStairStrip(61, 16, -14, 0, 0);
   updateStairStrip(61, 16, -13, 0, 0);
   updateStairStrip(61, 16, -12, 0, 0);
   updateStairStrip(61, 16, -11, 0, 0);
   updateStairStrip(61, 16, -10, 0, 0);
   updateStairStrip(61, 16, -9, 0, 0);
else
   -- Close stairs
   updateStairStrip(61, 16, -15, 155, 0);
   updateStairStrip(61, 16, -14, 155, 0);
   updateStairStrip(61, 16, -13, 155, 0);
   updateStairStrip(61, 16, -12, 155, 0);
   updateStairStrip(61, 16, -11, 155, 0);
   updateStairStrip(61, 16, -10, 155, 0);
   updateStairStrip(61, 16, -9, 155, 0);
end
end

registerHook("INTERACT", "updateStairs", 77, 'spawn', 61, 20, -5);
registerHook("INTERACT", "updateStairs", 77, 'spawn', 62, 13, -6);
