--[[
    Quest class: contains a quest for the player to complete, then receive an award.
    @author Saverton
]]

Quest = Class{}

function Quest:init(def, npc)
    self.npc = npc

    self.startText = def.startText or 'Can you kill 1 Goblin?'
    self.endText = def.endText or 'Thank You!'
    self.refuseText = def.refuseText or 'Oh, it seems you already have my quest.'

    self.rewards = def.rewards or {{name = 'ammo', quantity = 5}, {name = 'money', quantity = 5}}
    self.quest = def.flags or {name = 'goblin', flags = {{flag = 'kill goblin', counter = 1}}}
    self.completed = false
end

function Quest:check(player)
    if not ContainsName(player.quests, self.quest.name) then
        table.insert(player.quests, self.quest)
    elseif self:checkCompletion(player) then
        self:reward(player)
        self.completed = true
        gStateStack:push(DialogueState(self.endText, self.npc.animations['idle-down'].texture, 1))
    else
        gStateStack:push(DialogueState(self.refuseText, self.npc.animations['idle-down'].texture, 1))
    end

    gStateStack:push(DialogueState(self.startText, self.npc.animations['idle-down'].texture, 1))
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