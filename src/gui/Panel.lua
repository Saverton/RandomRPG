--[[
    Panel Class: basic panel that acts as a backdrop for any GUI elements.
    @author Saverton
]]

Panel = Class{}

function Panel:init(x, y, width, height)
    self.x, self.y, self.width, self.height = math.floor(x), math.floor(y), math.floor(width), math.floor(height)
        -- x, y, width, and height position of panel
end

-- render a panel with a specified opacity
function Panel:render(opacity)
    love.graphics.setColor(0, 0, 0, opacity or 1) -- set color to black with specified opacity
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2, 2) -- draw inner rectangle
    love.graphics.setColor(1, 1, 1, opacity or 1) -- set color to white with specified opacity
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 2, 2) -- draw outer rectangle
end