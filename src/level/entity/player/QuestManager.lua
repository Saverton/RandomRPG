--[[
    Quest Manager: abstraction of all quest functionality for the player.
    @author Saverton
]]

QuestManager = Class{}

function QuestManager:init(quests)
    self.quests = {} -- initiate the quest list as empty
    if quests ~= nil then -- add in the quests from the quest list
        for i, quest in ipairs(quests) do
            table.insert(self.quests, {name = quest.name, flags = quest.flags})
        end
    end
end

-- update the flags for each quest with a list of thrown flags
function QuestManager:updateFlags(thrownFlags)
    for i, quest in pairs(self.quests) do -- check each quest
        for j, flag in pairs(quest.flags) do -- check each flag in the quest
            for k, thrownFlag in pairs(thrownFlags) do -- check each thrown Flag
                if flag.name == thrownFlag then
                    flag.counter = math.max(0, flag.counter - 1) -- decrement the counter if the flags match
                end
            end
        end
    end
end

-- give a new quest to this quest manager, return true if received, false otherwise
function QuestManager:giveQuest(quest)
    if #self.quests < QUEST_LIMIT then
        table.insert(self.quests, quest) -- if there is room, add the quest
        return true
    end
    return false
end

-- return a string with a list of the flags in this quest and their remaining progress to completion
function QuestManager:getProgressString(quest)
    local string = '' 
    for i, flag in ipairs(quest.flags) do
        if i > 1 then -- add a comma separator if this is not the first item
            string = string .. ', '
        end
        string = string .. flag.name .. ' (' .. flag.counter .. ' remaining)' -- add each flag and its counter to the string
    end
    return string .. '.'
end