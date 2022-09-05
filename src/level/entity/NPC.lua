--[[
    NPC Class: NPCs that can appear on the Map, when talked to provide dialogue, a shop, or a quest
    attributes: onInteract(), timesInteractedWith, isDespawnable()
]]

NPC = Class{__includes = Entity}

function NPC:init(def, level, pos, off, manager)
    Entity.init(self, def, level, pos, off)
    self.speed = def.speed

    self.onInteract = def.onInteract
    self.timesInteractedWith = 0
    self.isDespawnable = def.isDespawnable

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
    end
end

function NPC:despawn()
    self.despawnTimer = DESPAWN_TIMER
end

function NPC:interact(player)
    self.onInteract(player)

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