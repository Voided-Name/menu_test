local state = {}
local backToMain, enterLogin
local loginUsernameField, loginPasswordField
local usernameExistsErr, usernameExistsErrBool, loginSuccess, loginSuccessBool
local loginTableButtons = {}
local loginPointer
local config = require("config")
local auth = require("api.auth")
local text = require("text")
local json = require("json")

function state.load()
	Object = require("classic")
	local Button = require("button")
	local hidden = require("hidden")
	local alert = require("alert")

	backToMain = Button(4, 1, 300, 100, "Back", "")
	backToMain.selected = true
	enterLogin = Button(4, 4, 300, 100, "Enter", "")

	loginUsernameField = Button(4, 2, 600, 100, "", "Username")
	loginPasswordField = hidden(4, 3, 600, 100, "", "Password")

	usernameExistsErr = alert(1, 1, 500, 100, "Failed!", "")
	usernameExistsErr:setColor(255, 0, 0)
	usernameExistsErrBool = false

	loginSuccess = alert(1, 1, 500, 100, "Account created!", "")
	loginSuccess:setColor(0, 255, 0)
	loginSuccessBool = false

	loginTableButtons = { backToMain, loginUsernameField, loginPasswordField, enterLogin }
	loginPointer = 1
end

function state.textinput(t)
	if loginUsernameField.selected then
		config.typing()
		if string.len(loginUsernameField.text) < 20 then
			loginUsernameField.text = loginUsernameField.text .. t
		end
	elseif loginPasswordField.selected then
		config.typing()
		loginPasswordField.text = loginPasswordField.text .. t
	end
end

function state.keypressed(key, scancode, isrepeat, switchState, session)
	usernameExistsErrBool = false
	loginSuccessBool = false
	if scancode == "up" then
		loginTableButtons[loginPointer].selected = false

		if loginPointer == 1 then
			loginPointer = 4
		else
			loginPointer = loginPointer - 1
		end

		loginTableButtons[loginPointer].selected = true
		config.sounds.minimal[loginPointer]:clone():play()
	elseif scancode == "down" then
		loginTableButtons[loginPointer].selected = false

		if loginPointer == 4 then
			loginPointer = 1
		else
			loginPointer = loginPointer + 1
		end

		loginTableButtons[loginPointer].selected = true
		config.sounds.minimal[loginPointer]:clone():play()
	elseif scancode == "space" or scancode == "return" then
		if backToMain.selected then
			switchState("menu")
			config.sounds.enter:clone():play()
		elseif enterLogin.selected then
			local responseText, code = auth.login(loginUsernameField.text, loginPasswordField.text)
			print("Status Code:", code)
			print("Response:", responseText)

			if code == 200 then
				session["user_id"] = json.decode(responseText)["user_id"]
				switchState("charSelect")
			else
				usernameExistsErrBool = true
			end

			if responseText == "exists" then
				usernameExistsErrBool = true
			elseif responseText == "success" then
				loginSuccessBool = true
			end
		end
	elseif scancode == "backspace" then
		if loginUsernameField.selected then
			config.sounds.back:clone():play()
			loginUsernameField.text = loginUsernameField.text:sub(1, -2)
		elseif loginPasswordField.selected then
			config.sounds.back:clone():play()
			loginPasswordField.text = loginPasswordField.text:sub(1, -2)
		end
	end
end

function state.update(dt)
	loginUsernameField:update()
	loginPasswordField:update()
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	text.printext("Login", 2, 1)
	love.graphics.setFont(config.fonts.big)

	backToMain:draw()
	loginUsernameField:draw()
	loginPasswordField:draw()
	enterLogin:draw()

	if usernameExistsErrBool == true then
		usernameExistsErr:draw()
	elseif loginSuccessBool then
		loginSuccess:draw()
	end
end

return state
