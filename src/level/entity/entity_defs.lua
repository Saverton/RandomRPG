--[[
    Table defining attributes for all entities.
    @author Saverton
]]

ENEMY_COLORS = {{252/255, 227/255, 3/255, 1}, {252/255, 94/255, 3/255, 1}, {3/255, 252/255, 235/255, 1}, {210/255, 3/255, 252/255, 1}, 
    {3/255, 252/255, 74/255, 1}, {150/255, 150/255, 150/255, 1}, {1, 0, 0, 1}, {255/255, 128/255, 128/255, 1}}

ENTITY_DEFS = {
    ['player'] = {
        name = 'player',
        displayName = 'Player',
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        xOffset = PLAYER_X_OFFSET,
        yOffset = PLAYER_Y_OFFSET,
        animations = {
            ['idle-right'] = {
                texture = 'player',
                frames = {1}
            },
            ['idle-down'] = {
                texture = 'player',
                frames = {5}
            },
            ['idle-left'] = {
                texture = 'player',
                frames = {1},
                xScale = -1
            },
            ['idle-up'] = {
                texture = 'player',
                frames = {9}
            },
            ['walk-right'] = {
                texture = 'player',
                frames = {1, 2, 3, 4},
                interval = PLAYER_ANIMATION_SPEED
            },
            ['walk-down'] = {
                texture = 'player',
                frames = {5, 6, 7, 8},
                interval = PLAYER_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'player',
                frames = {1, 2, 3, 4},
                interval = PLAYER_ANIMATION_SPEED,
                xScale = -1
            },
            ['walk-up'] = {
                texture = 'player',
                frames = {9, 10, 11, 12},
                interval = PLAYER_ANIMATION_SPEED
            },
            ['interact-up'] = {
                texture = 'player',
                frames = {14},
            },
            ['interact-right'] = {
                texture = 'player',
                frames = {13},
            },
            ['interact-down'] = {
                texture = 'player',
                frames = {15},
            },
            ['interact-left'] = {
                texture = 'player',
                frames = {13},
                xScale = -1
            }
        },
        hp = PLAYER_BASE_HP,
        speed = PLAYER_BASE_SPEED,
        defense = PLAYER_BASE_DEFENSE,
        magic = PLAYER_BASE_MAGIC,
        magicRegenRate = 0.5,
        onDeath = function() love.audio.play(gSounds['player_dies_1']) end,
        push = 16
    },
    ['goblin'] = {
        name = 'goblin',
        displayName = 'Goblin',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        animations = {
            ['idle-right'] = {
                texture = 'goblin',
                frames = {1}
            },
            ['idle-down'] = {
                texture = 'goblin',
                frames = {5}
            },
            ['idle-left'] = {
                texture = 'goblin',
                frames = {1},
                xScale = -1
            },
            ['idle-up'] = {
                texture = 'goblin',
                frames = {9}
            },
            ['walk-right'] = {
                texture = 'goblin',
                frames = {1, 2, 3, 4},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-down'] = {
                texture = 'goblin',
                frames = {5, 6, 7, 8},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'goblin',
                frames = {1, 2, 3, 4},
                interval = DEFAULT_ANIMATION_SPEED,
                xScale = -1
            },
            ['walk-up'] = {
                texture = 'goblin',
                frames = {9, 10, 11, 12},
                interval = DEFAULT_ANIMATION_SPEED
            }
        },
        hp = 5,
        speed = 16,
        agroSpeedBoost = 2,
        defense = 1,
        attack = 1,
        agroDist = 7,
        onDeath = function(entity, level) 
            love.audio.play(gSounds['enemy_dies_1'])
            if math.random(1, 3) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('ammo', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, math.random(2, 5)))
            end
            if math.random(1, 3) ~= 1 then
                table.insert(level.pickupManager.pickups, Pickup('money', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height), math.random(1, 2)))
            end
            if math.random(1, 5) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('health', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, 1))
            end
        end,
        push = 8
    },
    ['rock_golem'] = {

    }
}

NPC_DEFS = {
    ['tips'] = {
        name = 'test',
        displayName = 'Test NPC',
        width = 16,
        height = 16,
        animations = {
            ['idle-down'] = {
                texture = 'npc',
                frames = {1}
            }, 
            ['idle-right'] = {
                texture = 'npc',
                frames = {4}
            },
            ['idle-up'] = {
                texture = 'npc',
                frames = {7}
            },
            ['idle-left'] = {
                texture = 'npc',
                frames = {10},
                xScale = -1
            },
            ['walk-down'] = {
                texture = 'npc',
                frames = {1, 2, 1, 3},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-right'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-up'] = {
                texture = 'npc',
                frames = {7, 8, 7, 9},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED,
                xScale = -1
            }
        },
        startAnim = 'idle-down',
        onInteract = function(player)
            gStateStack:push(
                DialogueState(TIPS(math.random(#TIPS)))
            )
        end,
        isDespawnable = function(npc)
            return (npc.timesInteractedWith >= 1)
        end,
        speed = 16,
    },
    ['shop'] = {
        name = 'shop',
        displayName = 'Shop NPC',
        width = 16,
        height = 16,
        animations = {
            ['idle-down'] = {
                texture = 'npc',
                frames = {1}
            }, 
            ['idle-right'] = {
                texture = 'npc',
                frames = {4}
            },
            ['idle-up'] = {
                texture = 'npc',
                frames = {7}
            },
            ['idle-left'] = {
                texture = 'npc',
                frames = {10},
                xScale = -1
            },
            ['walk-down'] = {
                texture = 'npc',
                frames = {1, 2, 1, 3},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-right'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-up'] = {
                texture = 'npc',
                frames = {7, 8, 7, 9},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED,
                xScale = -1
            }
        },
        startAnim = 'idle-down',
        shop = {
            size = 3,
            itemPool = {'ammo', 'health', 'sword'}
        },
        onInteract = function(player, npc)
            npc.shop:open(player)
        end,
        isDespawnable = function(npc)
            return (npc.shop:getNumItems() == 0)
        end,
        speed = 16,
    },
    ['quest'] = {
        name = 'quest',
        displayName = 'Quest NPC',
        width = 16,
        height = 16,
        animations = {
            ['idle-down'] = {
                texture = 'npc',
                frames = {1}
            }, 
            ['idle-right'] = {
                texture = 'npc',
                frames = {4}
            },
            ['idle-up'] = {
                texture = 'npc',
                frames = {7}
            },
            ['idle-left'] = {
                texture = 'npc',
                frames = {10},
                xScale = -1
            },
            ['walk-down'] = {
                texture = 'npc',
                frames = {1, 2, 1, 3},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-right'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-up'] = {
                texture = 'npc',
                frames = {7, 8, 7, 9},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'npc',
                frames = {4, 5, 4, 6},
                interval = DEFAULT_ANIMATION_SPEED,
                xScale = -1
            }
        },
        startAnim = 'idle-down',
        quest = true,
        onInteract = function(player, npc)
            npc.quest:check(player)
        end,
        isDespawnable = function(npc)
            return (npc.quest.completed or npc.quest.denied)
        end,
        speed = 16,
    }
}