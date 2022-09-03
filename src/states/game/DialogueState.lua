--[[
    Dialogue State: when the player is presented with dialogue.
    @author Saverton
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, texture, frame)
    self.textbox = Textbox(TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT, text, gFonts['small'], function() gStateStack:pop() end)

    self.imagebox = Imagebox(IMAGEBOX_X, IMAGEBOX_Y, IMAGEBOX_SIZE, IMAGEBOX_SIZE, texture, frame)
end

function DialogueState:update(dt)
    self.textbox:update(dt)
end

function DialogueState:render()
    self.textbox:render()
    self.imagebox:render()
end