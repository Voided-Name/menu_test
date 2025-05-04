local wordManager = {}
local words = require("words")
local config = require("config")
local word = ""
local pointer = 0
local completed = false

function wordManager.getState()
	return completed
end

local function get_length_range(length_label)
	local ranges = {
		short = { 2, 4 },
		medium = { 5, 7 },
		long = { 8, 10 },
		longest = { 11, 14 },
	}

	local range = ranges[length_label]
	if not range then
		return nil -- or error("Invalid length label")
	end

	return math.random(range[1], range[2])
end

function wordManager.loadWord(length)
	word = words.get_random(get_length_range(length))
	pointer = 0

	completed = false
end

function wordManager.input(text)
	print(text)
	if text == string.sub(word, pointer + 1, pointer + 1) then
		pointer = pointer + 1
		config.typing()
	else
		config.sounds.back:clone():play()
	end

	print("Pointer Value: " .. pointer)
	print("String word: " .. string.len(word))

	if pointer == string.len(word) then
		completed = true
	end
end

function wordManager.draw()
	love.graphics.setFont(config.fonts.big)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), 100)
	love.graphics.setColor(255, 255, 255, 0.5)

	love.graphics.print(
		word,
		love.graphics.getWidth() / 2 - config.fonts.big:getWidth(word) / 2,
		(love.graphics.getHeight() / 2) - config.fonts.big:getHeight() / 2
	)

	love.graphics.setColor(255, 255, 255, 0.5)

	love.graphics.print(
		string.sub(word, 1, pointer),
		love.graphics.getWidth() / 2 - config.fonts.big:getWidth(word) / 2,
		(love.graphics.getHeight() / 2) - config.fonts.big:getHeight() / 2
	)
end

return wordManager
