--[[
    Camera class: the camera that follows the player and determines what gets
    rendered.
    attributes: x, y, width, height
    @author Saverton
]]

Camera = Class{}

function Camera:init(target, level)
    self.target = target
    self.level = level
    self.width = CAMERA_WIDTH
    self.height = CAMERA_HEIGHT
    self.x = math.floor(self.target.x + (self.target.width / 2) - (self.width / 2))
    self.y = math.floor(self.target.y + (self.target.height / 2) - (self.height / 2))

    self.cambox = {
        x = self.x - OFFSCREEN_CAM_WIDTH,
        y = self.y - OFFSCREEN_CAM_HEIGHT,
        width = self.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.height + (2 * OFFSCREEN_CAM_HEIGHT)
    }
end

function Camera:update()
    self.x = math.floor(self.target.x + (self.target.width / 2) - (self.width / 2))
    self.y = math.floor(self.target.y + (self.target.height / 2) - (self.height / 2))

    -- keep cam on map
    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > (self.level.map.size * TILE_SIZE) then
        self.x = math.floor((self.level.map.size * TILE_SIZE) - self.width)
    end

    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > (self.level.map.size * TILE_SIZE) then
        self.y = math.floor((self.level.map.size * TILE_SIZE) - self.height)
    end

    self.cambox = {
        x = self.x - OFFSCREEN_CAM_WIDTH,
        y = self.y - OFFSCREEN_CAM_HEIGHT,
        width = self.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.height + (2 * OFFSCREEN_CAM_HEIGHT)
    }
    print('cam.x: ' .. tostring(self.x))
end