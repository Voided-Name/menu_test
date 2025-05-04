local state = {}
local manageUser = require("api.manageUser")
local buttonManager = require("buttonManager")
local config = require("config")
local charNameEntryField, charNameEnter
local alert = require("alert")
local characterCreated, characterCreatedErr, characterCreatedBool, characterCreatedErrBool

function state.load()
	print("this runs!")

	charNameEntryField = Button(2, 1, 500, 100, "", "Character Name")
	charNameEnter = Button(2, 2, 500, 100, "Enter", "")

	buttonManager.setUp({ charNameEntryField, charNameEnter }, 2)
	buttonManager["pointer"] = 1

	characterCreatedErr = alert(1, 1, 500, 100, "Error", "")
	characterCreatedErr:setColor(255, 0, 0)
	characterCreatedErrBool = false

	characterCreated = alert(1, 1, 500, 100, "Character Created!", "")
	characterCreated:setColor(0, 255, 0)
	characterCreatedBool = false
end

function state.textinput(t)
	if charNameEntryField.selected then
		config.typing()
		if string.len(charNameEntryField.text) < 20 then
			charNameEntryField.text = charNameEntryField.text .. t
		end
	end
end

function state.keypressed(key, scancode, isrepeat, switchState, session)
	print("Is Entry Field Selected ")
	print(charNameEntryField.selected)
	print("Is Enter Field Selected")
	print(charNameEnter.selected)
	if characterCreatedBool or characterCreatedErrBool then
		switchState("charSelect")
	else
		if scancode == "up" then
			buttonManager.up()
			print("Is Entry Field Selected (Up)")
			print(charNameEntryField.selected)
			print("Is Enter Field Selected (Up)")
			print(charNameEnter.selected)
		elseif scancode == "down" then
			buttonManager.down()
			print("Is Entry Field Selected (Down)")
			print(charNameEntryField.selected)
			print("Is Enter Field Selected (Down)")
			print(charNameEnter.selected)
		elseif scancode == "backspace" then
			if charNameEntryField.selected then
				config.sounds.back:clone():play()
				charNameEntryField.text = charNameEntryField.text:sub(1, -2)
			end
		elseif scancode == "escape" then
			if charNameEntryField.selected then
				config.sounds.back:clone():play()
				switchState("charSelect")
			end
		elseif scancode == "return" then
			if charNameEnter.selected then
				config.sounds.enter:clone():play()
				local response, code = manageUser.addChar(session["user_id"], charNameEntryField.text)

				if response == "success" then
					characterCreatedBool = true
				else
					characterCreatedErrBool = true
				end
			end
		end
	end
end

function state.update(dt)
	charNameEntryField:update()
	charNameEnter:update()
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	love.graphics.setFont(config.fonts.big)

	if characterCreatedBool then
		characterCreated:draw()
	elseif characterCreatedErrBool then
		characterCreatedErr:draw()
	end

	charNameEntryField:draw()
	charNameEnter:draw()
end

return state
