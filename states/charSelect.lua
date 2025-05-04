local state = {}
local session = require("session_manager")
local json = require("json")
local userCharacters = {}
local firstChar, secondChar, thirdChar
local buttonManager = require("buttonManager")
local config = require("config")
local manageUser = require("api.manageUser")
local charState = { 0, 0, 0 }

--if code == 200 then
--user_id = json.decode(responseText)["user_id"]
--send

function state.load()
	local responseText, code = manageUser.checkChars(session["user_id"])
	local count, allChars, codeChars
	charState = { 0, 0, 0 }

	print(session)
	print(session["user_id"])

	print(code)

	if code == 201 then
		firstChar = Button(3, 1, 500, 100, "New Character", "")
		secondChar = Button(3, 2, 500, 100, "New Character", "")
		thirdChar = Button(3, 3, 500, 100, "New Character", "")
	else
		count = json.decode(responseText)["characterCount"]
		allChars, codeChars = manageUser.getChars(session["user_id"])

		if count == 1 then
			firstChar = Button(3, 1, 500, 100, allChars[1]["characterName"], "")
			secondChar = Button(3, 2, 500, 100, "New Character", "")
			thirdChar = Button(3, 3, 500, 100, "New Character", "")

			session["firstChar"] = {
				characterName = allChars[1]["characterName"],
				id = allChars[1]["_id"],
				stats = allChars[1]["stats"],
				items = allChars[1]["items"],
				points = allChars[1]["points"],
				gold = allChars[1]["gold"],
			}

			charState[1] = 1
		elseif count == 2 then
			firstChar = Button(3, 1, 500, 100, allChars[1]["characterName"], "")
			secondChar = Button(3, 2, 500, 100, allChars[2]["characterName"], "")
			thirdChar = Button(3, 3, 500, 100, "New Character", "")

			session["firstChar"] = {
				characterName = allChars[1]["characterName"],
				id = allChars[1]["_id"],
				stats = allChars[1]["stats"],
				items = allChars[1]["items"],
				points = allChars[1]["points"],
				gold = allChars[1]["gold"],
			}

			session["secondChar"] = {
				characterName = allChars[2]["characterName"],
				id = allChars[2]["_id"],
				stats = allChars[2]["stats"],
				items = allChars[2]["items"],
				points = allChars[2]["points"],
				gold = allChars[2]["gold"],
			}

			charState[1] = 1

			charState[1] = 1
			charState[2] = 1
		elseif count == 3 then
			firstChar = Button(3, 1, 500, 100, allChars[1]["characterName"], "")
			secondChar = Button(3, 2, 500, 100, allChars[2]["characterName"], "")
			thirdChar = Button(3, 3, 500, 100, allChars[3]["characterName"], "")

			session["firstChar"] = {
				characterName = allChars[1]["characterName"],
				id = allChars[1]["_id"],
				stats = allChars[1]["stats"],
				items = allChars[1]["items"],
				points = allChars[1]["points"],
				gold = allChars[1]["gold"],
			}

			session["secondChar"] = {
				characterName = allChars[2]["characterName"],
				id = allChars[2]["_id"],
				stats = allChars[2]["stats"],
				items = allChars[2]["items"],
				points = allChars[2]["points"],
				gold = allChars[2]["gold"],
			}

			session["thirdChar"] = {
				characterName = allChars[3]["characterName"],
				id = allChars[3]["_id"],
				stats = allChars[3]["stats"],
				items = allChars[3]["items"],
				points = allChars[3]["points"],
				gold = allChars[3]["gold"],
			}

			charState[1] = 1
			charState[2] = 1
			charState[3] = 1
		end
	end

	buttonManager.setUp({ firstChar, secondChar, thirdChar }, 3)

	print("Status Code:", code)
	print("Response:", responseText)
end

function state.keypressed(key, scancode, isrepeat, switchState, user_id)
	if scancode == "up" then
		buttonManager.up()
	elseif scancode == "down" then
		buttonManager.down()
	elseif scancode == "space" or scancode == "return" then
		if firstChar.selected then
			if charState[1] == 1 then
				session["currentChar"] = session["firstChar"]
				switchState("playMenu")
			else
				switchState("createNewCharacter")
			end
		elseif secondChar.selected then
			if charState[2] == 1 then
				session["currentChar"] = session["secondChar"]
			else
				switchState("createNewCharacter")
			end
		elseif thirdChar.selected then
			if charState[3] == 1 then
				session["currentChar"] = session["thirdChar"]
			else
				switchState("createNewCharacter")
			end
		end
	elseif scancode == "escape" then
		switchState("menu")
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.small)
	love.graphics.setFont(config.fonts.big)

	firstChar:draw()
	secondChar:draw()
	thirdChar:draw()
end

return state
