--[[
    Definitions for all projectiles in the game.
    @author Saverton
]]

PROJECTILE_DEFS = {
    ['sword'] = {
        width = 6,
        height = 16,
        hitboxOffsetX = 5,
        hitboxOffsetY = 0,
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
        width = 4,
        height = 16,
        hitboxOffsetX = 6,
        hitboxOffsetY = 0,
        damage = 1,
        speed = 128,
        lifetime = 2,
        hits = 1,
        push = 8,
        type = 'ranged',
        inflictions = {}
    },
    ['fireball'] = {
        width = 8,
        height = 8,
        hitboxOffsetX = 4,
        hitboxOffsetY = 4,
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
        width = 8,
        height = 8,
        hitboxOffsetX = 4,
        hitboxOffsetY = 4,
        damage = 0,
        speed = 64,
        lifetime = 1,
        hits = 3,
        push = 4,
        type = 'magic',
        inflictions = {{name = 'freeze', duration = 5}}
    },
    ['wooden_sword'] = {
        width = 6,
        height = 16,
        hitboxOffsetX = 5,
        hitboxOffsetY = 0,
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
        width = 10,
        height = 16,
        hitboxOffsetX = 3,
        hitboxOffsetY = 0,
        attached = true,
        damage = 4,
        speed = 0,
        lifetime = 0.5,
        hits = 5,
        push = 10,
        type = 'melee',
        inflictions = {}
    },
    ['key'] = {
        width = 16,
        height = 16,
        attached = true,
        damage = 0,
        speed = 0,
        lifetime = 0.5,
        hits = 1,
        push = 0,
        type = 'none',
        inflictions = {}
    }
}