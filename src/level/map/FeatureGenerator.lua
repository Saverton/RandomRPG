--[[
    Algorithm used to generate the features in a map. Places features based on a tile's Biome features and the biome's feature proclivity.
    @author Saverton
]]

function GenerateFeatures(size, tileMap)
    local featureMap = {}

    for col = 1, size, 1 do
        featureMap[col] = {}
        for row = 1, size, 1 do
            local biome = tileMap.biomes[col][row]
            -- determine if we generate a feature in this tile
            if math.random() < BIOME_DEFS[biome.name].featProc then
                -- generate a feature
                local num = math.random()
                local sum = 0
                for i, feature in pairs(BIOME_DEFS[biome.name].features) do
                    sum = sum + feature.proc 
                    if num < sum then
                        if FEATURE_DEFS[feature.name].animated then
                            featureMap[col][row] = AnimatedFeature(feature.name, col, row, Animation(feature.name, 'main'))
                        else
                            featureMap[col][row] = Feature(feature.name, col, row)
                        end
                        break
                    end
                end
            end
        end
    end

    return featureMap
end

function GenerateFortress(tileMap, featureMap, size, levelName)
    local fortX, fortY = math.random(2, size - 1), math.random(2, size - 1)
    while tileMap[fortX][fortY].name == 'water' do
        fortX, fortY = math.random(2, size - 1), math.random(2, size - 1)
    end

    local destination = '' 
    if (levelName == 'overworld-1') then
        destination = 'fortress-1'
    elseif (levelName == 'fortress-1') then
        destination = 'overworld-1'
    end

    featureMap[10][10] = GatewayFeature('fortress', fortX, fortY, destination)
end

function GetAnimatedFeatures(featureMap)
    local animatedFeatures = {}

    for i, col in pairs(featureMap) do
        for k, feature in pairs(col) do
            if FEATURE_DEFS[feature.name].animated then
                table.insert(animatedFeatures, feature)
            end
        end
    end

    return animatedFeatures
end