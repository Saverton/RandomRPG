--[[
    Death Animation State: the brief state of the game that plays the player's death animation on game over.
    @author Saverton
]]

DeathAnimationState = Class{__includes = BaseState}

function DeathAnimationState:init(player, x, y)
    self.x = x
    self.y = y
    self.animation = player.animator
    self.backgroundOpacity = 0
    self.updateAnimation = false

    Timer.after(1, function()
        self.animation:changeAnimation('spin')
        self.updateAnimation = true
        Timer.tween(2, {
            [self] = {backgroundOpacity = 1}
        }):finish(function()
            Timer.tween(1, {
                [self] = {y = -30}
            }):finish(function()
                gStateStack:push(GameOverState())
                print('popped')
            end)
        end)
    end)
end

function DeathAnimationState:update(dt)
    if self.updateAnimation then
        self.animation:update(dt)
    end
end

function DeathAnimationState:render()
    love.graphics.setColor(0.5, 0, 0, self.backgroundOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    self.animation:render(self.x, self.y)
end