--[[
    Gateway class: Type of feature that transports the player on contact.
    @author Saverton
]]

GatewayFeature = Class{__includes = Feature}

function GatewayFeature:init(name, destination)
    Feature.init(self, name) 
    self.destination = destination
    self.active = false
    Timer.after(2, function() self.active = true end)
end

function GatewayFeature:onEnter(level)
    self.active = false
    gSounds['world']['enter_gateway']:play()
    gStateStack:push(ConvergePointState({x = level.player.x + level.player.width / 2 - level.camera.x, 
        y = level.player.y + level.player.height / 2 - level.camera.y},
        {0, 0, 0, 1}, 1.5, function() gStateStack:push(SaveState(level, self.destination)) end))
end