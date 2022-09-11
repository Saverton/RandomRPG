--[[
    Special Camera for dungeons, moves only when player goes offscreen
]]

DungeonCamera = Class{__includes = Camera}

function DungeonCamera:init(target, level)
    Camera.init(self, target, level)
end

function DungeonCamera:update()
    self.cambox = {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }

    local newX, newY = self.x, self.y
    if self.target.x + self.target.width < self.x then
        newX = math.max(0, self.x - self.width)
        self.cambox.x = newX
        self.cambox.width = self.cambox.width * 2
    elseif self.target.x > self.x + self.width then
        newX = math.min((self.level.map.size * TILE_SIZE) - self.width, self.x + self.width)
        self.cambox.width = self.cambox.width * 2
    elseif self.target.y + self.target.height < self.y then
        newY = math.max(0, self.y - self.height - TILE_SIZE / 2)
        self.cambox.y = newY
        self.cambox.height = self.cambox.height * 2
    elseif self.target.y > self.y + self.height then
        newY = math.min((self.level.map.size * TILE_SIZE) - self.width, self.y + self.height + TILE_SIZE / 2)
        self.cambox.height = self.cambox.height * 2
    end
    if newX ~= self.x or newY ~= self.y then
        gStateStack:push(CameraShiftState(self, {x = newX, y = newY}, 2))
    end 
end