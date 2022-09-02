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
    -- pause if pressed escape
    if love.keyboard.wasPressed('escape') then
        gStateStack:push(MenuState(
            Menu(
                MENU_DEFS['pause'].x, MENU_DEFS['pause'].y, MENU_DEFS['pause'].width, MENU_DEFS['pause'].height,
                MENU_DEFS['pause'].title, MENU_DEFS['pause'].selections
            )
        ))
    end
end

function WorldState:render()
    self.level:render()
end