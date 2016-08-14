function puzzleOne_reset()
    puzzleOne_resetBlock(1021, 1010);
end

function puzzleOne_resetBlock(x, z)
    engine.world.setBlock('puzzle', x, 65, z, 0, 0);
    engine.world.setBlock('puzzle', x, 64, z, 152, 0);
end

--puzzleOne_reset();
