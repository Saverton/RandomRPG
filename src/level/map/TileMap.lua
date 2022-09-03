--[[
    TileMap class: Base map of the world combining Tiles and Biomes.
    @author Saverton
]]

TileMap = Class{}

function TileMap:init(size, tiles, biomes)
    self.size = size or DEFAULT_MAP_SIZE
    self.biomes = biomes or GenerateBiomes(size)
    self.tiles = tiles or GenerateTiles(size, self.biomes)
    self.edges = GenerateEdges(size, self.tiles)
end