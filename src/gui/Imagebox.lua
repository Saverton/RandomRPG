--[[
    Imagebox state: Image box is a panel that contains a drawable. 
]]

Imagebox = Class{}

function Imagebox:init(position, texture, frame)
    self.panel = Panel(position.x, position.y, position.width, position.height) -- panel that the image is drawn onto
    self.texture = texture -- texture of the image
    self.frame = frame -- frame of the image quads
end

-- render the image box
function Imagebox:render()
    self.panel:render() -- render the panel
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame],
        math.floor(self.panel.x + IMAGEBOX_MARGIN), math.floor(self.panel.y + IMAGEBOX_MARGIN), 0, 2, 2) -- draw the image at double scale
end