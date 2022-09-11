--[[
    Special Camera for dungeons, moves only when player goes offscreen
]]

DungeonCamera = Class{__includes = Camera}

function DungeonCamera:init(target, level)
    Camera.init(self, target, level)
end

function DungeonCamera:update()
    if self.target.x + self.target.width < self.x then
        self.x = math.max(0, self.x - self.width)
    elseif self.target.x > self.x + self.width then
        self.x = math.min(self.level.map.size * TILE_SIZE, self.x + self.width)
    elseif self.target.y + self.target.height < self.y then
        self.y = math.max(0, self.y - self.height)
    elseif self.target.y > self.y + self.height then
        self.y = math.min(self.level.map.size * TILE_SIZE, self.y + self.height)
    end

    self.cambox = {
        x = self.x - OFFSCREEN_CAM_WIDTH,
        y = self.y - OFFSCREEN_CAM_HEIGHT,
        width = self.width + (2 * OFFSCREEN_CAM_WIDTH),
        height = self.height + (2 * OFFSCREEN_CAM_HEIGHT)
    }
end