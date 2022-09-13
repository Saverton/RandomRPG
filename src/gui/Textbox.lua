--[[
    TextBox Class: Text box that appears on screen, displays text in chunks until completed. User must actively continue each chunk and close the
        box when dialogue ends.
    @author Saverton
]]

Textbox = Class{}

function Textbox:init(position, text, onComplete)
    self.x, self.y, self.width, self.height = position.x, position.y, position.width, position.height
    self.panel = Panel(self.x, self.y, self.width, self.height) -- panel that backdrops the text box
    _, self.textChunks = self.font:getWrap(text, self.width - (2 * TEXTBOX_MARGIN)) -- breaks the text into chunks that fit in the width of the panel
    self.displayingChunks = {} -- table with up to 3 chunks that can display on one panel
    self.currentChunk = 1 -- currentChunk indexed to be displayed next
    self.revealed = 0 -- amount of text revealed in a panel
    self.revealLength = 0 -- amount of text that can be revealed in panel
    self.onComplete = onComplete -- function callback for when textbox is closed
    self.finishedText = false -- flag for when the text is finished displaying
    self:next() -- get the next batch of chunks
end

-- update the textbox
function Textbox:update(dt)
    if self.revealed < self.revealLength then
        self.revealed = math.min(self.revealLength, self.revealed + (TEXT_REVEAL_SPEED * dt))
        love.audio.play(gSounds['gui']['menu_blip_1']) -- reveal more text and play beeping sound
    end
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then -- check for input
        if self.revealed < self.revealLength then -- if the text isn't finished revealing, finish it instantly
            self.revealed = self.revealLength
        else
            self:next() -- otherwise, proceed to next panel or finish
        end
    end
end

-- render the textbox
function Textbox:render()
    self.panel:render() -- render the panel
    local revealed = math.floor(self.revealed) -- determine how many characters will be printed
    local x = self.x + TEXTBOX_MARGIN -- x position of where text is to be printed
    for i, chunk in ipairs(self.displayingChunks) do
        local s = chunk -- current chunk for this line
        if string.len(s) > revealed then -- if this chunk is not fully to be revealed, create a substring
            s = string.sub(s, 0, revealed)
        end
        revealed = revealed - string.len(s) -- subtract this string's length from the amount to still be revealed
        local y = self.y + (TEXTBOX_MARGIN * i) + (self.font:getHeight() * (i - 1)) -- get the height of this line
        love.graphics.print(s, love.math.newTransform(math.floor(x), math.floor(y))) -- print the line
        if revealed <= 0 then -- if all that is to be revealed this frame is revealed, stop rendering text.
            break
        end
    end
end

-- proceed to next text panel or finish the text
function Textbox:next()
    love.audio.play(gSounds['gui']['menu_blip_1']) -- play a selection sound
    if self.finishedText then
        self.onComplete() -- if complete, execute the onComplete function
    else
        self.displayingChunks = self:getNextChunks() -- otherwise, get the next chunks to display
    end
end

-- retrieve the next chunks to be displayed in a panel.
function Textbox:getNextChunks()
    local chunks = {} -- the table to store the text chunks to be displayed next
    for i = self.currentChunk, self.currentChunk + 2 do -- get the next three chunks unless we run out of chunks
        if i <= #self.textChunks then -- add a new chunk
            self.revealLength = self.revealLength + string.len(self.textChunks[i]) -- add on this chunk's length to the reveal length
            table.insert(chunks, self.textChunks[i]) -- insert this chunk into the displaying chunks table
        else
            self.finishedText = true -- if out of chunks, finish the textbox, stop grabbing more chunks
            break
        end
    end
    self.currentChunk = self.currentChunk + 3 -- set the next chunk to be grabbed
    return chunks -- return the populated table of diplaying chunks for the current panel
end