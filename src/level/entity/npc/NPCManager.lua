--[[
    NPC Manager Class: abstraction of all NPC related updates and functions.
    @author Saverton
]]

NPCManager = Class{}

function NPCManager:init(level, definitions)
    self.level = level
    self:getNpcs(definitions.npcs or {})
    self.cap = definitions.cap or NPC_CAP -- set max amount of npcs
end

-- update the npcs
function NPCManager:update(dt)
    for i, npc in pairs(self.npcs) do
        npc:update(dt)
    end
end

-- render the npcs
function NPCManager:render(camera)
    for i, npc in pairs(self.npcs) do
        npc:render(camera)
    end
end

-- remove any npcs that have a fully depleted despawn timer from the npc table, then try to spawn replacement npcs.
function NPCManager:clearDespawned()
    for i, npc in pairs(self.npcs) do
        if npc.despawnTimer == 0 then -- check if despawn timer is out
            table.remove(self.npcs, i)
        end
    end
    self:spawnNPCs() -- spawn new npcs
end

-- initiate all npcs from a table of npc definitions
function NPCManager:getNpcs(npcList)
    self.npcs = {}
    for i, npc in pairs(npcList) do -- insert each npc into the list of npcs
        table.insert(self.npcs, NPC(npc.definitions, self.level, npc.position, self))
    end
end

-- attempt to spawn npcs in this map
function NPCManager:spawnNPCs()
    while #self.npcs < self.cap do
        local x, y = self.level:getSpawnableCoord() -- find a place to spawn the npc
        table.insert(self.npcs, NPC(NPC_DEFS[NPC_TYPES[math.random(#NPC_TYPES)]], self.level, {x = x, y = y, xOffset = 0, yOffset = 0}, self))
            -- insert a random npc in at this location
    end
end