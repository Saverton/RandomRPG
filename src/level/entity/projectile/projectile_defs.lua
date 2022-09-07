--[[
    Definitions for all projectiles in the game.
    @author Saverton
]]

PROJECTILE_DEFS = {
    ['sword'] = {
        width = 16,
        height = 16,
        attached = true,
        damage = 3,
        speed = 0,
        lifetime = 0.3,
        hits = 5,
        push = 8,
        type = 'melee',
        inflictions = {}
    },
    ['bow'] = {
        width = 16,
        height = 16,
        attached = true,
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
        damage = 1,
        speed = 128,
        lifetime = 2,
        hits = 1,
        push = 8,
        type = 'ranged',
        inflictions = {}
    },
    ['fireball'] = {
        width = 16,
        height = 16,
        damage = 0,
        speed = 64,
        lifetime = 1,
        hits = 3,
        push = 4,
        type = 'magic',
        inflictions = {{name = 'burn', duration = 2}}
    },
    ['tome'] = {
        width = 16,
        height = 16,
        attached = true,
        damage = 0,
        speed = 0,
        lifetime = 0.5,
        hits = 5,
        push = 0,
        type = 'none',
        inflictions = {}
    },
    ['ice'] = {
        width = 16,
        height = 16,
        damage = 0,
        speed = 64,
        lifetime = 1,
        hits = 3,
        push = 4,
        type = 'magic',
        inflictions = {{name = 'freeze', duration = 5}}
    },
    ['wooden_sword'] = {
        width = 16,
        height = 16,
        attached = true,
        damage = 1,
        speed = 0,
        lifetime = 0.3,
        hits = 5,
        push = 8,
        type = 'melee',
        inflictions = {}
    },
    ['battle_axe'] = {
        width = 16,
        height = 16,
        attached = true,
        damage = 4,
        speed = 0,
        lifetime = 0.5,
        hits = 5,
        push = 10,
        type = 'melee',
        inflictions = {}
    }
}