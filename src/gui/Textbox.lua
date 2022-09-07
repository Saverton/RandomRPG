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
    self.revealed = 0
    self.revealLength = 0
    
    self.onComplete = onComplete
    self.finishedText = false

    self:next()
end

function Textbox:update(dt)
    if self.revealed < self.revealLength then
        self.revealed = math.min(self.revealLength, self.revealed + (TEXT_REVEAL_SPEED * dt))
        love.audio.play(gSounds['menu_blip_1'])
    end
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.revealed < self.revealLength then
            self.revealed = self.revealLength
        else
            self:next()
        end
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
            self.revealLength = self.revealLength + string.len(self.textChunks[i])
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
    local revealed = math.floor(self.revealed)

    -- render Dialogue
    love.graphics.setFont(self.font)
    local x = self.x + TEXTBOX_MARGIN
    for i, chunk in ipairs(self.displayingChunks) do
        local s = chunk
        if string.len(s) > revealed then
            s = string.sub(s, 0, revealed)
        end
        revealed = revealed - string.len(s)
        local y = self.y + (TEXTBOX_MARGIN * i) + (self.font:getHeight() * (i - 1))
        love.graphics.print(s, love.math.newTransform(math.floor(x), math.floor(y)))
        if revealed <= 0 then
            break
        end
    end
end