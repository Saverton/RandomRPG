--[[
    Quest class: contains a quest for the player to complete, then receive an award.
    @author Saverton
]]

Quest = Class{}

function Quest:init(def, npc)
    self.npc = npc

    self.startText = 'Can you kill 1 Goblin?'
    self.endText = 'Thank You!'
    self.refuseText = 'Oh, it seems you already have my quest.'

    self.rewards = def.rewards
    self.flags = def.flags or {name = 'goblin', {flag = 'kill goblin', counter = 1}}
    self.completed = false
end

function Quest:check(player)
    if not Contains(player.quests, self.flags) then
        table.insert(player.quests, self.flags)
    elseif self:checkCompletion(player) then
        self:reward(player)
        self.completed = true
        gStateStack:push(DialogueState(self.endText, self.npc.animations['idle-down'], 1))
    else
        gStateStack:push(DialogueState(self.refuseText, self.npc.animations['idle-down'], 1))
    end

    gStateStack:push(DialogueState(self.startText, self.npc.animations['idle-down'], 1))
end

function Quest:checkCompletion(player)
    local index = GetIndex(player.quests, self.flags.name)
    for i, flag in pairs(player.quests[index]) do
        if flag.counter > 0 then
            return false
        end
    end
    return true
end

function Quest:reward(player)
    for i, reward in pairs(self.rewards) do
        player:getItem(reward)
    end
end