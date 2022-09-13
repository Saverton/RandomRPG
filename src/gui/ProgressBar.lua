--[[
    Progress Bar: A bar that fills up based on a ratio of progress specified in the render function.
    @author Saverton
]]

ProgressBar = Class{}

function ProgressBar:init(position, color)
    self.x, self.y = math.floor(position.x), math.floor(position.y) -- x and y position of bar
    self.width, self.height = math.floor(position.width), math.floor(position.height) -- width and height of bar
    self.panel = Panel(self.x, self.y, self.width, self.height) -- panel on which the bar is drawn
    self.color = color or {1, 0, 0, 1} -- color of the progress bar
    self.opacity = self.color[4] -- opacity of the progress bar
    self.ratio = 0 -- empty by default
end

-- set a new ratio to display
function ProgressBar:updateRatio(newRatio)
    self.ratio = newRatio
end

-- render the bar at either a specified x and y or at the bar's x and y
function ProgressBar:render(x, y)
    self.panel:render(self.opacity) -- render the background panel
    love.graphics.setColor(self.color) -- render the colored ratio bar
    love.graphics.rectangle('fill', (x or self.x), (y or self.y), self.width * (self.ratio), self.height, 2, 2)
    love.graphics.setColor(1, 1, 1, 1) -- set color back to default white
end