--[[
    Biome Spreader: given a table of biome names and their start locations, creates a queue and spreads each biome until the entire map is filled.
    @author Saverton
]]

BiomeSpreader = Class{}

function BiomeSpreader:init(biomeList, biomeMap)
    self.spreadQueue = Queue(biomeList)
    self.map = biomeMap
end

-- activate the biome spreader
function BiomeSpreader:runSpreader()
    while not self.spreadQueue:isEmpty() do -- continue spreading until out of queue spaces
        self:spread() -- keep sreading
    end
end

-- spread the biome to the surrounding tiles, then add those tiles to the spread queue
function BiomeSpreader:spread()
    if math.random() > 0.5 then
        local biomeSpace = self.spreadQueue:next()
        for col = math.max(1, biomeSpace.col - 1), math.min(#self.map, biomeSpace.col + 1), 1 do
            for row = math.max(1, biomeSpace.row - 1), math.min(#self.map[col], biomeSpace.row + 1), 1 do
                if self.map[col][row].name == "empty" then
                    self.spreadQueue:append({col = col, row = row, biome = biomeSpace.biome})
                    self.map[col][row] = Biome(biomeSpace.biome)
                end 
            end
        end
    else
        self.spreadQueue:append(self.spreadQueue:next())
    end
end