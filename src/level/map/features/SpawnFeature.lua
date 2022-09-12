--[[
    Spawn feature: automatically spawns it's held entity when the enemySpawner parses over it.
    @author Saverton
]]

SpawnFeature = Class{__includes = Feature}

function SpawnFeature:init(name, enemy)
    Feature.init(self, name) 
    self.enemy = enemy
    self.active = true
end