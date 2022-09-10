--[[
    Gateway class: Type of feature that transports the player on contact.
    @author Saverton
]]

GatewayFeature = Class{__includes = Feature}

function GatewayFeature:init(name, destination, active)
    Feature.init(self, name) 
    self.destination = destination
    self.active = false
    Timer.after(2, function() self.active = true end)
end

function GatewayFeature:onEnter(level)
    self.active = false
    gStateStack:push(SaveState(level, self.destination))
end