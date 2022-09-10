--[[
    Biome Class: the biomes that define events in different areas of the world
    attributes: id, name, tiles(that compose this biome), enemies(that can appear here), features(that can spawn here)
    @author Saverton
]]

Biome = Class{}

function Biome:init(name)
    self.name = name
end

function Biome:getTile()
    local tile

    -- randomly determine a tile from the selection
    local num = math.random()
    local sum = 0
    for i in pairs(BIOME_DEFS[self.name].tiles) do
        sum = sum + BIOME_DEFS[self.name].tiles[i].proc 
        if num < sum then
            tile = BIOME_DEFS[self.name].tiles[i].tileType
        end
    end

    return tile
end