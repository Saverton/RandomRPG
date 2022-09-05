--[[
    NPC walk state: for processing AI when the NPC is walking
    @author Saverton
]]

NPCWalkState = Class{__includes = EntityWalkState}

function NPCWalkState:init(entity)
    EntityWalkState.init(self, entity)

    self.walkDist = 0
end

function NPCWalkState:enter(params)
    if params == nil then
        params = {}
    end
    self.walkDist = (params.distance or 1) * TILE_SIZE
end

function NPCWalkState:update(dt)
    EntityWalkState.update(self, dt) 

    self.walkDist = math.max(0, self.walkDist - (self.entity:getSpeed() * dt))
    if self.walkDist == 0 then
        self:processAI()
    end
end

function NPCWalkState:processAI()
    self.entity:changeState('idle', {time = math.random(1, 5)})    
end