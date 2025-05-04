local currentState
local config = require("config")
local session = require("session_manager")

local function switchState(stateName)
	local states = {
		menu = require("states.index"),
		register = require("states.register"),
		login = require("states.login"),
		playMenu = require("states.playMenu"),
		buffStats = require("states.buffStats"),
		charSelect = require("states.charSelect"),
		createNewCharacter = require("states.createNewCharacter"),
		atkTraining = require("states.atkTraining"),
		speedTraining = require("states.speedTraining"),
		defenseTraining = require("states.defTraining"),
		statsHelp = require("states.statsHelp"),
		fight = require("states.fight"),
		shop = require("states.shop"),
		inventory = require("states.inventory"),
	}
	currentState = states[stateName]

	currentState.load()
end

function love.load()
	math.randomseed(os.time())

	Object = require("classic")
	local Button = require("button")
	local hidden = require("hidden")
	local alert = require("alert")
	local timer = require("timer")

	switchState("menu")

	config.sounds.mainMusic:setVolume(0.3)
	config.sounds.mainMusic:play()
	config.sounds.mainMusic:isLooping()

	love.keyboard.setKeyRepeat(true)
end

function love.textinput(t)
	if currentState.textinput then
		currentState.textinput(t)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if currentState.keypressed then
		currentState.keypressed(key, scancode, isrepeat, switchState, session)
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
