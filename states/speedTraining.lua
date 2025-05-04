local state = {}
local manageUser = require("api.manageUser")
local buttonManager = require("buttonManager")
local config = require("config")
local alert = require("alert")
local wordManager = require("gameplay.wordState")
local session = require("session_manager")
local timer = require("timer")
local counter, total
local alertLevel, alertLevelBool
local typeTimer

local base_time = 3
local min_time = 0.5
local difficulty = 0.15

require("print_r")

local function fibonacci(n)
	if n <= 0 then
		return 0
	end
	if n == 1 then
		return 1
	end

	local a, b = 0, 1
	for i = 2, n do
		a, b = b, a + b
	end
	return b
end

local function calculateSetTime()
	local wordCount = fibonacci(session["currentChar"]["stats"]["speed"])
	local timePerWord = base_time * math.exp(-difficulty * session["currentChar"]["stats"]["speed"])
	timePerWord = math.max(min_time, timePerWord)
	return timePerWord * wordCount
end

function state.load()
	wordManager.loadWord("short")
	counter = 0
	total = fibonacci(session["currentChar"]["stats"]["speed"])

	typeTimer = timer(10, calculateSetTime())

	alertLevel = alert(1, 1, 500, 100, "Level Up!", "")
	alertLevel:setColor(0, 255, 0)
	alertLevelBool = false
end

function state.textinput(t)
	if alertLevelBool == true then
		alertLevelBool = false
		return
	end

	print(t)
	wordManager.input(t)

	print("Word Manage State: ")
	print(wordManager.completed)

	if wordManager.getState() then
		wordManager.loadWord("short")
		counter = counter + 1
		if counter == total then
			local response, code = manageUser.modifyStat(session["user_id"], session["currentChar"]["id"], "speed", 1)

			if response["status"] == "success" then
				print("status success")

				local response_2, code_2 = manageUser.getCharacter(session["currentChar"]["id"])
				session["currentChar"]["stats"] = response_2[1]["stats"]

				alertLevelBool = true
			end

			counter = 0
			total = fibonacci(session["currentChar"]["stats"]["speed"])
			typeTimer = timer(20, calculateSetTime())
		end
	end
end

function state.keypressed(key, scancode, isrepeat, switchState, session)
	if alertLevelBool == true then
		alertLevelBool = false
		return
	end

	if scancode == "escape" then
		switchState("buffStats")
	end
end

function state.update(dt)
	typeTimer:update(dt)

	if typeTimer.finished then
		counter = 0
		typeTimer = timer(20, calculateSetTime())
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	love.graphics.setFont(config.fonts.big)
	love.graphics.print(counter .. "/" .. total)

	wordManager.draw()

	typeTimer:draw()

	if alertLevelBool then
		alertLevel:draw()
	end
end

return state
