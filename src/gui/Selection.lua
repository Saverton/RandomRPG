--[[
    Selection class: a selection in a menu
    @author Saverton
]]

Selection = Class{}

function Selection:init(name, onSelect, index, displayName)
    self.name = name

    self.onSelect = onSelect

    self.oldIndex = index or 0

    self.displayName = displayName or name
end

function Selection:select()
    love.audio.play(gSounds['gui']['menu_select_1'])
    self.onSelect()
end