--[[
    Definitions for all projectiles in the game.
    @author Saverton
]]

PROJECTILE_DEFS = {
    ['sword'] = {
        width = 16,
        height = 16,
        texture = 'sword',
        frames = {1, 2, 3, 4},
        damage = 2,
        speed = 0,
        lifetime = 0.3,
        hits = 5,
        push = 8,
        type = 'melee',
        inflictions = {{name = 'burn', duration = 2}}
    },
    ['bow'] = {
        width = 16,
        height = 16,
        texture = 'bow',
        frames = {1, 2, 3, 4},
        damage = 0,
        speed = 0,
        lifetime = 0.3,
        hits = 5,
        push = 0,
        type = 'none',
        inflictions = {}
    },
    ['arrow'] = {
        width = 16,
        height = 16,
        texture = 'arrow',
        frames = {1, 2, 3, 4},
        damage = 1,
        speed = 128,
        lifetime = 2,
        hits = 1,
        push = 8,
        type = 'ranged',
        inflictions = {}
    }
}