--[[
    Dialogue State: when the player is presented with dialogue.
    @author Saverton
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, texture, frame, onExit)
    self.onExit = onExit or function() end -- function executed on exiting the dialogue state
    self.textbox = Textbox(TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT, text, gFonts['small'], function() 
        gStateStack:pop() 
        self.onExit()
    end) -- textbox for the dialogue state
    if texture == nil or frame == nil then -- if no image, no image box paired with the textbox
        self.imagebox = nil
    else -- otherwise, image box is paired with textbox
        self.imagebox = Imagebox(IMAGEBOX_X, IMAGEBOX_Y, IMAGEBOX_SIZE, IMAGEBOX_SIZE, texture, frame)
    end
end

-- update textbox
function DialogueState:update(dt)
    self.textbox:update(dt)
end

-- render dialogue box
function DialogueState:render()
    self.textbox:render()
    if self.imagebox ~= nil then -- make sure imagebox exists
        self.imagebox:render()
    end
end