--[[
    Biome Class: the biomes that define events in different areas of the world
    @author Saverton
]]

Biome = Class{}

function Biome:init(name)
    self.name = name
end

-- return a tile that this biome spawns
function Biome:getTile()
    local tile
    local number = math.random()
    local sum = 0
    for i in pairs(BIOME_DEFS[self.name].tiles) do -- randomly determine a tile from the selection
        sum = sum + BIOME_DEFS[self.name].tiles[i].chance -- add the chance for this tile to the total
        if number < sum then
            tile = BIOME_DEFS[self.name].tiles[i].tileType -- add the tile time if the number is less than the sum
        end
    end
    return tile
end

-- return a feature that this biome spawns
function Biome:getFeature()
    local number = math.random() -- random number to determine which feature to spawn
    local sum = 0
    for i, feature in pairs(BIOME_DEFS[self.name].features) do
        sum = sum + feature.chance -- go through each feature, if the total chance is greater than the random number, generate that feature
        if number < sum then
            return feature.name
        end
    end
end