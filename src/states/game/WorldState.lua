--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(defs)
    self.level = defs.level or Level(defs.name or 'my world')

    self.debug = defs.debug
end

function WorldState:update(dt) 
    self.level:update(dt)

    -- debug options
    if self.debug then
        -- reload level if pressed r
        if love.keyboard.wasPressed('r') then
            self.level = Level('test')
        end
        -- give player items if pressed b
        if love.keyboard.wasPressed('b') then
            self.level.player:getItem(Item('sword', self.level.player, 1))
            self.level.player:getItem(Item('bow', self.level.player, 1))
            self.level.player:getItem(Item('fire_tome', self.level.player, 1))
        end
        -- give player 10 money when press m
        if love.keyboard.wasPressed('m') then
            self.level.player:getItem(Item('money', self.level.player, 10))
        end
    end

    -- pause if pressed escape
    if love.keyboard.wasPressed('escape') then
        gStateStack:push(MenuState(Menu(MENU_DEFS['pause']), {parent = self.level}))
    elseif love.keyboard.wasPressed('i') then
        gStateStack:push(InventoryState(MENU_DEFS['inventory'], self.level.player))
    elseif love.keyboard.wasPressed('q') then
        gStateStack:push(QuestState(MENU_DEFS['quest'], self.level.player))
    end
end

function WorldState:render()
    self.level:render()
end

function WorldState:exit()
    Timer.clear()
end