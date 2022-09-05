--[[
    Quest State: When the player is viewing his Quest.
    @author Saverton
]]

QuestState = Class{__includes = MenuState}

function QuestState:init(def, player)
    self.player = player

    local selectionList = {}
    local fun = function() gStateStack:push(MenuState(MENU_DEFS['quest_item'], {parent = self})) end

    for i, quest in ipairs(self.player.quests) do
        table.insert(selectionList, Selection(quest.name, fun, i, tostring(i) .. ': ' .. quest.name))
    end
    table.insert(selectionList, Selection('close', function() gStateStack:pop() end))
    MenuState.init(self, def, {selections = selectionList})
end