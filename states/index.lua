local state = {}
local loginButton, registerButton
local config = require("config")

function state.load()
	local Button = require("button")

	loginButton = Button(2, 1, 300, 100, "Login", "")
	registerButton = Button(2, 2, 300, 100, "Register", "")

	loginButton.selected = true

	love.keyboard.setKeyRepeat(true)
end

function state.textinput(t) end

function state.keypressed(key, scancode, isrepeat, switchState)
	if scancode == "up" or scancode == "down" then -- move down
		if loginButton.selected == false then
			loginButton.selected = true
			registerButton.selected = false
			config.sounds.minimal[1]:clone():play()
		else
			loginButton.selected = false
			registerButton.selected = true
			config.sounds.minimal[2]:clone():play()
		end
	elseif scancode == "return" or scancode == "space" then
		if registerButton.selected == true then
			switchState("register")
			config.sounds.enter:clone():play()
		end
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.big)
	loginButton:draw()
	registerButton:draw()
end

return state
