--[[
    TileMap class: Base map of the world combining Tiles and Biomes.
    @author Saverton
]]

TileMap = Class{}

function TileMap:init(size, tiles, biomes)
    self.tileAnimators = {
        ['water'] = Animation('water', 'main')
    }
    self.size = size or DEFAULT_MAP_SIZE
    self.biomes = biomes or GenerateBiomes(size)
    self.tiles = tiles or GenerateTiles(size, self.biomes, self.tileAnimators)
    self.edges = GenerateEdges(size, self.tiles)
end

function TileMap:update(dt)
    for i, animator in pairs (self.tileAnimators) do
        animator:update(dt)
    end
end