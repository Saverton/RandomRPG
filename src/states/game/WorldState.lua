--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(definitions)
    self.name = definitions.name or 'my world' -- world name
    self.level = definitions.level -- level to start in
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
            self.level.player:getItem(Item('sword', self.level.player, 1))
            self.level.player:getItem(Item('bow', self.level.player, 1))
            self.level.player:getItem(Item('fire_tome', self.level.player, 1))
        end
        if love.keyboard.wasPressed('m') then -- give player 10 money when press m
            self.level.player:getItem(Item('money', self.level.player, 10))
        end
    end
    if love.keyboard.wasPressed('escape') then -- pause game if pressed escape
        gStateStack:push(MenuState(Menu(MENU_DEFS['pause']), {parent = self.level}))
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

-- leave the world, reset timer
function WorldState:exit()
    Timer.clear()
end