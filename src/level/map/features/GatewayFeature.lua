--[[
    Gateway class: Type of feature that transports the player on collide.
    @author Saverton
]]

GatewayFeature = Class{__includes = Feature}

function GatewayFeature:init(name, destination)
    Feature.init(self, name) 
    self.destination = destination -- the destination level that the feature transports the player to
    self.active = false -- if true, the feature transports the player on contact
    Timer.after(2, function() self.active = true end) -- after 2 seconds set active to prevent the player being continuously transported back and forth
end

-- function called when the feature is collided with and the entity is a player, transports the player to the destination
function GatewayFeature:onEnter(level)
    self.active = false
    level:stopMusic() -- stop the music
    gSounds['world']['enter_gateway']:play()
    gStateStack:push(ConvergePointState({x = level.player.x + level.player.width / 2 - level.camera.x, 
        y = level.player.y + level.player.height / 2 - level.camera.y},
        {0, 0, 0, 1}, 1.5, function() 
            gStateStack:pop() -- remove existing world
            gStateStack:push(SaveState(level, self.destination)) 
        end))
end