--[[
    TileMap class: Base map of the world combining Tiles and Biomes.
    @author Saverton
]]

TileMap = Class{}

function TileMap:init(size, tiles, biomes)
    self.size = size or DEFAULT_MAP_SIZE
    self.tiles = tiles or GenerateTiles()
    self.biomes = biomes or GenerateBiomes()
end

function TileMap:update(dt) end

function TileMap:render()
    for i, row in pairs(self.tiles) do
        for j, tile in pairs(row) do
            tile:render()
        end
    end
end