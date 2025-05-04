local buttonManager = {}
local pointer = 1
local totalNum = 1
local buttons = {}
local config = require("config")

function buttonManager.setUp(tableOfButtons, amount)
	buttons = tableOfButtons
	totalNum = amount

	pointer = 1
	buttons[pointer].selected = true
end

function buttonManager.down()
	buttons[pointer].selected = false

	if not (pointer == totalNum) then
		pointer = pointer + 1
	end

	buttons[pointer].selected = true
	config.sounds.minimal[1]:clone():play()
end

function buttonManager.up()
	buttons[pointer].selected = false

	if not (pointer == 1) then
		pointer = pointer - 1
	end

	buttons[pointer].selected = true
	config.sounds.minimal[2]:clone():play()
end

return buttonManager
