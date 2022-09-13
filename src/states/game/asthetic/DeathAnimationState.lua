--[[
    Death Animation State: the brief state of the game that plays the player's death animation on game over.
    @author Saverton
]]

DeathAnimationState = Class{__includes = BaseState}

function DeathAnimationState:init(player, x, y)
    self.x, self.y = x, y -- the position to display the death animation
    self.animation = player.animator -- reference to the player's animator
    self.backgroundOpacity = 0 -- opacity of the background, fades to red in animation
    self.updateAnimation = false -- whether or not to update the current animation
    self.renderPlayerExtra = true -- whether or not to render the large eyes and sweat on the dead player
    self.extraAnimation = Animation('player_death', player.direction) -- the animation of the eyes and sweat drawn on the player

    Timer.after(1, function() -- after one second, start the spinning animation and fade to dark red
        self.animation:changeAnimation('spin')
        self.updateAnimation = true
        self.renderPlayerExtra = false
        Timer.tween(2, {
            [self] = {backgroundOpacity = 1}
        }):finish(function() -- after another 2 seconds, have the player rise to the top of the screen and push the game over screen
            Timer.tween(1, {
                [self] = {y = -30}
            }):finish(function()
                gStateStack:push(GameOverState())
            end)
        end)
    end)
end

-- update the death animation if the animation is set to update
function DeathAnimationState:update(dt)
    if self.updateAnimation then
        self.animation:update(dt)
    end
end

-- render the death animation screen
function DeathAnimationState:render()
    love.graphics.setColor(0.5, 0, 0, self.backgroundOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT) -- red background
    love.graphics.setColor(1, 1, 1, 1)
    self.animation:render(self.x, self.y) -- player
    if self.renderPlayerExtra then
        self.extraAnimation:render(self.x, self.y) -- player's eyes and sweat
    end
end