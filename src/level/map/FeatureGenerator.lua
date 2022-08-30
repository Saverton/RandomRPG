--[[
    Algorithm used to generate the features in a map. Places features based on a tile's Biome features and the biome's feature proclivity.
    @author Saverton
]]

function GenerateFeatures(size, tileMap)
    local featureMap = {}

    for col = 1, size, 1 do
        featureMap[col] = {}
        for row = 1, size, 1 do
            -- determine if we generate a feature in this tile
            if math.random() < tileMap.biomes[col][row].featProc then
                -- generate a feature
                local num = math.random()
                local sum = 0
                for i, feature in pairs(tileMap.biomes[col][row].features) do
                    sum = sum + feature.proc 
                    if num < sum then
                        featureMap[col][row] = Feature(feature.name, col, row)
                        break
                    end
                end
            end
        end
    end

    return featureMap
end