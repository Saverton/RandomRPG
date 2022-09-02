--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(defs)
    self.level = defs.level or Level()
end

function WorldState:update(dt) 
    self.level:update(dt)

    -- reload level if pressed r
    if love.keyboard.wasPressed('r') then
        self.level = Level()
    end
    -- give player items if pressed b
    if love.keyboard.wasPressed('b') then
        self.level.player:getItem(Item('sword', self.level.player, 1))
        self.level.player:getItem(Item('bow', self.level.player, 1))
        self.level.player:getItem(Item('fire_tome', self.level.player, 1))
    end
    -- pause if pressed escape
    if love.keyboard.wasPressed('escape') then
        gStateStack:push(MenuState(Menu(MENU_DEFS['pause']), {}))
    elseif love.keyboard.wasPressed('i') then
        gStateStack:push(InventoryState(MENU_DEFS['inventory'], self.level.player))
    end
end

function WorldState:render()
    self.level:render()
end