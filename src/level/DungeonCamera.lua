--[[
    Dungeon Camera: inherits from Camera; Special Camera for dungeons, does not regularly update, but rather is updated when the player's position
    moves off the screen, shifting one screen size in that direction.
]]

DungeonCamera = Class{__includes = Camera}

function DungeonCamera:init(target, level, currentRoom)
    Camera.init(self, target, level) -- initate a camera object
    self.currentRoom = currentRoom -- x and y of current room
    self.x = ((self.currentRoom.x * ROOM_WIDTH) + 0.5) * TILE_SIZE 
    self.y = ((self.currentRoom.y * ROOM_HEIGHT) + 0.75) * TILE_SIZE 
    self:resetCambox()
end

-- update the Dungeon camera by checking if the camera's target has moved across the screen.
function DungeonCamera:update()
    local newX, newY = self.x, self.y -- by default, no movement occurs
    if self.target.x + self.target.width < self.x then
        newX = math.max(0, self.x - CAMERA_WIDTH) -- if player moves left of screen, shift left
        self.currentRoom.x = self.currentRoom.x - 1
        self.cambox.x = newX
        self.cambox.width = self.cambox.width * 2
    elseif self.target.x > self.x + CAMERA_WIDTH then
        newX = math.min((self.level.map.width * TILE_SIZE) - CAMERA_WIDTH, self.x + CAMERA_WIDTH) -- if player moves right of screen, shift right
        self.currentRoom.x = self.currentRoom.x + 1
        self.cambox.width = self.cambox.width * 2
    elseif self.target.y + self.target.height < self.y then
        newY = math.max(0, self.y - CAMERA_HEIGHT - TILE_SIZE / 2) -- if player moves above screen, shift up
        self.currentRoom.y = self.currentRoom.y - 1
        self.cambox.y = newY
        self.cambox.height = self.cambox.height * 2 + 1
    elseif self.target.y > self.y + CAMERA_HEIGHT then
        newY = math.min((self.level.map.width * TILE_SIZE) - CAMERA_WIDTH, self.y + CAMERA_HEIGHT + TILE_SIZE / 2) -- of player moves below screen, shift down
        self.currentRoom.y = self.currentRoom.y + 1
        self.cambox.height = self.cambox.height * 2 + 1
    end
    if newX ~= self.x or newY ~= self.y then
        newX, newY = self:keepInMapBounds(newX, newY) -- make sure that the new camera position doesn't go out of the map's boundaries
        gStateStack:push(CameraShiftState(self, {x = newX, y = newY}, 2))
    end 
end

-- reset the cambox to cover only what is onscreen, called at the end of the CameraShiftState.
function DungeonCamera:resetCambox()
    self.cambox = {
        x = ((self.currentRoom.x * ROOM_WIDTH) + 1.5) * TILE_SIZE,
        y = ((self.currentRoom.y * ROOM_HEIGHT) + 1.75) * TILE_SIZE,
        width = CAMERA_WIDTH,
        height = CAMERA_HEIGHT
    } -- set the cambox to only cover onscreen activity
    print_r(self.cambox)
end