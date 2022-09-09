--[[
    State in which the game is saved.
    @author Saverton
]]

SaveState = Class{__includes = BaseState}

function SaveState:init(level, loadnext)
    self.worldName = level.worldName
    self.levelName = level.levelName
    self.map = level.map
    self.player = level.player
    self.enemySpawner = level.enemySpawner
    self.pickupManager = level.pickupManager
    self.npcManager = level.npcManager
    self.loadnext = loadnext or nil
end

function SaveState:update()
    self:saveGame()

    gStateStack:pop()

    if self.loadnext ~= nil then
        gStateStack:pop()
        gStateStack:push(LoadState('worlds/' .. self.worldName, self.loadnext))
    end
end

function SaveState:render()
    love.graphics.setColor(0, 0, 0.5, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Saving...', VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2 - 10, 60, 'center')
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Saving...', VIRTUAL_WIDTH / 2 - 30 + 1, VIRTUAL_HEIGHT / 2 - 10 + 1, 60, 'center')
end

function SaveState:saveGame()
    love.filesystem.setIdentity('random_rpg')

    -- save the world's map
    if not love.filesystem.getInfo('worlds/' .. self.worldName .. '/' .. self.levelName) then
        love.filesystem.createDirectory('worlds/' .. self.worldName .. '/' .. self.levelName)
    end

    self:saveMap('worlds/' .. self.worldName .. '/' .. self.levelName)
    self:savePlayer('worlds/' .. self.worldName)
    self:saveEntities('worlds/' .. self.worldName .. '/' .. self.levelName)
    self:saveNPCS('worlds/' .. self.worldName .. '/' .. self.levelName)
    self:savePickups('worlds/' .. self.worldName .. '/' .. self.levelName)
end

function SaveState:saveMap(path)
    local featureMap = {}
    local tilesMap = {}
    local biomeMap = {}
    local gatewayMap = {}
    local playerPos = {x = self.player.x, y = self.player.y}

    for col = 1, self.map.size, 1 do
        featureMap[col] = {}
        for row = 1, self.map.size, 1 do
            local feature = self.map.featureMap[col][row]
            if feature ~= nil then
                featureMap[col][row] = feature.name
                if FEATURE_DEFS[feature.name].gateway then
                    table.insert(gatewayMap, {name = feature.name, x = col, y = row, destination = feature.destination, active = feature.active})
                end
            end
        end
    end

    for i, col in ipairs(self.map.tileMap.tiles) do
        tilesMap[i] = {}
        for j, tile in ipairs(col) do
            tilesMap[i][j] = tile.name
        end
    end

    for i, col in ipairs(self.map.tileMap.biomes) do
        biomeMap[i] = {}
        for j, biome in ipairs(col) do
            biomeMap[i][j] = biome.name
        end
    end

    love.filesystem.write(path .. '/player_pos.lua', Serialize(playerPos))
    love.filesystem.write(path .. '/world_features.lua', Serialize(featureMap))
    love.filesystem.write(path .. '/world_tiles.lua', Serialize(tilesMap))
    love.filesystem.write(path .. '/world_biomes.lua', Serialize(biomeMap))
    love.filesystem.write(path .. '/world_gateways.lua', Serialize(gatewayMap))
end

function SaveState:savePlayer(path)
    local pos = {
        x = (self.player.x / 16) + 1, 
        y = (self.player.y / 16) + 1
    }

    local def = {
        name = self.player.name,
        animName = self.player.animName,
        width = self.player.width,
        height = self.player.height,
        xOffset = self.player.xOffset,
        yOffset = self.player.yOffset,
        money = self.player.money,
        ammo = self.player.ammo,
        hp = self.player.hp,
        attack = self.player.attack,
        speed = self.player.speed,
        defense = self.player.defense,
        magic = self.player.magic,
        magicRegenRate = self.player.magicRegenRate,
        hpboost = self.player.hpboost,
        attackboost = self.player.attackboost,
        speedboost = self.player.speedboost,
        defenseboost = self.player.defenseboost,
        magicboost = self.player.magicboost,
        currenthp = self.player.currenthp,
        currentmagic = self.player.currentmagic,
        quests = {},
        effects = {},
        immunities = self.player.immunities,
        inflictions = self.player.inflictions,
        items = {},
        statLevel = self.player.statLevel:getSaveData()
    }

    local effects = {}
    local items = {}
    local quests = {}
    for i, effect in ipairs(self.player.effects) do
        table.insert(effects, {name = effect.name, duration = effect.duration})
    end
    def.effects = effects
    for i, item in ipairs(self.player.items) do
        table.insert(items, {name = item.name, quantity = item.quantity})
    end
    def.items = items
    for i, quest in ipairs(self.player.quests) do
        table.insert(quests, {name = quest.name, flags = quest.flags})
    end
    def.quests = quests

    local player = {def = def, pos = pos, currentLevel = self.levelName}

    love.filesystem.write(path .. '/player.lua', Serialize(player))
end

function SaveState:saveEntities(path)
    local enemySpawner = {
        entities = {},
        entityCap = self.enemySpawner.entityCap
    }

    for i, entity in ipairs(self.enemySpawner.entities) do
        local pos = {
            x = (entity.x / 16) + 1, 
            y = (entity.y / 16) + 1
        }
    
        local def = {
            name = entity.name,
            animName = entity.animName,
            width = entity.width,
            height = entity.height,
            xOffset = entity.xOffset,
            yOffset = entity.yOffset,
            hp = entity.hp,
            attack = entity.attack,
            speed = entity.speed,
            defense = entity.defense,
            magic = entity.magic,
            magicRegenRate = entity.magicRegenRate,
            hpboost = entity.hpboost,
            attackboost = entity.attackboost,
            speedboost = entity.speedboost,
            defenseboost = entity.defenseboost,
            magicboost = entity.magicboost,
            currenthp = entity.currenthp,
            currentmagic = entity.currentmagic,
            effects = {},
            immunities = entity.immunities,
            inflictions = entity.inflictions,
            items = {},
            agroDist = entity.agroDist,
            color = entity.color,
            statLevel = entity.statLevel:getSaveData()
        }
    
        local effects = {}
        local items = {}
        for i, effect in ipairs(entity.effects) do
            table.insert(effects, {name = effect.name, duration = effect.duration})
        end
        def.effects = effects
        for i, item in ipairs(entity.items) do
            table.insert(items, {name = item.name, quantity = item.quantity})
        end
        def.items = items
    
        local entity = {def = def, pos = pos}
        table.insert(enemySpawner.entities, entity)
    end

    love.filesystem.write(path .. '/entities.lua', Serialize(enemySpawner))
end

function SaveState:saveNPCS(path)
    local npcs = {}

    for i, entity in ipairs(self.npcManager.npcs) do
        local pos = {
            x = (entity.x / 16) + 1, 
            y = (entity.y / 16) + 1
        }
    
        local def = {
            name = entity.name,
            animName = entity.animName,
            npcName = entity.npcName,
            width = entity.width,
            height = entity.height,
            xOffset = entity.xOffset,
            yOffset = entity.yOffset,
            speed = entity.speed,
            timesInteractedWith = entity.timesInteractedWith,
            shop = {},
            quest = {},
            hasQuest = NPC_DEFS[entity.name].hasQuest
        }
        
        if entity.shop ~= nil then
            local shop = {
                startText = entity.shop.startText,
                endText = entity.shop.endtext, 
                soldOutText = entity.shop.soldOutText,
                notEnoughText = entity.shop.notEnoughText,
                inventory = entity.shop.inventory,
                sellDiff = entity.shop.sellDiff
            }

            def.shop = shop
        elseif def.hasQuest then
            local quest = {
                rewards = entity.quest.rewards,
                quest = {
                    name = entity.quest.quest.name,
                    flags = entity.quest.quest.flags
                },
                startText = entity.startText,
                endText = entity.endText,
                acceptText = entity.acceptText,
                refuseText = entity.refuseText,
                ongoingText = entity.ongoingText
            }

            def.quest = quest
        end
    
        local entity = {def = def, pos = pos}
        table.insert(npcs, entity)
    end

    love.filesystem.write(path .. '/npcs.lua', Serialize(npcs))
end

function SaveState:savePickups(path)
    local pickups = {}

    for i, pickup in ipairs(self.pickupManager.pickups) do
        table.insert(pickups, pickup)
    end

    love.filesystem.write(path .. '/pickups.lua', Serialize(pickups))
end