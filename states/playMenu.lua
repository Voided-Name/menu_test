local state = {}
local logoutButton, buffStatsButton, fightButton, leaderboardButton, inventoryButton, shopButton, playMenuButtons, playMenuPointer
local config = require("config")
local session = require("session_manager")

local function down()
	if not (playMenuPointer == 6) then
		playMenuPointer = playMenuPointer + 1
	end
end

local function up()
	if not (playMenuPointer == 1) then
		playMenuPointer = playMenuPointer - 1
	end
end

function state.load()
	print(session)
	logoutButton = Button(5, 1, 320, 80, "Logout", "")
	buffStatsButton = Button(5, 2, 320, 80, "Upgrade Stats", "")
	fightButton = Button(5, 3, 320, 80, "Fight", "")
	inventoryButton = Button(5, 4, 320, 80, "Inventory", "")
	shopButton = Button(5, 5, 320, 80, "Shop", "")

	playMenuButtons = { logoutButton, buffStatsButton, fightButton, inventoryButton, shopButton }
	playMenuPointer = 1

	logoutButton.selected = true
end

function state.keypressed(key, scancode, isrepeat, switchState, user_id)
	if scancode == "up" then
		playMenuButtons[playMenuPointer].selected = false
		up()
		playMenuButtons[playMenuPointer].selected = true
		config.sounds.minimal[1]:clone():play()
	elseif scancode == "down" then
		playMenuButtons[playMenuPointer].selected = false
		down()
		playMenuButtons[playMenuPointer].selected = true
		config.sounds.minimal[2]:clone():play()
	elseif scancode == "space" or scancode == "return" then
		if logoutButton.selected then
			user_id = "blank"
			switchState("menu")
		elseif buffStatsButton.selected then
			switchState("buffStats")
		elseif fightButton.selected then
			switchState("fight")
		elseif inventoryButton.selected then
			switchState("inventory")
		elseif shopButton.selected then
			switchState("shop")
		end
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setFont(config.fonts.medium)
	love.graphics.rectangle("fill", 10, 10, 220, 190)

	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Attack  : " .. session["currentChar"]["stats"]["attack"], 15, 15)
	love.graphics.print("Speed   : " .. session["currentChar"]["stats"]["speed"], 15, 50)
	love.graphics.print("Defense : " .. session["currentChar"]["stats"]["defense"], 15, 85)
	love.graphics.print("Hi Score: " .. session["currentChar"]["points"], 15, 120)
	love.graphics.print("Gold    : " .. session["currentChar"]["gold"], 15, 155)

	logoutButton:draw()
	buffStatsButton:draw()
	fightButton:draw()
	inventoryButton:draw()
	shopButton:draw()
end

return state
