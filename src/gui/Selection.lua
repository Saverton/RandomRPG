--[[
    Selection class: a selection in a menu, has a name, display name, onSelect function, and reference to its old index if switched
    @author Saverton
]]

Selection = Class{}

function Selection:init(name, onSelect, displayName, index)
    self.name = name -- name of the selection
    self.onSelect = onSelect -- function called when the item is selected
    self.displayName = displayName or name -- what is actually displayed in a menu
    self.oldIndex = index or 0 -- index of selection on initialization
end

-- select this selection object
function Selection:select()
    love.audio.play(gSounds['gui']['menu_select_1']) -- play selection sound
    self.onSelect() -- call onSelect function
end

-- print the selection at an x and y coordinate with a limit for character wrapping
function Selection:render(x, y, limit)
    love.graphics.printf(self.displayName, love.math.newTransform(x, y), limit, 'left')
end