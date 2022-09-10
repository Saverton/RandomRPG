--[[
    Abstraction of all projectile related management for combatentities
    @author Saverton
]]

ProjectileManager = Class{}

function ProjectileManager:init(entity, projectiles)
    self.entity = entity
    self.projectiles = projectiles or {}
end

function ProjectileManager:spawnProjectile(name, origin)
    if #self.projectiles < PROJECTILE_CAP then
        table.insert(self.projectiles, Projectile(name, origin))
    end
end

function ProjectileManager:update(dt)
    local removeIndex = {}

    for i, projectile in pairs(self.projectiles) do
        projectile:update(dt) 
        if PROJECTILE_DEFS[projectile.name].attached and self.entity.pushed then
            projectile:updateOrigin(self.entity.x, self.entity.y)
        end

        if PROJECTILE_DEFS[projectile.name].type ~= 'none' then
            if self.entity.target ~= nil then
                if not self.entity.target.invincible and Collide(projectile, self.entity.target) then
                    projectile:hit(self.entity.target, self.entity)
                end
            elseif self.entity.renderPlayer ~= nil then
                if PROJECTILE_DEFS[projectile.name].type ~= 'none' then
                    for k, target in pairs(self.entity.level.enemySpawner.entities) do
                        if not target.invincible and Collide(projectile, target) then
                            projectile:hit(target, self.entity)
                        end
                    end
                end
            end
        end
        if projectile.hits <= 0 or projectile.lifetime <= 0 or GetDistance(projectile, self.entity.level.player) > DESPAWN_RANGE or 
            projectile:checkCollision(self.entity.level.map) then
            table.insert(removeIndex, i)
        end
    end

    for i, index in pairs(removeIndex) do
        table.remove(self.projectiles, index)
    end
end

function ProjectileManager:render(camera)
    for i, projectile in pairs(self.projectiles) do
        projectile:render(camera)
    end
end

function ProjectileManager:clearAttachedProjectiles()
    for i, projectile in pairs(self.projectiles) do
        if PROJECTILE_DEFS[projectile.name].type == 'none' or PROJECTILE_DEFS[projectile.name].type == 'melee' then
            table.remove(self.projectiles, i)
        end
    end
end