--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(map, entities, player)
    self.map = map
    self.entities = entities
    
    self.player = player
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player, self) end
    })
    self.player.stateMachine:change('idle', self.player)
    self.player.level = self

    self.camera = Camera(player, self)
end

function Level:update(dt)
    self.map:update(dt)

    for i, entity in pairs(self.entities) do
        entity:update(dt)
    end

    self.player:update(dt)

    self.camera:update()
end

function Level:render()
    self.map:render(self.camera)

    for i, entity in pairs(self.entities) do
        if entity:collides(self.camera.cambox) then
            entity:render(self.camera)
        end
    end

    self.player:render(self.camera)
end