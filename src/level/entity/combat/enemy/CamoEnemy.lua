--[[
    Camo Enemy: A special type of enemy that has a camoflogued state which must be triggered to emerge the enemy. Once emerged, the enemy behaves normal as an aggressive enemy towards the
    player. After losing interest in the player, the camo enemy returns to it's camoflogued state.
    @author Saverton
]]

CamoEnemy = Class{__includes = Enemy}

function CamoEnemy:init(level, definition, instance, manager)
    Enemy.init(self, level, definition, instance, manager) -- initiate all parent elements of the camo enemy
    self.isHiding = true
    self.stateMachine:addState(
        'hide', function() return EnemyHideState(self) end
    )
    self:changeState('hide')
    self.aiSubType = 'hide'
end

function CamoEnemy:update(dt)
    CombatEntity.update(self, dt) -- update combatentity components
    if self.active and self.currentStats.hp > 0 then
        if self.aiSubType == 'hide' then -- check in trigger distance
            self:attemptTrigger() -- check and see if the camo is triggered to enter into active state
        else
            self:seekTarget() -- try to find or track down a target
        end
    end
end

-- render the enemy on screen
function CamoEnemy:render(camera)
    local onScreenX, onScreenY = math.floor(self.x - camera.x + self.xOffset), math.floor(self.y - camera.y + self.yOffset - 4)
    if self.hasKey and self.currentStats.hp > 0 then -- render a key behind the enemy if it holds a key
        love.graphics.draw(gTextures['items'], gFrames['items'][11], onScreenX, onScreenY) -- draw a key
    end
    if (not self.isHiding) then
        love.graphics.setColor(self.color) -- set the color to the enemy's color
    end
    CombatEntity.render(self, camera) -- draw the entity onscreen
    if self:statsVisible() and self.currentStats.hp > 0 then
        self.hpBar:render(onScreenX, onScreenY) -- render the hp bar
        self:renderAggression(onScreenX, onScreenY) -- draw a little '!' if aggressive
    end
end

function CamoEnemy:attemptTrigger()
    if GetDistance(self, self.level.player) <= ENTITY_DEFS[self.name].triggerDistance * TILE_SIZE then
        self:trigger()
    end
end

function CamoEnemy:trigger()
    self.isHiding = false
    love.audio.play(gSounds['combat']['reveal'])-- play trigger sound
    self:seekTarget() -- seek target
    self:changeState('walk') -- set state to walk
end

-- return whether or not this entity's stats should be shown
function CamoEnemy:statsVisible()
    return self.active and not self.isHiding
end