--[[
    Quest class: defines behavior for quests that the player can complete for a reward, held by npcs.
    @author Saverton
]]

Quest = Class{}

function Quest:init(definitions, difficulty, npc)
    self.npc = npc -- reference to owner
    self:getRequirements(definitions, difficulty)
    self.rewards = definitions.rewards or self:GenerateReward(difficulty) -- reward for completing the quest
    self.completed = false -- if the quest was completed
    self.denied = false -- if the quest was denied by the player
    self.text = definitions.text or {
        start = 'Can you do a job for me?', -- when the quest is introduced
        finish = 'Thank You! Here is a reward:', -- when the quest is completed
        accept = 'Thanks! Speak to me as soon as you are done!', -- when the quest is accepted
        deny = 'Pity! Now I have to fade away into nothingness.', -- when the quest is denied
        ongoing = 'Oh, it seems you already have my quest. Here is what remains: ' -- when the quest is already accepted, but not completed
    }
end

-- generate or load in the existing quest requirements for this quest
function Quest:getQuest(definitions, difficulty)
    if definitions.quest ~= nil then -- load in existing requirements
        self.quest = {name = definitions.quest.name, flags = definitions.quest.flags, questRef = self}
        -- if the player has undertaken this quest already, it needs a reference to this quest being loaded in
        local player = self.npc.level.player
        for i, quest in ipairs(player.quests) do
            if quest.name == self.quest.name then
                quest.questRef = self -- if the name of this quest matches with any of the player's held quests, add a reference to this.
            end
        end
    else -- generate new requirements
        self.quest = self:GenerateQuest(difficulty)
    end
end

-- check for the status of the quest with the player
function Quest:check(player)
    if self.npc.timesInteractedWith == 0 then
        self:introduce(player) -- introduce player to quest
    elseif self:checkCompletion(player) then
        self:reward(player) -- player has completed, reward and set as complete
    else -- player has quest, but not completed, show ongoing text
        self:remind()
    end
end

-- ask the player to accept this quest, if yes, then add it to the player's list
function Quest:introduce(player)
    gStateStack:push(DialogueState(self.text.start .. self:getRequirementString(), self.npc.animator.texture, 1, function()
        gStateStack:push(ConfirmState(MENU_DEFS['quest_confirm'], { -- ask to confirm acceptance of this quest
            onConfirm = function() 
                if player:giveQuest(self.quest) then -- give the player the quest, show accept text
                    gStateStack:push(DialogueState(self.text.accept, self.npc.animator.texture, 1))
                else -- player can't take any more quests, auto deny but no despawn
                    gStateStack:push(DialogueState('You can only have ' .. tostring(QUEST_LIMIT) .. ' active quests!', 
                    self.npc.animator.texture, 1))
                end
            end,
            onDeny = function()
                self.denied = true -- set quest as denied
                gStateStack:push(DialogueState(self.text.deny, self.npc.animator.texture, 1))
            end
        }))
    end))
end

-- remind the player that it already has undertaken this quest.
function Quest:remind()
    gStateStack:push(DialogueState(self.text.ongoing .. self:getRequirementString(), self.npc.animator.texture, 1))
end

-- reward the player for completing the quest, set as complete, and display finish text
function Quest:reward(player)
    for i, reward in pairs(self.rewards) do -- give each of the rewards to the player.
        player:getItem(Item(reward.name, player, reward.quantity))
    end
    table.remove(player.quests, GetIndex(player.quests, self.quest.name)) -- remove the quest from the player's quest list.
    self.completed = true -- set the quest as complete
    gStateStack:push(DialogueState(self.text.finish .. self:getRewardString(), self.npc.animator.texture, 1)) -- show finishtext
end

-- return true if the quest is completed, false otherwise
function Quest:checkCompletion(player)
    local quest = player.questManager.quests[GetIndex(player.questManager.quests, self.quest.name)] -- reference to this quest in the player's quest tracker
    for i, flag in pairs(quest.flags) do
        if flag.counter > 0 then -- check each flag, if it's counter is greater than 0, then return false
            return false
        end
    end
    return true
end

-- generate a new quest with a given difficulty
function Quest:GenerateQuest(difficulty)
    local quest = {
        name = self.npc.npcName .. '\'s ' .. QUEST_TITLES[math.random(#QUEST_TITLES)], -- generate a random name for the quest
        flags = {},
        questRef = self -- reference to the actual quest object
    }
    local numOfFlags = math.random(1, difficulty) -- choose number of requirements based on difficulty
    for i = 1, numOfFlags, 1 do -- insert randomly generated flags to the quest requirements with counters based on difficulty
        table.insert(quest.flags, {name = QUEST_FLAGS[math.random(#QUEST_FLAGS)], counter = math.random(2 * difficulty)})
    end
    return quest
end

-- generate a reward for the quest based on the difficulty
function Quest:GenerateReward(difficulty)
    local rewards = {}
    local numOfRewards = math.random(1, difficulty) -- number of rewards based on difficulty
    for i = 1, numOfRewards, 1 do
        local name = QUEST_REWARDS[math.random(#QUEST_REWARDS)] -- choose a random reward
        local quantity = 1
        if ITEM_DEFS[name].stackable then
            quantity = math.random(5) -- if stackable, can have between 1 and 5
        end
        table.insert(rewards, {name = name, quantity = quantity}) -- add the reward
    end
    return rewards
end

-- return a string with a list of the quest's requirements (flags)
function Quest:getRequirementString()
    local string = ' ' 
    for i, flag in pairs(self.quest.flags) do
        if i > 1 then
            string = string .. ', ' -- add comma if not first index
        end
        string = string .. flag.flag .. ' ' .. flag.counter .. ' times' -- ex: kill goblin 3 times
    end
    string = string .. '.'
    return string
end

-- return a string with a list of the quest's rewards
function Quest:getRewardString()
    local string = ' ' 
    for i, reward in pairs(self.rewards) do
        if i > 1 then
            string = string .. ', ' -- add comma if not first index
        end
        string = string .. ITEM_DEFS[reward.name].displayName .. ' (' .. reward.quantity .. ')' -- ed: ammo (3)
    end
    string = string .. '.'
    return string
end

-- list of potential flags to mark a quest
QUEST_FLAGS = {'kill enemy', 'kill goblin', 'kill skeleton'}
-- list of potential rewards for a quest
QUEST_REWARDS = {'ammo', 'money', 'fire_tome', 'ice_tome', 'bow', 'sword', 'battle_axe', 'hp_upgrade'}
-- list of possible titles for a quest
QUEST_TITLES = {'Burden', 'Quest', 'Endeavor', 'Undertaking', 'Task', 'Assignment', 'Commission', 'Pursuit', 'Crusade', 'Enterprise'}