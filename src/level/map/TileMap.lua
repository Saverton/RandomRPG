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
    self.edges = MapGenerator.generateEdges(size, self.tiles) 

    for row = 1, self.size, 1 do 
        for col = 1, self.size, 1 do
            if TILE_DEFS[self.tiles[row][col].name].animated then
                local tile = self.tiles[row][col]
                self.tiles[row][col] = AnimatedTile(tile.name, tile.mapX, tile.mapY, self.tileAnimators[tile.name])
            end
        end
    end
end

function TileMap:update(dt)
    for i, animator in pairs (self.tileAnimators) do
        animator:update(dt)
    end
end