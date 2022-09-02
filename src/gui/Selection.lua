--[[
    Selection class: a selection in a menu
    @author Saverton
]]

Selection = Class{}

function Selection:init(name, onSelect)
    self.name = name

    self.onSelect = onSelect
end

function Selection:select()
    love.audio.play(gSounds['menu_select_1'])
    self.onSelect()
end