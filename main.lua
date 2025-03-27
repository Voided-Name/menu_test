local currentState
local config = require("config")

local function switchState(stateName)
	local states = {
		menu = require("states.index"),
		register = require("states.register"),
	}
	currentState = states[stateName]
	if not currentState._loaded then
		currentState.load()
		currentState._loaded = true
	end
end

function love.load()
	Object = require("classic")
	local Button = require("button")
	local hidden = require("hidden")
	local alert = require("alert")

	switchState("menu")

	config.sounds.mainMusic:isLooping()
	config.sounds.mainMusic:setVolume(0.4)
	config.sounds.mainMusic:play()

	love.keyboard.setKeyRepeat(true)
end

function love.textinput(t)
	currentState.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
	if currentState.keypressed then
		currentState.keypressed(key, scancode, isrepeat, switchState)
	end
end

function love.update(dt)
	if currentState.update then
		currentState.update(dt)
	end
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)

	if currentState.draw then
		currentState.draw()
	end
end
