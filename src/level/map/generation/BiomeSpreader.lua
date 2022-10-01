--[[
    Biome Spreader: given a table of biome names and their start locations, creates a queue and spreads each biome until the entire map is filled.
    @author Saverton
]]

BiomeSpreader = Class{}

function BiomeSpreader:init(biomeList, biomeMap)
    self.spreadQueue = Queue(biomeList)
    self.map = biomeMap
end

function BiomeSpreader:spread()
    if self.spreadQueue:isEmpty() then -- stop spreading when queue is empty
        return
    end
    local biomeSpace = self.spreadQueue:next()
    for col = math.max(0, biomeSpace.col - 1), math.min(#self.map, biomeSpace.col + 1), 1 do
        for row = math.max(0, biomeSpace.row - 1), math.min(#self.map[col], biomeSpace.row), 1 do
            if self.map[col][row].name == "empty" then
                self.spreadQueue:append({col = col, row = row, biome = biomeSpace.biome})
                self.map[col][row] = Biome(biomeSpace.biome)
            end 
        end
    end
    self:spread() -- spread again
end