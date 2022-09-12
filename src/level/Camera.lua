--[[
    Camera class: behavior for tracking a target with the game's display, determines what is rendered.
    @author Saverton
]]

Camera = Class{}

function Camera:init(target, level)
    self.target = target -- the target of this camera, usually the player
    self.level = level -- the level that this camera belongs to
    -- set the initial position of the camera to center on the target
    self.x = math.floor(self.target.x + (self.target.width / 2) - (CAMERA_WIDTH / 2)) 
    self.y = math.floor(self.target.y + (self.target.height / 2) - (CAMERA_HEIGHT / 2))

    self.cambox = {
        x = self.x - OFFSCREEN_CAM_WIDTH,
        y = self.y - OFFSCREEN_CAM_HEIGHT,
        width = CAMERA_WIDTH + (2 * OFFSCREEN_CAM_WIDTH),
        height = CAMERA_HEIGHT + (2 * OFFSCREEN_CAM_HEIGHT)
    } -- set a cambox that encompasses the on screen camera with some added trim around the sides
end

-- update the camera according to the target's position
function Camera:update()
    self.x, self.y = math.floor(self.target.x + (self.target.width / 2) - (CAMERA_WIDTH / 2)), 
        math.floor(self.target.y + (self.target.height / 2) - (CAMERA_HEIGHT / 2)) -- center the camera's position on the player
    self.x, self.y = self:keepInMapBounds(self.x, self.y) -- keep camera within the map boundaries
    self.cambox = {
        x = self.x - OFFSCREEN_CAM_WIDTH,
        y = self.y - OFFSCREEN_CAM_HEIGHT,
        width = self.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.height + (2 * OFFSCREEN_CAM_HEIGHT)
    } -- reset the cambox with the new camera position
end

-- return a camera x and camera y that are within the bounds of the map
function Camera:keepInMapBounds(x, y)
    if x < 0 then
        x = 0
    elseif x + CAMERA_WIDTH > (self.level.map.width * TILE_SIZE) then
        x = math.floor((self.level.map.width * TILE_SIZE) - CAMERA_WIDTH)
    end
    if y < 0 then
        y = 0
    elseif y + CAMERA_HEIGHT > (self.level.map.height * TILE_SIZE) then
        y = math.floor((self.level.map.height * TILE_SIZE) - CAMERA_HEIGHT)
    end
    return x, y
end