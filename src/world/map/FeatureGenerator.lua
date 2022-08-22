--[[
    Algorithm used to generate the features in a map. Places features based on a tile's Biome features and the biome's feature proclivity.
    @author Saverton
]]

function GenerateFeatures(size, tileMap)
    local featureMap = {}

    for row = 1, size, 1 do
        featureMap[row] = {}
        for column = 1, size, 1 do
            -- determine if we generate a feature in this tile
            if math.random() < tileMap[row][column].biome.featProc then
                -- generate a feature
                local num = math.random()
                local sum = 0
                for i, feature in pairs(tileMap[row][column].biome.features) do
                    sum = sum + feature.proc 
                    if num < sum then
                        featureMap[row][column] = Feature(feature.feature, row, column)
                    end
                end
            end
        end
    end

    return featureMap
end