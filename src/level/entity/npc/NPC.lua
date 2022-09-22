--[[
    NPC Class: NPC specific behavior for entities, has a special name, an interact function, a flag for the amount of times its been
        interacted with, and a function to check if it is despawnable.
    @author Saverton
]]

NPC = Class{__includes = Entity}

function NPC:init(level, definitions, position, manager)
    Entity.init(self, level, definitions, position) -- initiate the entity components
    self.manager = manager -- reference to the npc manager
    self.npcName = NPC_NAMES[math.random(#NPC_NAMES)] -- choose a random name from the list of npc names (constants)
    self.timesInteractedWith = 0
    if NPC_DEFS[self.name].hasShop then -- create a shop object for this npc to own.
        self.shop = Shop(definitions.shop, self) 
    elseif NPC_DEFS[self.name].hasQuest then -- create a quest object with a random difficulty level for this NPC to own
        self.quest = Quest(definitions.quest or {}, math.random(1, 3), self) 
    end
    self.stateMachine = StateMachine({
        ['idle'] = function() return NPCIdleState(self) end,
        ['walk'] = function() return NPCWalkState(self) end
    }) -- instantiate and set new stateMachine
    self:changeState('idle')
    self.despawnTimer = -1 -- timer for npc fade out animation
    self.aiSubType = 'wander'
end

-- update all npc components
function NPC:update(dt)
    Entity.update(self, dt) -- update entity components
    self:updateDespawn(dt) -- checks for despawnable or updates the despawn timer
end

-- draw the NPC on screen
function NPC:render(camera)
    if self.despawnTimer > 0 then -- if the npc is despawning, change the opacity to have it fade out
        love.graphics.setColor(1, 1, 1, (self.despawnTimer / DESPAWN_TIMER))
    end
    Entity.render(self, camera) -- draw entity
end

-- start the despawn timer countdown
function NPC:despawn()
    self.despawnTimer = DESPAWN_TIMER
end

-- update any components related to the npc's despawn
function NPC:updateDespawn(dt)
    if self.despawnTimer > 0 then -- countdown if the despawn timer is running
        self.despawnTimer = math.max(self.despawnTimer - dt, 0)
    elseif self.despawnTimer == 0 then -- clear from manager if despawn timer is done
        self.manager:clearDespawned()
    elseif NPC_DEFS[self.name].isDespawnable(self) then -- otherwise check if it is despawnable
        self:despawn()
    end
end

-- called when player interacts with the npc, calls the npc's unique onInteract function and increments timesInteractedWith
function NPC:interact(player)
    NPC_DEFS[self.name].onInteract(player, self) -- call onInteract function
    self.timesInteractedWith = self.timesInteractedWith + 1
end

-- returns the npc's speed, used to shorted code in Entity class
function NPC:getSpeed()
    return (self.speed) 
end

-- return a string with the npcs's name followed by its job/functionality
function NPC:getDisplayMessage()
    return (self.npcName .. ' the ' .. NPC_DEFS[self.name].displayName)
end