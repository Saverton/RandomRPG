--[[
    Biome Class: the biomes that define events in different areas of the world
    attributes: id, name, tiles(that compose this biome), enemies(that can appear here), features(that can spawn here)
    @author Saverton
]]

Biome = Class{}

function Biome:init(def)
    self.id = def.id or 0
    self.name = def.name
    self.tiles = def.tiles or {}
    self.enemies = def.enemies or {}
    self.features = def.features or {}
    self.featProc = def.featProc or 0
end

function Biome:getTile()
    local tile

    -- randomly determine a tile from the selection
    local num = math.random()
    local sum = 0
    for i in pairs(self.tiles) do
        sum = sum + self.tiles[i].proc 
        if num < sum then
            tile = self.tiles[i].tileType
        end
    end

    return tile
end