--[[
    NPC Class: NPCs that can appear on the Map, when talked to provide dialogue, a shop, or a quest
    attributes: onInteract(), timesInteractedWith, isDespawnable()
]]

NPC = Class{__includes = Entity}

function NPC:init(def, level, pos, off, manager)
    Entity.init(self, def, level, pos, off)
    self.npcName = NPC_NAMES[math.random(#NPC_NAMES)]

    self.onInteract = NPC_DEFS[self.name].onInteract
    self.timesInteractedWith = 0
    self.isDespawnable = NPC_DEFS[self.name].isDespawnable

    if NPC_DEFS[self.name].hasShop then
        self.shop = Shop(def.shop, self)
    elseif NPC_DEFS[self.name].hasQuest then
        local difficulty = math.random(1, 3)
        self.quest = Quest(def.quest or {}, difficulty, self)
    end

    self.stateMachine = StateMachine({
        ['idle'] = function() return NPCIdleState(self) end,
        ['walk'] = function() return NPCWalkState(self) end
    })
    self:changeState('idle')

    self.despawnTimer = -1
    self.manager = manager
end

function NPC:update(dt)
    Entity.update(self, dt)
    if self.despawnTimer > 0 then
        self.despawnTimer = math.max(self.despawnTimer - dt, 0)
        if self.despawnTimer == 0 then
            self.manager:clearDespawned()
        end
    elseif self.isDespawnable(self) then
        self:despawn()
    end
end

function NPC:despawn()
    self.despawnTimer = DESPAWN_TIMER
end

function NPC:interact(player)
    self.onInteract(player, self)

    self.timesInteractedWith = self.timesInteractedWith + 1
end

function NPC:getSpeed()
    return (self.speed) 
end

function NPC:render(camera)
    if self.despawnTimer > 0 then
        love.graphics.setColor(1, 1, 1, (self.despawnTimer / DESPAWN_TIMER))
    end
    Entity.render(self, camera)
end

function NPC:getDisplayMessage()
    -- return a string with basic info about this entity
    return (self.npcName .. ' the ' .. NPC_DEFS[self.name].displayName)
end