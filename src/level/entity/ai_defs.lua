--[[
    Enemy AI definitions; lists potential ai types that an enemy can have.
    @author Saverton
]]

AI_DEFS = {
    ['default'] = {
        ['wander'] = {
            ['idle'] = function(entity, timer) return DefaultWanderIdle(entity, timer) end,
            ['walk'] = function(entity, travel) return DefaultWanderWalk(entity, travel) end,
        },
        ['target'] = {
            ['idle'] = function(entity, timer) return DefaultTargetIdle(entity, timer) end,
            ['walk'] = function(entity, travel) return DefaultTargetWalk(entity, travel) end
        },
        ['obstacle'] = {
            ['walk'] = function(entity, travel) return DefaultObstacleWalk(entity, travel) end
        }
    },
    ['camo'] = {
        ['wander'] = {
            ['idle'] = function(entity, timer) return CamoWanderIdle(entity, timer) end,
            ['walk'] = function(entity, travel) return DefaultWanderWalk(entity, travel) end,
        },
        ['hide'] = {
            ['idle'] = function() end -- stays hidden indefinitely until trigger occurs
        },
        ['target'] = {
            ['idle'] = function(entity, timer) return DefaultTargetIdle(entity, timer) end,
            ['walk'] = function(entity, travel) return DefaultTargetWalk(entity, travel) end,
        },
        ['obstacle'] = {
            ['walk'] = function(entity, travel) return DefaultObstacleWalk(entity, travel) end
        }
    }
}

-- return the direction (string) that must be traveled to reduce the larger difference in position between two entities
function GetDirectionToReduceLargestDifference(entity, targetEntity)
    local dx, dy = entity.x - targetEntity.x, entity.y - targetEntity.y -- get the x and y differences between the entities' positions
    local direction = nil
    if math.abs(dx) > math.abs(dy) then -- determine which axis to move on based on which has the larger difference
        direction = dx > 0 and 'left' or 'right' -- determine which x direction to move to move closer to the target
    else
        direction = dy > 0 and 'up' or 'down' -- determine which y direction to move to move closer to the target
    end
    return direction
end

-- return the direction (string) that must be traveled to reduce the smaller difference in position between two entities
function GetDirectionToReduceLeastDifference(entity, targetEntity)
    local dx, dy = entity.x - targetEntity.x, entity.y - targetEntity.y -- get the x and y differences between the entities' positions
    local direction = nil
    if math.abs(dx) < math.abs(dy) then -- determine which axis to move on based on which has the smaller difference
        direction = dx > 0 and 'left' or 'right' -- determine which x direction to move to move closer to the target
    else
        direction = dy > 0 and 'up' or 'down' -- determine which y direction to move to move closer to the target
    end
    return direction
end

-- return true if an entity should and does use it's held item, false otherwise
function TryUsingHeldItem(entity)
    return entity:getHeldItem() ~= nil -- entity must have an item to use
        and GetDistance(entity, entity.target) <= entity:getHeldItem():getUseRange() -- the target entity must be within the item's use range
        and entity:useHeldItem() -- the entity must successfully use the held item
end

-- reset a moving entity's travel checker to new values
function ResetTravel(travelTable, newPixelsToTravel) -- args
    travelTable.pixelsToTravel = newPixelsToTravel -- set a new distance after which the entity will reach its destination
    travelTable.pixelsTraveled = 0 -- set the traveled distance back to 0
end

function DefaultWanderIdle(entity, timer) 
    local waitTimer = timer.table -- table that contains the timer group
    if #waitTimer == 0 then
        Timer.after(timer.duration, function() -- after the duration is up, start walking in a random direction
            entity:setRandomDirection() -- set the entity's direction to a random new direction
            entity:changeState('walk') -- tell the entity to start walking
        end):group(waitTimer) -- add this timer to the group
    end
end

function DefaultWanderWalk(entity, travel)
    if travel.pixelsToTravel > 0 then
        ResetTravel(travel, (travel.pixelsToTravel - travel.pixelsTraveled))
    else
        entity:changeState('idle')
    end
end

function DefaultTargetIdle(entity, timer)
    entity:changeState('walk') -- immediately set the entity to start walking in pursuit of its target.
end

function DefaultTargetWalk(entity, travel)
    if not (TryUsingHeldItem(entity)) then -- try using the entity's held item first
        local newDirection = GetDirectionToReduceLargestDifference(entity, entity.target) -- find the direction this entity should travel
        entity:setDirection(newDirection) -- change the entity's direction
    end
    ResetTravel(travel, TILE_SIZE) -- reset the travel parameters
end

function DefaultObstacleWalk(entity, travel)
    entity:shiftDirection(math.random() > 0.5 and 1 or -1) -- randomly choose a direction to turn (1 clockwise or counterclockwise)
    ResetTravel(travel, TILE_SIZE) -- reset the travel parameters
end

function CamoWanderIdle(entity, timer) 
    local waitTimer = timer.table -- table that contains the timer group
    if #waitTimer == 0 then
        Timer.after(timer.duration, function() -- after the duration is up, start walking in a random direction
            entity:changeState('hide') -- tell the entity to start walking
        end):group(waitTimer) -- add this timer to the group
    end
end
