--[[
	State Machine: manages entity states by transferring between states

	@author Saverton
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		processAI = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render(x, y)
	self.current:render(x, y)
end

--[[
	Used for states that can be controlled by the AI to influence update logic.
]]
function StateMachine:processAI(params, dt)
	self.current:processAI(params, dt)
end

--[[
	add a new state to the state machine.
]]
function StateMachine:addState(name, state)
	self.states[name] = state
end