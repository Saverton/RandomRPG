--[[
    Dungeon Map: Inherited from Map, Manages all activity on the maps of dungeons. Differences from OverworldMap: no biomeMap, no edgeMap,
    has spawner features, has start location.
    @author Saverton
]]

DungeonMap = Class{__includes = Map}

function DungeonMap:init(dimensions, definitions)
    Map.init(self, dimensions, definitions)
    -- ensure that all spawner features have been properly initiated.
    for i, spawner in pairs(definitions.spawnerMap or {}) do
        self.featureMap[spawner.x][spawner.y] = SpawnFeature(spawner.name, spawner.enemy)
    end
    self.start = definitions.start -- initiate a start position for the player to spawn whenever this map is loaded.
end