--[[
    Dialogue State: when the player is presented with dialogue.
    @author Saverton
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, texture, frame, onExit)
    self.onExit = onExit or function() end -- function executed on exiting the dialogue state
    self.textbox = Textbox({x = TEXTBOX_X, y = TEXTBOX_Y, width = TEXTBOX_WIDTH, height = TEXTBOX_HEIGHT}, text, function() 
        gStateStack:pop() 
        self.onExit()
    end) -- textbox for the dialogue state
    if texture == nil or frame == nil then -- if no image, no image box paired with the textbox
        self.imagebox = nil
    else -- otherwise, image box is paired with textbox
        self.imagebox = Imagebox({x = IMAGEBOX_X, y = IMAGEBOX_Y, width = IMAGEBOX_SIZE, height = IMAGEBOX_SIZE}, texture, frame)
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