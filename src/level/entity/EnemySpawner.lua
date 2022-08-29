--[[
    Enemy Spawner Class: defines how enemies are spawned in on the map.
    @author Saverton
]]

function SpawnEnemies(level, range)
    local map = level.map
    local entities = level.entities
    local entityCap = level.entityCap
    local x, y = math.floor(level.player.x / TILE_SIZE), math.floor(level.player.y / TILE_SIZE)

    if #entities >= entityCap then
        goto stop
    end

    for row = math.max(1, y - range), math.min(map.size, y + range), 1 do
        for column = math.max(1, x - range), math.min(map.size, x + range), 1 do
            if map.featureMap[row][column] ~= nil then
                goto continue
            end
            local biome = map.tileMap.biomes[row][column]
            if #biome.enemies >= 1 and math.random() < biome.spawnRate then
                local num = math.random()
                local sum = 0
                for i, enemy in pairs(biome.enemies) do
                    sum = sum + enemy.proc 
                    if num < sum then
                        local entity = Enemy(
                            ENTITY_DEFS[enemy.name],
                            level,
                            column * TILE_SIZE,
                            row * TILE_SIZE
                        )
                        entity.stateMachine = StateMachine({
                            ['idle'] = function() return EnemyIdleState(entity) end,
                            ['walk'] = function() return EnemyWalkState(entity, level) end
                        })
                        entity.stateMachine:change('idle', entity)
                        table.insert(entities, entity)
                        break
                    end
                end
            end

            if #entities >= entityCap then
                goto stop
            end
            ::continue::
        end
    end

    ::stop::
end