--[[
    Enemy Walk: when the enemy is on the move
    @author Saverton
]]

EnemyWalkState = Class{__includes = EntityWalkState}

function EnemyWalkState:init(entity)
    EntityWalkState.init(self, entity)
    self.travel = {
        pixelsToTravel = 0,
        pixelsTraveled = 0
    } -- table with information about this entity's travel, will be used to determine when AI should be processed
end

-- enter the enemy walk state, set a distance to travel
function EnemyWalkState:enter(params)
    self.travel.pixelsToTravel = ((params or {}).distance or 1) * TILE_SIZE -- the amount of pixels to travel before ending this state
end

-- update the enemy's walk
function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) -- update movement
    self.travel.pixelsTraveled = self.travel.pixelsTraveled + (self.entity:getSpeed() * dt) -- update the amount of pixels traveled
    if self.travel.pixelsTraveled > TILE_SIZE then -- if the entity has traveled a tile, update its travel info and process AI
        self.travel.pixelsToTravel = math.max(0, self.travel.pixelsToTravel - self.travel.pixelsTraveled) -- remove the necessary pixles from pixels to travel
        self:processAI()
    elseif self.collidesWithObstacle then -- if the entity hits an obstacle, process AI
        self:processAI()
    end
end

-- processa AI of the enemy while walking
function EnemyWalkState:processAI()
    if self.collidesWithObstacle then
        return AI_DEFS[ENTITY_DEFS[self.entity.name].aiType .. '-obstacle']['walk'](self.entity, self.travel)
    else
        return AI_DEFS[ENTITY_DEFS[self.entity.name].aiType .. '-' .. self.entity.aiSubType]['walk'](self.entity, self.travel)  
    end
end