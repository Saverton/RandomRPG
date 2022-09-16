--[[
    Enemy despawns, renders cloud disappearing animation, and afterward calls entity manager's despawn inactive enemies method
    @author Saverton
]]

EnemyDespawnState = Class{__includes = EntityBaseState}

function EnemyDespawnState:init(entity)
    EntityBaseState.init(self, entity) -- initiate base state
    self.despawnTimer = {}
    Timer.after(DESPAWN_TIME, function() 
        self.entity.active = false
        self.entity.manager:removeInactiveEntities() 
    end):group(self.despawnTimer) -- after one second remove any inactive entities
    self.animation = Animation('smoke', 'disappear') -- animation to disappear the smoke
end

-- update the despawn timer and animation
function EnemyDespawnState:update(dt)
    self.animation:update(dt) -- update animation
    Timer.update(dt, self.despawnTimer) -- despawn timer group updated
end

-- render the disappear cloud
function EnemyDespawnState:render(x, y)
    self.animation:render(x, y) -- render cloud
end