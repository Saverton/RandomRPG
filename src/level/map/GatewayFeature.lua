--[[
    Gateway class: Type of feature that transports the player on contact.
    @author Saverton
]]

GatewayFeature = Class{__includes = Feature}

function GatewayFeature:init(name, x, y, destination, active)
    Feature.init(self, name, x, y) 
    self.destination = destination
    self.active = active or true
end

function GatewayFeature:onEnter(level)
    self.active = false
    print('destination in practice = ' .. self.destination)
    gStateStack:push(SaveState(level, self.destination))
end