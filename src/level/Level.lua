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
    self.camera = Camera(player)
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