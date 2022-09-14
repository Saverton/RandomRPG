--[[
    Dungeon Camera: inherits from Camera; Special Camera for dungeons, does not regularly update, but rather is updated when the player's position
    moves off the screen, shifting one screen size in that direction.
]]

DungeonCamera = Class{__includes = Camera}

function DungeonCamera:init(target, level)
    Camera.init(self, target, level) -- initate a camera object
    self.cambox = {
        x = self.x,
        y = self.y,
        width = CAMERA_WIDTH,
        height = CAMERA_HEIGHT
    } -- set the cambox to only cover onscreen activity
end

-- update the Dungeon camera by checking if the camera's target has moved across the screen.
function DungeonCamera:update()
    local newX, newY = self.x, self.y -- by default, no movement occurs
    if self.target.x + self.target.width < self.x then
        newX = math.max(0, self.x - CAMERA_WIDTH) -- if player moves left of screen, shift left
        self.cambox.x = newX
        self.cambox.width = self.cambox.width * 2
    elseif self.target.x > self.x + CAMERA_WIDTH then
        newX = math.min((self.level.map.width * TILE_SIZE) - CAMERA_WIDTH, self.x + CAMERA_WIDTH) -- if player moves right of screen, shift right
        self.cambox.width = self.cambox.width * 2
    elseif self.target.y + self.target.height < self.y then
        newY = math.max(0, self.y - CAMERA_HEIGHT - TILE_SIZE / 2) -- if player moves above screen, shift up
        self.cambox.y = newY
        self.cambox.height = self.cambox.height * 2
    elseif self.target.y > self.y + CAMERA_HEIGHT then
        newY = math.min((self.level.map.width * TILE_SIZE) - CAMERA_WIDTH, self.y + CAMERA_HEIGHT + TILE_SIZE / 2) -- of player moves below screen, shift down
        self.cambox.height = self.cambox.height * 2
    end
    if newX ~= self.x or newY ~= self.y then
        newX, newY = self:keepInMapBounds(newX, newY) -- make sure that the new camera position doesn't go out of the map's boundaries
        gStateStack:push(CameraShiftState(self, {x = newX, y = newY}, 2))
        self.level.entityManager:reset() -- reset the entity manager of the level to remove all entities and respawn them in the new room.
    end 
end

-- reset the cambox to cover only what is onscreen, called at the end of the CameraShiftState.
function DungeonCamera:resetCambox()
    self.cambox = {
        x = self.x,
        y = self.y,
        width = CAMERA_WIDTH,
        height = CAMERA_HEIGHT
    } -- set the cambox to only cover onscreen activity
end