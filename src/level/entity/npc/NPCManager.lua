--[[
    NPC Manager Class: abstraction of all NPC related updates and functions out of Level Class.
    @author Saverton
]]

NPCManager = Class{}

function NPCManager:init(npcs, level)
    self.level = level
    self.npcs = {}
    if npcs ~= nil then
        for i, npc in pairs(npcs) do
            local npcObject = NPC(npc.def, self.level, npc.pos, {x = 0, y = 0}, self)
            table.insert(self.npcs, npcObject)
        end
    end

    self.cap = NPC_CAP

    self:spawnNPCs()
end

function NPCManager:update(dt)
    for i, npc in pairs(self.npcs) do
        npc:update(dt)
    end
end

function NPCManager:clearDespawned()
    for i, npc in pairs(self.npcs) do
        if npc.despawnTimer == 0 then
            table.remove(self.npcs, i)
        end
    end
    self:spawnNPCs()
end

function NPCManager:render(camera)
    for i, npc in pairs(self.npcs) do
        npc:render(camera)
    end
end

function NPCManager:spawnNPCs()
    local tries = 100
    while #self.npcs < self.cap and tries > 0 do

        local x, y = self.level:getSpawnableCoord()
        table.insert(self.npcs, NPC(NPC_DEFS[NPC_TYPES[math.random(#NPC_TYPES)]], self.level, {x = x, y = y}, {x = 0, y = 0}, self))
        
    end
end