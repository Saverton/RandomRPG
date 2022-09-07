--[[
    State in which the game is saved.
    @author Saverton
]]

SaveState = Class{__includes = BaseState}

function SaveState:init(level)
    print('save state loaded')
    self.name = level.name
    self.map = level.map
    self.player = level.player
end

function SaveState:update()
    self:saveGame()

    gStateStack:pop()
    gStateStack:pop()
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
    if not love.filesystem.getInfo('worlds/' .. self.name .. '/map_overworld') then
        love.filesystem.createDirectory('worlds/' .. self.name .. '/map_overworld')
    end

    self:saveMap('worlds/' .. self.name .. '/map_overworld')
    self:savePlayer('worlds/' .. self.name)
end

function SaveState:saveMap(path)
    local featureMap = {}
    local tilesMap = {}
    local biomeMap = {}

    for col = 1, self.map.size, 1 do
        featureMap[col] = {}
        for row = 1, self.map.size, 1 do
            local feature = self.map.featureMap[col][row]
            if feature ~= nil then
                featureMap[col][row] = feature.name
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

    love.filesystem.write(path .. '/world_features.lua', Serialize(featureMap))
    love.filesystem.write(path .. '/world_tiles.lua', Serialize(tilesMap))
    love.filesystem.write(path .. '/world_biomes.lua', Serialize(biomeMap))
end

function SaveState:savePlayer(path)
    local pos = {
        x = (self.player.x / 16) + 1, 
        y = (self.player.y / 16) + 1
    }

    local def = {
        name = self.player.name,
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
        quests = self.player.quests,
        effects = {},
        immunities = self.player.immunities,
        inflictions = self.player.inflictions,
        items = {}
    }

    local effects = {}
    local items = {}
    for i, effect in ipairs(self.player.effects) do
        table.insert(effects, {name = effect.name, duration = effect.duration})
    end
    def.effects = effects
    for i, item in ipairs(self.player.items) do
        table.insert(items, {name = item.name, quantity = item.quantity})
    end
    def.items = items

    local player = {def = def, pos = pos}

    print_r(player)
    love.filesystem.write(path .. '/player.lua', Serialize(player))
end