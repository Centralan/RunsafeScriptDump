---------------------
--- CONFIGURATION ---
---------------------

-- Library used for serializing data.
local PATH = "plugins/EventEngine/scripts/";
local serialize = dofile(PATH .. "Ser.lua");

-- Which file we persist/load balance data from.
local balanceFile = "shop.data";

-- This is the world the shop is located in.
local world = World:new('com');

-- This table will contain all of the player balances, do not manually edit.
local playerBalances = {};

-- Shopping spree tracking.
local spree = {};

-- Data for all of the shops that exist.
-- The location is the sign. A stone button is expected above the sign.
-- A wooden button is expected below the sign.
local shops = {
	{["Location"] = Location:new(world.name, -107, 73, 182), ["Name"] = "Packed Ice", ["Item"] = "packedice", ["Amount"] = 64, ["Cost"] = 4},
	{["Location"] = Location:new(world.name, -108, 73, 182), ["Name"] = "Cobblestone", ["Item"] = "cobblestone", ["Amount"] = 320, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -109, 73, 182), ["Name"] = "Quartz", ["Item"] = "155.0", ["Amount"] = 64, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -110, 73, 182), ["Name"] = "Quartz (CH)", ["Item"] = "155.1", ["Amount"] = 64, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -111, 73, 182), ["Name"] = "Quartz (P)", ["Item"] = "155.2", ["Amount"] = 64, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -112, 73, 182), ["Name"] = "Endstone", ["Item"] = "121.0", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -113, 73, 182), ["Name"] = "Gravel", ["Item"] = "gravel", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -106, 73, 178), ["Name"] = "Hay Bale", ["Item"] = "170", ["Amount"] = 16, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -104, 73, 178), ["Name"] = "Snow Block", ["Item"] = "80", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -102, 73, 178), ["Name"] = "Red Sand", ["Item"] = "12.1", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 73, 179), ["Name"] = "Sandstone (SM)", ["Item"] = "24.2", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 73, 181), ["Name"] = "Sandstone (CH)", ["Item"] = "24.1", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 73, 183), ["Name"] = "Sandstone", ["Item"] = "24", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 73, 185), ["Name"] = "Sand", ["Item"] = "sand", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 73, 189), ["Name"] = "Acacia Wood", ["Item"] = "162.0", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -101, 73, 191), ["Name"] = "Jungle Wood", ["Item"] = "17.3", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -101, 73, 193), ["Name"] = "Birch Wood", ["Item"] = "17.2", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -101, 73, 195), ["Name"] = "Dark Oak Wood", ["Item"] = "162.1", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -102, 73, 196), ["Name"] = "Spruce Wood", ["Item"] = "17.1", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -104, 73, 196), ["Name"] = "Oak Wood", ["Item"] = "17.0", ["Amount"] = 64, ["Cost"] = 1.5},
	{["Location"] = Location:new(world.name, -106, 73, 196), ["Name"] = "Dark Oak Wood Planks", ["Item"] = "5.5", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -108, 73, 196), ["Name"] = "Acacia Wood Planks", ["Item"] = "5.4", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -110, 73, 196), ["Name"] = "Bookshelf", ["Item"] = "47.0", ["Amount"] = 16, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -112, 73, 196), ["Name"] = "Jungle Wood Planks", ["Item"] = "5.3", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -114, 73, 196), ["Name"] = "Birch Wood Planks", ["Item"] = "5.2", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -116, 73, 196), ["Name"] = "Spruce Wood Planks", ["Item"] = "5.1", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -118, 73, 196), ["Name"] = "Oak Wood Planks", ["Item"] = "5.0", ["Amount"] = 256, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 73, 195), ["Name"] = "Podzol", ["Item"] = "3.2", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -119, 73, 193), ["Name"] = "Dirt", ["Item"] = "3.0", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 73, 191), ["Name"] = "Grass Block", ["Item"] = "2.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 73, 183), ["Name"] = "Mycelium", ["Item"] = "110.0", ["Amount"] = 64, ["Cost"] = 7 },
	{["Location"] = Location:new(world.name, -119, 73, 181), ["Name"] = "Stone", ["Item"] = "1.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 73, 179), ["Name"] = "Nether Brick", ["Item"] = "112.0", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -118, 73, 178), ["Name"] = "Glowstone", ["Item"] = "89.0", ["Amount"] = 64, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -116, 73, 178), ["Name"] = "Netherrack", ["Item"] = "87.0", ["Amount"] = 576, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -114, 73, 178), ["Name"] = "Soul Sand", ["Item"] = "88.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 181), ["Name"] = "Black Wool", ["Item"] = "35.15", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 182), ["Name"] = "Red Wool", ["Item"] = "35.14", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 183), ["Name"] = "Green Wool", ["Item"] = "35.13", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 184), ["Name"] = "Brown Wool", ["Item"] = "35.12", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 185), ["Name"] = "Blue Wool", ["Item"] = "35.11", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 186), ["Name"] = "Purple Wool", ["Item"] = "35.10", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 187), ["Name"] = "Cyan Wool", ["Item"] = "35.9", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 188), ["Name"] = "Light Gray Wool", ["Item"] = "35.8", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 189), ["Name"] = "Gray Wool", ["Item"] = "35.7", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 190), ["Name"] = "Pink Woo", ["Item"] = "35.6", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 191), ["Name"] = "Lime Wool", ["Item"] = "35.5", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 192), ["Name"] = "Yellow Wool", ["Item"] = "35.4", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 193), ["Name"] = "Light Blue Wool", ["Item"] = "35.3", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 194), ["Name"] = "Magenta Wool", ["Item"] = "35.2", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 195), ["Name"] = "Orange Wool", ["Item"] = "35.1", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -101, 78, 196), ["Name"] = "Wool", ["Item"] = "35.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -102, 78, 197), ["Name"] = "White Stained Glass", ["Item"] = "95.0", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -103, 78, 197), ["Name"] = "Orange  Stained Glass", ["Item"] = "95.1", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -104, 78, 197), ["Name"] = "Magenta Stained Glass", ["Item"] = "95.2", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -105, 78, 197), ["Name"] = "Light Blue Stained Glass", ["Item"] = "95.3", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -106, 78, 197), ["Name"] = "Yellow Stained Glass", ["Item"] = "95.4", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -107, 78, 197), ["Name"] = "Lime Stained Glass", ["Item"] = "95.5", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -108, 78, 197), ["Name"] = "Pink Stained Glass", ["Item"] = "95.6", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -109, 78, 197), ["Name"] = "Gray Stained Glass", ["Item"] = "95.7", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -110, 78, 197), ["Name"] = "Glass", ["Item"] = "20.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -111, 78, 197), ["Name"] = "Cyan Stained Glass", ["Item"] = "95.9", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -112, 78, 197), ["Name"] = "Purple Stained Glass", ["Item"] = "95.10", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -113, 78, 197), ["Name"] = "Blue Stained Glass", ["Item"] = "95.11", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -114, 78, 197), ["Name"] = "Brown Stained Glass", ["Item"] = "95.12", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -115, 78, 197), ["Name"] = "Green Stained Glass", ["Item"] = "95.13", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -116, 78, 197), ["Name"] = "Red Stained Glass", ["Item"] = "95.14", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -117, 78, 197), ["Name"] = "Black Stained Glass", ["Item"] = "95.15", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -118, 78, 197), ["Name"] = "Light Gray  Stained Glass", ["Item"] = "95.8", ["Amount"] = 64, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -119, 78, 196), ["Name"] = "White Stained Clay", ["Item"] = "159.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 195), ["Name"] = "Orange Stained Clay", ["Item"] = "159.1", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 194), ["Name"] = "Magenta Stained Clay", ["Item"] = "159.2", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 193), ["Name"] = "Light Blue Stained Clay", ["Item"] = "159.3", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 192), ["Name"] = "Yellow Stained Clay", ["Item"] = "159.4", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 191), ["Name"] = "Lime Stained Clay", ["Item"] = "159.5", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 190), ["Name"] = "Pink Stained Clay", ["Item"] = "159.6", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 189), ["Name"] = "Gray Stained Clay", ["Item"] = "159.7", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 188), ["Name"] = "Light Gray Stained Clay", ["Item"] = "159.8", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 187), ["Name"] = "Cyan Stained Clay", ["Item"] = "159.9", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 186), ["Name"] = "Purple Stained Clay", ["Item"] = "159.10", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 185), ["Name"] = "Blue Stained Clay", ["Item"] = "159.11", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 184), ["Name"] = "Brown Stained Clay", ["Item"] = "159.12", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 183), ["Name"] = "Green Stained Clay", ["Item"] = "159.13", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 182), ["Name"] = "Red Stained Clay", ["Item"] = "159.14", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 181), ["Name"] = "Black Stained Clay", ["Item"] = "159.15", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 78, 180), ["Name"] = "Hardened Clay", ["Item"] = "172.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -111, 78, 178), ["Name"] = "Sticky Piston", ["Item"] = "29.0", ["Amount"] = 8, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -109, 78, 178), ["Name"] = "Piston", ["Item"] = "33.0", ["Amount"] = 8, ["Cost"] = 4},
	{["Location"] = Location:new(world.name, -105, 78, 178), ["Name"] = "Hopper", ["Item"] = "154.0", ["Amount"] = 8, ["Cost"] = 6},
	{["Location"] = Location:new(world.name, -107, 78, 182), ["Name"] = "Stone Bricks", ["Item"] = "98.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -109, 78, 182), ["Name"] = "Mossy Stone Bricks", ["Item"] = "98.1", ["Amount"] = 32, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -111, 78, 182), ["Name"] = "Cracked Stone Bricks", ["Item"] = "98.2", ["Amount"] = 32, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -113, 78, 182), ["Name"] = "Chiseled Stone Bricks", ["Item"] = "98.3", ["Amount"] = 32, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 196), ["Name"] = "Apple", ["Item"] = "260.0", ["Amount"] = 32, ["Cost"] = 4.5},
	{["Location"] = Location:new(world.name, -103, 83, 196), ["Name"] = "Carrot", ["Item"] = "391.0", ["Amount"] = 64, ["Cost"] = 2.5},
	{["Location"] = Location:new(world.name, -105, 83, 196), ["Name"] = "Potato", ["Item"] = "392.0", ["Amount"] = 64, ["Cost"] = 2.5},
	{["Location"] = Location:new(world.name, -107, 83, 196), ["Name"] = "Wheat", ["Item"] = "296.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -109, 83, 196), ["Name"] = "Cocoa Beans", ["Item"] = "351.3", ["Amount"] = 128, ["Cost"] = 2.5 },
	{["Location"] = Location:new(world.name, -111, 83, 196), ["Name"] = "Sugar Canes", ["Item"] = "338.0", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -113, 83, 196), ["Name"] = "Melon", ["Item"] = "360.0", ["Amount"] = 64, ["Cost"] = 0.5},
	{["Location"] = Location:new(world.name, -115, 83, 196), ["Name"] = "Pumpkin", ["Item"] = "86.0", ["Amount"] = 32, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -117, 83, 196), ["Name"] = "Seeds", ["Item"] = "295.0", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -118, 83, 196), ["Name"] = "Melon Seeds", ["Item"] = "362.0", ["Amount"] = 64, ["Cost"] = 0.5},
	{["Location"] = Location:new(world.name, -119, 83, 196), ["Name"] = "Pumpkin Seeds", ["Item"] = "361.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 191), ["Name"] = "Feather", ["Item"] = "288.0", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 190), ["Name"] = "Spider Eye", ["Item"] = "375.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 192), ["Name"] = "Nether Wart", ["Item"] = "372.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 83, 189), ["Name"] = "Arrow", ["Item"] = "262.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 188), ["Name"] = "String", ["Item"] = "287.0", ["Amount"] = 128, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 187), ["Name"] = "Slimeball", ["Item"] = "341.0", ["Amount"] = 8, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -119, 83, 186), ["Name"] = "Rotten Flesh", ["Item"] = "367.0", ["Amount"] = 128, ["Cost"] = 0.1},
	{["Location"] = Location:new(world.name, -119, 83, 185), ["Name"] = "Bone", ["Item"] = "352.0", ["Amount"] = 64, ["Cost"] = 0.5},
	{["Location"] = Location:new(world.name, -119, 83, 184), ["Name"] = "Gunpowder", ["Item"] = "289.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -119, 83, 183), ["Name"] = "Saddle", ["Item"] = "329.0", ["Amount"] = 1, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -119, 83, 182), ["Name"] = "Leather", ["Item"] = "334.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -120, 83, 178), ["Name"] = "Raw Chicken", ["Item"] = "365.0", ["Amount"] = 16, ["Cost"] = 2.5},
	{["Location"] = Location:new(world.name, -118, 83, 178), ["Name"] = "Cooked Chicken", ["Item"] = "366.0", ["Amount"] = 16, ["Cost"] = 3.4},
	{["Location"] = Location:new(world.name, -116, 83, 178), ["Name"] = "Raw Beef", ["Item"] = "363.0", ["Amount"] = 16, ["Cost"] = 2.5},
	{["Location"] = Location:new(world.name, -114, 83, 178), ["Name"] = "Steak", ["Item"] = "364.0", ["Amount"] = 16, ["Cost"] = 4},
	{["Location"] = Location:new(world.name, -112, 83, 178), ["Name"] = "Raw Porkchop", ["Item"] = "319.0", ["Amount"] = 16, ["Cost"] = 2.5},
	{["Location"] = Location:new(world.name, -110, 83, 178), ["Name"] = "Cooked Porkchop", ["Item"] = "320.0", ["Amount"] = 16, ["Cost"] = 4},
	{["Location"] = Location:new(world.name, -108, 83, 178), ["Name"] = "Clownfish", ["Item"] = "349.2", ["Amount"] = 8, ["Cost"] = 8},
	{["Location"] = Location:new(world.name, -106, 83, 178), ["Name"] = "Pufferfish", ["Item"] = "349.3", ["Amount"] = 8, ["Cost"] = 8},
	{["Location"] = Location:new(world.name, -104, 83, 178), ["Name"] = "Raw Salmon", ["Item"] = "349.1", ["Amount"] = 8, ["Cost"] = 5},
	{["Location"] = Location:new(world.name, -102, 83, 178), ["Name"] = "Raw Fish", ["Item"] = "349.0", ["Amount"] = 8, ["Cost"] = 3},
	{["Location"] = Location:new(world.name, -101, 83, 182), ["Name"] = "Oak Sapling", ["Item"] = "6.0", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 184), ["Name"] = "Spruce Sapling", ["Item"] = "6.1", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 186), ["Name"] = "Birch Sapling", ["Item"] = "6.2", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 188), ["Name"] = "Jungle Sapling", ["Item"] = "6.3", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 190), ["Name"] = "Acacia Sapling", ["Item"] = "6.4", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -101, 83, 192), ["Name"] = "Dark Oak Sapling", ["Item"] = "6.5", ["Amount"] = 64, ["Cost"] = 1},
	{["Location"] = Location:new(world.name, -105, 73, 190), ["Name"] = "Block Of Gold", ["Item"] = "41.0", ["Amount"] = 1, ["Cost"] = 6},
	{["Location"] = Location:new(world.name, -105, 73, 189), ["Name"] = "Block Of Redstone", ["Item"] = "152.0", ["Amount"] = 1, ["Cost"] = 3 },
	{["Location"] = Location:new(world.name, -105, 73, 188), ["Name"] = "Block Of Emerald", ["Item"] = "133.0", ["Amount"] = 1, ["Cost"] = 10},
	{["Location"] = Location:new(world.name, -105, 73, 187), ["Name"] = "Block Of Diamond", ["Item"] = "57.0", ["Amount"] = 1, ["Cost"] = 10},
	{["Location"] = Location:new(world.name, -105, 73, 186), ["Name"] = "Lapis Lazuli Block", ["Item"] = "22.0", ["Amount"] = 1, ["Cost"] = 4},
	{["Location"] = Location:new(world.name, -105, 73, 185), ["Name"] = "Block Of Iron", ["Item"] = "42.0", ["Amount"] = 1, ["Cost"] = 3.5},
	{["Location"] = Location:new(world.name, -105, 73, 184), ["Name"] = "Block Of Coal", ["Item"] = "173.0", ["Amount"] = 1, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -112, 73, 192), ["Name"] = "Obsidian", ["Item"] = "49.0", ["Amount"] = 16, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -111, 73, 192), ["Name"] = "Full Slab", ["Item"] = "43.8", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -110, 73, 192), ["Name"] = "Moss Stone", ["Item"] = "48.0", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -109, 73, 192), ["Name"] = "Full Sandstone", ["Item"] = "44.9", ["Amount"] = 64, ["Cost"] = 2},
	{["Location"] = Location:new(world.name, -107, 78, 178), ["Name"] = "Comparator", ["Item"] = "404.0", ["Amount"] = 5, ["Cost"] = 3.6},
	{["Location"] = Location:new(world.name, -113, 78, 178), ["Name"] = "Repeater", ["Item"] = "356.0", ["Amount"] = 5, ["Cost"] = 1.1}
};


--	{
--		["Location"] = Location:new(world.name, , , );
--		["Name"] = "",
--		["Item"] = "",
--		["Amount"] = ,
--		["Cost"] = 
--	},

------------
--- CORE ---
------------

local function talk(message)
	world:broadcast("&2[A]&f &bHeggle&f: " .. message);
end

-- Persists all balance data on the disk.
local function saveBalances()
	local file = io.open(PATH .. balanceFile, "w");
	file:write(serialize(playerBalances));
	file:close();
end

-- Load all balance data from the disk.
local function loadBalances()
	playerBalances = dofile(PATH .. balanceFile);
	
	if playerBalances == nil then
		playerBalances = {};
	end
end

-- Return the current balance for a player.
-- If no balance exists, it starts at 32.
function getBalance(player, new)
	if playerBalances[player.name] == nil then
		if new then
			updateBalance(player, 32);
		else
			return 0;
		end
	end
	
	return playerBalances[player.name];
end

-- Updates a players balance. The given amount is added to their current balance.
function updateBalance(player, amount)
	local newBalance = 0;
	
	if playerBalances[player.name] ~= nil then
		newBalance = playerBalances[player.name];
	end
	
	newBalance = newBalance + amount;
	
	if newBalance < 0 then
		newBalance = 0;
	end
	
	if newBalance >= 10000 then
		player:sendEvent("achievement.coins3");
	elseif newBalance >= 1000 then
		player:sendEvent("achievement.coins2");
	elseif newBalance >= 500 then
		player:sendEvent("achievement.coins");
	end
	
	playerBalances[player.name] = newBalance;
	saveBalances();
end

-- Chat event handler.
function shopHandleChat(data)
	local parts = {};
	
	for i in string.gmatch(data.message, "%S+") do
		table.insert(parts, i);
	end
	
	local main = string.lower(parts[1]);
	if main == "#balance" then
		--local balance = nil;
		
		if parts[2] ~= nil then
			local player = Player:new(parts[2]);
			local balance = getBalance(player, false);
			
			if balance > 500 then
				talk("Wow, " .. player.name .. " has " .. balance .. " coins!");
			elseif balance > 0 then
				talk(player.name .. " has " .. balance .. " coins.");
			else
				talk("It looks like " .. player.name .. " has no coins.");
			end
		else
			local player = Player:new(data.player);	
			local balance = getBalance(player, true);
			
			if balance > 500 then
				talk("Wow, you have " .. balance .. " coins, " .. player.name .. "!");
			elseif balance > 0 then
				talk("You have " .. balance .. " coins, " .. player.name .. ".");
			else
				talk("Sorry " .. player.name .. ", it appears you have nothing.");
			end
		end
	elseif main == "#grant" then
		if parts[2] ~= nil and parts[3] ~= nil then
			if data.player == "Kruithne" then
				local amount = math.ceil(tonumber(parts[3]));
				local player = Player:new(parts[2]);
				updateBalance(player, amount);
				talk(amount .. " coins granted to " .. player.name);
			else
				talk("Sorry " .. data.player .. ", I don't take orders from you!");
			end
		end
	elseif main == "#send" then
		if parts[2] ~= nil and parts[3] ~= nil then
			local sendingPlayer = Player:new(data.player);
			local player = Player:new(parts[2]);
			
			if sendingPlayer.name == player.name then
				talk("That would be very pointless, " .. player.name .. ".");
				return
			end
			
			local amount = math.ceil(tonumber(parts[3]));
			
			if amount < 0 then
				talk("Sorry " .. sendingPlayer.name .. ", you can't do that. Nice try though.");
			elseif amount == 0 then
				talk("Sending " .. player.name .. " nothing? That's mean.");
			else
				-- We do this rather than checking the balance to prevent creating
				-- fake balances.
				if playerBalances[player.name] ~= nil then
					local sendingBalance = getBalance(sendingPlayer, true);
					if sendingBalance >= amount then
						updateBalance(sendingPlayer, 0 - amount);
						updateBalance(player, amount);
						talk(sendingPlayer.name .. " just sent " .. amount .. " coins to " .. player.name .. "!");
						
						if amount >= 20 then
							sendingPlayer:sendEvent("achievement.openPockets");
						end
					else
						talk("You don't have that much to send, " .. sendingPlayer.name .. ". Awkward.");
					end
				else
					talk("Sorry " .. sendingPlayer.name .. ", that player isn't in my records!");
				end
			end
		end
	end
end

local function getShop(key)
	for index, shop in pairs(shops) do
		if shop.Key == key then
			return shop;
		end
	end
	return nil;
end

function shopHandleBuy(data)
	local player = Player:new(data.player);
	local shop = getShop("S" .. data.x .. data.y - 1 .. data.z);
	
	if shop ~= nil then
		local balance = getBalance(player, true);
		
		if balance >= shop.Cost then
			updateBalance(player, 0 - shop.Cost);
			player:addItem(shop.Item, shop.Amount);
			player:sendMessage("Purchased! You now have " .. getBalance(player, true) .. " coins.");
			
			if spree[player.name] == nil then
				spree[player.name] = shop.Cost;
			else
				spree[player.name] = spree[player.name] + shop.Cost;
			end
			
			if spree[player.name] >= 100 then
				player:sendEvent("achievement.bigSpender");
			end
		else
			player:sendMessage("&cSorry, you don't have enough coins for this.");
		end
	else
		player:sendMessage("&cSorry, something went wrong internally.");
	end
end

function shopHandleSell(data)
	local player = Player:new(data.player);
	local shop = getShop("S" .. data.x .. data.y + 1 .. data.z);
	
	if shop ~= nil then
		if player:hasItem(shop.Item, shop.Amount) then
			player:removeItem(shop.Item, shop.Amount);
			updateBalance(player, shop.Cost);
			player:sendMessage("Sold! You now have " .. getBalance(player, true) .. " coins.");
		else
			player:sendMessage("&cSorry, you don't have the correct items for this.");
		end
	else
		player:sendMessage("&cSorry, something went wrong internally.");
	end
end

-----------------------
--- REGISTRY / LOAD ---
-----------------------

loadBalances();

registerHook("CHAT_MESSAGE", "shopHandleChat", world.name);

for index, shop in pairs(shops) do
	local loc = shop.Location;
	EventEngine.world.setSign(loc.world, loc.x, loc.y, loc.z, "/\\ Buy /\\", shop.Name, shop.Amount .. " = " .. shop.Cost .. "c", "\\/ Sell \\/");
	
	registerHook("INTERACT", "shopHandleBuy", 77, loc.world, loc.x, loc.y + 1, loc.z);
	registerHook("INTERACT", "shopHandleSell", 143, loc.world, loc.x, loc.y - 1, loc.z);
	
	shop.Key = "S" .. loc.x .. loc.y .. loc.z;
end