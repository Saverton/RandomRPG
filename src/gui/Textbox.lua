--[[
    Dialogue Box Class: dialogue box that appears on screen.
    @author Saverton
]]

Textbox = Class{}

function Textbox:init(x, y, width, height, text, font, onComplete)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.panel = Panel(x, y, width, height)
    
    self.font = font
    _, self.textChunks = self.font:getWrap(text, self.width - (2 * TEXTBOX_MARGIN))
    self.displayingChunks = {}
    self.currentChunk = 1
    
    self.onComplete = onComplete
    self.finishedText = false

    self:next()
end

function Textbox:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self:next()
    end
end

function Textbox:next()
    love.audio.play(gSounds['menu_blip_1'])
    if self.finishedText then
        self.onComplete()
    else
        self.displayingChunks = self:getNextChunks()
    end
end

function Textbox:getNextChunks()
    -- get the next three chunks
    local chunks = {}

    for i = self.currentChunk, self.currentChunk + 2 do
        if i <= #self.textChunks then
            table.insert(chunks, self.textChunks[i])
        else
            self.finishedText = true
            break
        end
    end

    self.currentChunk = self.currentChunk + 3

    return chunks
end

function Textbox:render()
    self.panel:render()

    -- render Dialogue
    love.graphics.setFont(self.font)
    local x = self.x + TEXTBOX_MARGIN
    for i, chunk in ipairs(self.displayingChunks) do
        local y = self.y + (TEXTBOX_MARGIN * i) + (self.font:getHeight() * (i - 1))
        love.graphics.print(chunk, love.math.newTransform(math.floor(x), math.floor(y)))
    end
end