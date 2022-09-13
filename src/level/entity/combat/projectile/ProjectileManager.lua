--[[
    Projectile Manager: manages all projectiles that belong to a certain entity. Manages spawning and despawning
    @author Saverton
]]

ProjectileManager = Class{}

function ProjectileManager:init(entity)
    self.entity = entity -- reference to owner entity
    self.projectiles = {} -- table that holds all projectiles
end

-- update all projectiles
function ProjectileManager:update(dt)
    local removeIndex = {} -- table with indexes of projectiles to remove
    for i, projectile in pairs(self.projectiles) do
        projectile:update(dt) 
        if PROJECTILE_DEFS[projectile.name].attached and self.entity.pushManager.isPushed then
            projectile:updateOrigin(self.entity.x, self.entity.y)
        end -- if the entity is pushed, update a projectile if it is attached
        self:checkProjectileCollisions() -- check the projectile's collisions with entities
        if projectile.hits <= 0 or projectile.lifetime <= 0 or projectile:checkCollisionWithMap(self.entity.level.map) then
            table.insert(removeIndex, i) -- if the projectile is out of hits, has expired its lifetime, or hits a solid feature, add to despawn list
        end
    end
    for i, index in pairs(removeIndex) do -- remove any projectiles in the remove index table
        table.remove(self.projectiles, index)
    end
end

-- render each projectile
function ProjectileManager:render(camera)
    for i, projectile in pairs(self.projectiles) do
        projectile:render(camera)
    end
end

-- check the projectile's collisions with entities
function ProjectileManager:checkProjectileCollision(projectile)
    if PROJECTILE_DEFS[projectile.name].type ~= 'none' then -- ensure that the projectile is actually damaging
        if self.entity.isPlayer then
            for k, target in pairs(self.entity.level.entityManager.entities) do -- check each entity in the entityManager
                if not target.invincibilityManager.invincible and Collide(projectile, target) then
                    projectile:hit(target, self.entity) -- if the collision occurs and the target is not invincibile, hit the target
                end
            end
        else
            if not self.entity.target.invincible and Collide(projectile, self.entity.level.player) then
                projectile:hit(self.entity.level.player, self.entity) -- if the collision occurs and the target is not invincibile, hit the target
            end
        end
    end
end

-- spawn a projectile of a certain name at an origin position and direction
function ProjectileManager:spawnProjectile(name, origin)
    if #self.projectiles < PROJECTILE_CAP then -- check if the projectile cap is satisfied
        table.insert(self.projectiles, Projectile(name, origin))
    end
end