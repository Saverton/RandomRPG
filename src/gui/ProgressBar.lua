--[[
    Progress Bar: A bar that fills up based on a ratio of progress.
    @author Saverton
]]

ProgressBar = Class{}

function ProgressBar:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.color = color or {1, 0, 0, 1}
    self.color[4] = 0.75
    self.ratio = 1
end

function ProgressBar:render(ratio, x, y)
    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.rectangle('fill', (x or self.x) - 1, (y or self.y) - 1, self.width + 2, self.height + 2)
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle('fill', (x or self.x), (y or self.y), self.width, self.height)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', (x or self.x), (y or self.y), self.width * (ratio), self.height)
    love.graphics.setColor(1, 1, 1, 1)
end