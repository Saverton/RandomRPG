--[[
    Imagebox state: Gui panel that contains a sprite.
]]

Imagebox = Class{}

function Imagebox:init(x, y, width, height, texture, frame)
    self.panel = Panel(x, y, width, height)

    self.texture = texture

    self.frame = frame
end

function Imagebox:render()
    self.panel:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], math.floor(self.panel.x + IMAGEBOX_MARGIN), math.floor(self.panel.y + IMAGEBOX_MARGIN), 0, 2, 2)
end