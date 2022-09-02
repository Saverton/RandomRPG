--[[
    Panel Class: basic panel that acts as a backdrop for any GUI elements.
    @author Saverton
]]

Panel = Class{}

function Panel:init(x, y, width, height)
    self.x = math.floor(x)
    self.y = math.floor(y)
    self.width = math.floor(width)
    self.height = math.floor(height)
end

function Panel:render(opa)
    --draw main rectangle
    love.graphics.setColor(0, 0, 0, opa or 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2, 2)
    --draw outer rectangle
    love.graphics.setColor(1, 1, 1, opa or 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 2, 2)
end