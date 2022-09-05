--[[
    NPC Manager Class: abstraction of all NPC related updates and functions out of Level Class.
    @author Saverton
]]

NPCManager = Class{}

function NPCManager:init(npcs, level)
    self.npcs = npcs or {}

    self.level = level

    table.insert(self.npcs, NPC(NPC_DEFS['quest'], self.level, {x = 10, y = 10}, {x = 0, y = 0}, self))
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
end

function NPCManager:render(camera)
    for i, npc in pairs(self.npcs) do
        npc:render(camera)
    end
end