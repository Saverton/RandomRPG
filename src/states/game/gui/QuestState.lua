--[[
    Quest State: When the player is viewing his Quest.
    @author Saverton
]]

QuestState = Class{__includes = MenuState}

function QuestState:init(definitions, player)
    self.player = player -- reference to player who owns the quest list
    local selectionList = {} -- empty selection list
    local onSelectFunction = function() gStateStack:push(MenuState(MENU_DEFS['quest_item'], {parent = self})) end 
        -- call the quest item menu when selected
    for i, quest in ipairs(self.player.questManager.quests) do
        table.insert(selectionList, Selection(quest.name, onSelectFunction, tostring(i) .. ': ' .. quest.name))
    end -- get each selection with a quest name and index
    table.insert(selectionList, Selection('Close', function() gStateStack:pop() end)) -- add close option
    MenuState.init(self, definitions, {selections = selectionList}) -- initiate a menu state with the selection list
end