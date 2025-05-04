local state = {}
local backToMain, enterRegister
local registerUsernameField, registerPasswordField
local usernameExistsErr, usernameExistsErrBool, registerSuccess, registerSuccessBool
local registerTableButtons = {}
local registerPointer
local config = require("config")
local auth = require("api.auth")
local text = require("text")

function state.load()
	Object = require("classic")
	local Button = require("button")
	local hidden = require("hidden")
	local alert = require("alert")

	backToMain = Button(4, 1, 300, 100, "Back", "")
	backToMain.selected = true
	enterRegister = Button(4, 4, 300, 100, "Enter", "")

	registerUsernameField = Button(4, 2, 600, 100, "", "Username")
	registerPasswordField = hidden(4, 3, 600, 100, "", "Password")

	usernameExistsErr = alert(1, 1, 500, 100, "Account already exists!", "")
	usernameExistsErr:setColor(255, 0, 0)
	usernameExistsErrBool = false

	registerSuccess = alert(1, 1, 500, 100, "Account created!", "")
	registerSuccess:setColor(0, 255, 0)
	registerSuccessBool = false

	registerTableButtons = { backToMain, registerUsernameField, registerPasswordField, enterRegister }
	registerPointer = 1
end

function state.textinput(t)
	if registerUsernameField.selected then
		config.typing()
		if string.len(registerUsernameField.text) < 20 then
			registerUsernameField.text = registerUsernameField.text .. t
		end
	elseif registerPasswordField.selected then
		config.typing()
		registerPasswordField.text = registerPasswordField.text .. t
	end
end

function state.keypressed(key, scancode, isrepeat, switchState)
	usernameExistsErrBool = false
	registerSuccessBool = false
	if scancode == "up" then
		registerTableButtons[registerPointer].selected = false

		if registerPointer == 1 then
			registerPointer = 4
		else
			registerPointer = registerPointer - 1
		end

		registerTableButtons[registerPointer].selected = true
		config.sounds.minimal[registerPointer]:clone():play()
	elseif scancode == "down" then
		registerTableButtons[registerPointer].selected = false

		if registerPointer == 4 then
			registerPointer = 1
		else
			registerPointer = registerPointer + 1
		end

		registerTableButtons[registerPointer].selected = true
		config.sounds.minimal[registerPointer]:clone():play()
	elseif scancode == "space" or scancode == "return" then
		if backToMain.selected then
			switchState("menu")
			config.sounds.enter:clone():play()
		elseif enterRegister.selected then
			local responseText, code = auth.register(registerUsernameField.text, registerPasswordField.text)
			print("Status Code:", code)
			print("Response:", responseText)

			if responseText == "exists" then
				usernameExistsErrBool = true
			elseif responseText == "success" then
				registerSuccessBool = true
			end
		end
	elseif scancode == "backspace" then
		if registerUsernameField.selected then
			config.sounds.back:clone():play()
			registerUsernameField.text = registerUsernameField.text:sub(1, -2)
		elseif registerPasswordField.selected then
			config.sounds.back:clone():play()
			registerPasswordField.text = registerPasswordField.text:sub(1, -2)
		end
	end
end

function state.update(dt)
	registerUsernameField:update()
	registerPasswordField:update()
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	text.printext("Register", 2, 1)
	love.graphics.setFont(config.fonts.big)

	backToMain:draw()
	registerUsernameField:draw()
	registerPasswordField:draw()
	enterRegister:draw()

	if usernameExistsErrBool == true then
		usernameExistsErr:draw()
	elseif registerSuccessBool then
		registerSuccess:draw()
	end
end

return state
