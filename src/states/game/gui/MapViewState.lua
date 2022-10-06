--[[
    Map View State: When the player presses 'tab' on the keyboard, the MapViewState is pushed onto the state stack. The Map View state displays a WorldMap at the center of the screen
    and listens for the escape button to be pressed such that the state will close.
    @author Saverton
]]

MapViewState = Class{__includes = BaseState}

function MapViewState:init(worldMap)
    self.worldMap = worldMap
end

-- listen for the escape key to close the state
function MapViewState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateStack:pop()
    end
end

-- render the worldMap
function MapViewState:render()
    self.worldMap:render()
end