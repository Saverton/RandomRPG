--[[
    Camera class: the camera that follows the player and determines what gets
    rendered.
    attributes: x, y, width, height
    @author Saverton
]]

Camera = Class{}

function Camera:init(target)
    self.target = target
    self.width = CAMERA_WIDTH
    self.height = CAMERA_HEIGHT
    self.x = math.floor(self.target.x + (self.target.width / 2) - (self.width / 2))
    self.y = math.floor(self.target.y + (self.target.height / 2) - (self.height / 2))

    self.cambox = {
        x = self.camera.x - OFFSCREEN_CAM_WIDTH,
        y = self.camera.y - OFFSCREEN_CAM_HEIGHT,
        width = self.camera.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.camera.height + (2 * OFFSCREEN_CAM_HEIGHT)
    }
end

function Camera:update()
    self.x = math.floor(self.target.x + (self.target.width / 2) - (self.width / 2))
    self.y = math.floor(self.target.y + (self.target.height / 2) - (self.height / 2))

    self.cambox = {
        x = self.camera.x - OFFSCREEN_CAM_WIDTH,
        y = self.camera.y - OFFSCREEN_CAM_HEIGHT,
        width = self.camera.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.camera.height + (2 * OFFSCREEN_CAM_HEIGHT)
    }
end