--[[
    Quest class: contains a quest for the player to complete, then receive an award.
    @author Saverton
]]

Quest = Class{}

function Quest:init(def, diff, npc)
    self.npc = npc

    self.rewards = def.rewards or self:GenerateReward(diff)
    self.quest = def.quest or self:GenerateQuest(diff)
    self.completed = false
    self.denied = false

    self.startText = (def.startText or 'Can you do a job for me?') .. self:stringQuest()
    self.endText = (def.endText or 'Thank You! Here is a reward:') .. self:stringReward()
    self.acceptText = def.acceptText or 'Thanks! Speak to me as soon as you are done!'
    self.refuseText = def.refuseText or 'Pity! Now I have to fade away into nothingness.'
    self.ongoingText = (def.ongoingText or 'Oh, it seems you already have my quest. Here is a reminder: ') .. self:stringQuest()
end

function Quest:check(player)
    if not ContainsName(player.quests, self.quest.name) then
        gStateStack:push(DialogueState(self.startText, self.npc.animations['idle-down'].texture, 1))
        gStateStack:push(ConfirmState(MENU_DEFS['quest_confirm'], {
            onConfirm = function() 
                gStateStack:pop()
                if player:giveQuest(self.quest) then
                    gStateStack:push(DialogueState(self.acceptText, self.npc.animations['idle-down'].texture, 1))
                else
                    gStateStack:push(DialogueState('You can only have ' .. tostring(QUEST_LIMIT) .. ' active quests!', self.npc.animations['idle-down'].texture, 1))
                end
            end,
            onDeny = function()
                gStateStack:pop()
                self.denied = true
                gStateStack:push(DialogueState(self.refuseText, self.npc.animations['idle-down'].texture, 1))
            end
        }))
    elseif self:checkCompletion(player) then
        self:reward(player)
        self.completed = true
        gStateStack:push(DialogueState(self.endText, self.npc.animations['idle-down'].texture, 1))
        return
    else
        gStateStack:push(DialogueState(self.ongoingText, self.npc.animations['idle-down'].texture, 1))
        gStateStack:push(DialogueState(self.startText, self.npc.animations['idle-down'].texture, 1))
    end
end

function Quest:checkCompletion(player)
    local index = GetIndex(player.quests, self.quest.name)
    for i, flag in pairs(player.quests[index].flags) do
        if flag.counter > 0 then
            return false
        end
    end
    return true
end

function Quest:reward(player)
    for i, reward in pairs(self.rewards) do
        player:getItem(Item(reward.name, player, reward.quantity))
    end
end

function Quest:GenerateQuest(diff)
    local quest = {
        name = self.npc.npcName .. '\'s ' .. QUEST_TITLES[math.random(#QUEST_TITLES)],
        flags = {},
        questRef = self
    }
    local numOfFlags = math.random(1, diff)

    for i = 1, numOfFlags, 1 do
        table.insert(quest.flags, {flag = QUEST_FLAGS[math.random(#QUEST_FLAGS)], counter = math.random(2 * diff)})
    end

    return quest
end

function Quest:GenerateReward(diff)
    local rewards = {}
    local numOfRewards = math.random(1, diff) 

    for i = 1, numOfRewards, 1 do
        local name = QUEST_REWARDS[math.random(#QUEST_REWARDS)]
        local quantity = 1
        if ITEM_DEFS[name].stackable then
            quantity = math.random(5)
        end
        table.insert(rewards, {name = name, quantity = quantity})
    end

    return rewards
end

function Quest:stringQuest()
    local string = ' ' 

    for i, flag in pairs(self.quest.flags) do
        if i > 1 then
            string = string .. ', '
        end
        string = string .. flag.flag .. ' ' .. flag.counter .. ' times'
    end
    string = string .. '.'

    return string
end

function Quest:stringReward()
    local string = ' ' 

    for i, reward in pairs(self.rewards) do
        if i > 1 then
            string = string .. ', '
        end
        string = string .. ITEM_DEFS[reward.name].displayName .. ' (' .. reward.quantity .. ')'
    end
    string = string .. '.'

    return string
end

QUEST_FLAGS = {'kill enemy', 'kill goblin'}

QUEST_REWARDS = {'ammo', 'money', 'fire_tome', 'bow', 'sword'}

QUEST_TITLES = {'Burden', 'Quest', 'Endeavor', 'Undertaking', 'Task', 'Assignment', 'Commission', 'Pursuit', 'Crusade', 'Enterprise'}