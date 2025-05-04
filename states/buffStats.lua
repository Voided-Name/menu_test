local state = {}
local attackButton, speedButton, defenseButton, helpButton
local config = require("config")
local buttonManager = require("buttonManager")

function state.load()
	attackButton = Button(4, 1, 500, 100, "Finger Muscles (+Atk)", "")
	speedButton = Button(4, 2, 500, 100, "Finger Agility (+Spd)", "")
	defenseButton = Button(4, 3, 500, 100, "Finger Callus (+Def)", "")
	helpButton = Button(4, 4, 500, 100, "Help", "")

	buttonManager.setUp({ attackButton, speedButton, defenseButton, helpButton }, 4)
end

function state.keypressed(key, scancode, isrepeat, switchState, user_id)
	if scancode == "up" then
		buttonManager.up()
	elseif scancode == "down" then
		buttonManager.down()
	elseif scancode == "space" or scancode == "return" then
		if attackButton.selected then
			switchState("atkTraining")
		elseif speedButton.selected then
			switchState("speedTraining")
		elseif defenseButton.selected then
			switchState("defenseTraining")
		elseif helpButton.selected then
			switchState("statsHelp")
		end
	elseif scancode == "escape" then
		switchState("playMenu")
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	love.graphics.setFont(config.fonts.big)

	attackButton:draw()
	speedButton:draw()
	defenseButton:draw()
	helpButton:draw()
end

return state
