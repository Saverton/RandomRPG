--[[
    NPC walk state: for processing AI when the NPC is walking
    @author Saverton
]]

NPCWalkState = Class{__includes = EntityWalkState}

function NPCWalkState:init(entity)
    EntityWalkState.init(self, entity)
    self.walkDist = 0 -- distance to walk in tiles
end

-- enter the walk state
function NPCWalkState:enter(params)
    if params == nil then -- ensure params exists
        params = {}
    end
    self.walkDist = (params.distance or 1) * TILE_SIZE -- set new walking distance
end

-- update the walk distance and process AI if the distance has been fulfilled
function NPCWalkState:update(dt)
    EntityWalkState.update(self, dt) 
    self.walkDist = math.max(0, self.walkDist - (self.entity:getSpeed() * dt)) -- update distance left to walk
    if self.walkDist == 0 then -- if reached walkdistance then process ai
        self:processAI()
    end
end

-- decide what to do next
function NPCWalkState:processAI()
    self.entity:changeState('idle', {time = math.random(3, 10)}) -- stop walking, set a wait time 
end