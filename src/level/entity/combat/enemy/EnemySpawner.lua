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
        for i, entity in ipairs(entities) do
            local enemy = Enemy(entity.def, self.level, entity.pos)
            enemy.stateMachine = StateMachine({
                ['idle'] = function() return EnemyIdleState(enemy) end,
                ['walk'] = function() return EnemyWalkState(enemy, self.level) end,
                ['interact'] = function() return EntityInteractState(enemy) end
            })
            enemy:changeState('idle')
            table.insert(self.entities, enemy)
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
    local statLevelMax = self.level.player.statLevel.level or 1
    local map = self.level.map
    local x, y = math.floor(self.level.player.x / TILE_SIZE),
        math.floor(self.level.player.y / TILE_SIZE)

    if #self.entities >= self.entityCap then
        goto stop
    end

    for col = math.max(1, x - SPAWN_MAX_RANGE), math.min(map.size, x + SPAWN_MAX_RANGE), 1 do
        for row = math.max(1, y -  SPAWN_MAX_RANGE), math.min(map.size, y + SPAWN_MAX_RANGE), 1 do
            if self.level.map.featureMap[col][row] ~= nil and FEATURE_DEFS[self.level.map.featureMap[col][row].name].spawner and self.level.map.featureMap[col][row].active then
                self.level.map.featureMap[col][row].active = false
                local entity = Enemy(
                    ENTITY_DEFS[self.level.map.featureMap[col][row].enemy],
                    self.level,
                    {x = (col), y = (row), ox = 0, oy = 0},
                    math.max(1, statLevelMax - math.random(0, 2))
                )
                entity.stateMachine = StateMachine({
                    ['idle'] = function() return EnemyIdleState(entity) end,
                    ['walk'] = function() return EnemyWalkState(entity, self.level) end,
                    ['interact'] = function() return EntityInteractState(entity) end
                })
                entity:changeState('idle')
                table.insert(self.entities, entity)
                goto continue
            end
            if not (map:isSpawnableSpace(col, row)) or
                GetDistance(self.level.player, {x = col * TILE_SIZE, y = row * TILE_SIZE}) < SPAWN_MIN_RANGE * TILE_SIZE then
                goto continue
            end
            local biome = map.biomeMap[col][row]
            if #BIOME_DEFS[biome.name].enemies >= 1 and math.random() < BIOME_DEFS[biome.name].spawnRate then
                local num = math.random()
                local sum = 0
                for i, enemy in pairs(BIOME_DEFS[biome.name].enemies) do
                    sum = sum + enemy.proc 
                    if num < sum then
                        local entity = Enemy(
                            ENTITY_DEFS[enemy.name],
                            self.level,
                            {x = (col), y = (row), ox = 0, oy = 0},
                            math.max(1, statLevelMax - math.random(0, 2))
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

function EnemySpawner:reset()
    self.entities = {}
    self:spawnEnemies()
end