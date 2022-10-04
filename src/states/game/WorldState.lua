--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(definitions)
    self.name = definitions.name or 'my world' -- world name
    self.level = definitions.level or Overworld(self.name, 'overworld-1', {}) -- level to start in
    self.debug = definitions.debug -- true: debug features on, false: debug features off
end

-- update the world: update the level, check for input
function WorldState:update(dt) 
    self.level:update(dt)
    if self.debug then -- debug options
        if love.keyboard.wasPressed('r') then -- reload level if pressed r
            self.level = Overworld(self.name, self.level.levelName, {})
        end
        if love.keyboard.wasPressed('b') then -- give player items if pressed b
            Entity.giveItem(self.level.player, Item('sword', self.level.player, 1))
            Entity.giveItem(self.level.player, Item('bow', self.level.player, 1))
            Entity.giveItem(self.level.player, Item('fire_tome', self.level.player, 1))
            Entity.giveItem(self.level.player, Item('ammo', self.level.player, 50))
        end
        if love.keyboard.wasPressed('m') then -- give player 10 money when press m
            self.level.player:giveItem(Item('money', self.level.player, 10))
        end
        if love.keyboard.wasPressed('k') then -- give player a key
            self.level.player:giveItem(Item('key', self.level.player, 1))
        end
    end
    if love.keyboard.wasPressed('escape') then -- pause game if pressed escape
        gStateStack:push(MenuState(MENU_DEFS['pause'], {parent = self.level}))
    elseif love.keyboard.wasPressed('i') then -- open inventory if pressed i
        gStateStack:push(InventoryState(MENU_DEFS['inventory'], self.level.player))
    elseif love.keyboard.wasPressed('q') then -- open quest inventory if pressed q
        gStateStack:push(QuestState(MENU_DEFS['quest'], self.level.player))
    end
end

-- render the world
function WorldState:render()
    self.level:render()
end

function WorldState:exit()
    self.level.music:stop()
end