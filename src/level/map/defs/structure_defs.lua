--[[
    Definitions for each structure in the game.
    @author Saverton
]]

STRUCTURE_DEFS = {
    ['fortress_room'] = {
        width = 5,
        height = 5,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            }
        },
        layout = {
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 1, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0}
        }
    }
}