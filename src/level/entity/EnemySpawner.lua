--[[
    Enemy Spawner Class: defines how enemies are spawned in on the map, keeps refs to all
    active enemies.
    @author Saverton
]]
EnemySpawner = Class{}

function EnemySpawner:init(level, entities, entityCap)
    self.level = level

    self.entities = {}
    if entities ~= nil then
        print('spawning entities')
        for i, entity in ipairs(entities) do
            table.insert(self.entities, Enemy(entity.def, self.level, entity.pos))
        end
    end

    self.entityCap = entityCap or DEFAULT_ENTITY_CAP

    self:spawnEnemies()
end

function EnemySpawner:update(dt)
    for i, enemy in pairs(self.entities) do
        if GetDistance(self.level.player, enemy) > DESPAWN_RANGE then
            table.remove(self.entities, i)
        elseif enemy.currenthp <= 0 then
            enemy:dies()
            table.remove(self.entities, i)
        end
    end

    for i, enemy in pairs(self.entities) do
        enemy:update(dt)
    end
end

function EnemySpawner:render(camera)
    for i, enemy in pairs(self.entities) do 
        enemy:render(camera)
    end
end

function EnemySpawner:spawnEnemies()
    local map = self.level.map
    local x, y = math.floor(self.level.player.x / TILE_SIZE),
        math.floor(self.level.player.y / TILE_SIZE)

    if #self.entities >= self.entityCap then
        goto stop
    end

    for col = math.max(1, x - SPAWN_RANGE), math.min(map.size, x + SPAWN_RANGE), 1 do
        for row = math.max(1, y - SPAWN_RANGE), math.min(map.size, y + SPAWN_RANGE), 1 do
            if not (map:isSpawnableSpace(col, row)) or
                GetDistance(self.level.player, {x = col * TILE_SIZE, y = row * TILE_SIZE}) < SAFE_RANGE * TILE_SIZE then
                goto continue
            end
            local biome = map.tileMap.biomes[col][row]
            if #biome.enemies >= 1 and math.random() < biome.spawnRate then
                local num = math.random()
                local sum = 0
                for i, enemy in pairs(biome.enemies) do
                    sum = sum + enemy.proc 
                    if num < sum then
                        local entity = Enemy(
                            ENTITY_DEFS[enemy.name],
                            self.level,
                            {
                                x = (col),
                                y = (row)
                            }
                        )
                        entity.stateMachine = StateMachine({
                            ['idle'] = function() return EnemyIdleState(entity) end,
                            ['walk'] = function() return EnemyWalkState(entity, self.level) end,
                            ['interact'] = function() return EntityInteractState(entity) end
                        })
                        entity:changeState('idle')
                        table.insert(self.entities, entity)
                        break
                    end
                end
            end

            if #self.entities >= self.entityCap then
                goto stop
            end
            ::continue::
        end
    end

    ::stop::
end