--[[
    Dialogue State: when the player is presented with dialogue.
    @author Saverton
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, texture, frame, onExit)
    self.onExit = onExit or function() end

    self.textbox = Textbox(TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT, text, gFonts['small'], function() 
        gStateStack:pop() 
        self.onExit()
    end)

    if texture == nil or frame == nil then
        self.imagebox = nil
        print('texture or frame is nil')
    else
        self.imagebox = Imagebox(IMAGEBOX_X, IMAGEBOX_Y, IMAGEBOX_SIZE, IMAGEBOX_SIZE, texture, frame)
    end
end

function DialogueState:update(dt)
    self.textbox:update(dt)
end

function DialogueState:render()
    self.textbox:render()
    if self.imagebox ~= nil then
        self.imagebox:render()
    end
end