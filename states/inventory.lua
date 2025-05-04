local state = {}
local config = require("config")
local misc = require("api.misc")
local manageUser = require("api.manageUser")
local session = require("session_manager")
local itemsResponse, code, totalItemsNum, currentItem

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function state.load()
	itemsResponse, code = misc.getItems(session["currentChar"]["id"])

	totalItemsNum = tablelength(itemsResponse)
	currentItem = 1
	print_r(code)
end

function state.keypressed(key, scancode, isrepeat, switchState, user_id)
	if scancode == "up" then
		currentItem = currentItem - 1

		if currentItem < 1 then
			currentItem = totalItemsNum
		end
	elseif scancode == "down" then
		currentItem = currentItem + 1

		if currentItem > totalItemsNum then
			currentItem = 1
		end
	elseif scancode == "escape" then
		switchState("playMenu")
	end
end

function state.update(dt) end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 150, love.graphics.getWidth(), 120)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Item : " .. itemsResponse[currentItem]["name"], 200, 175)
	love.graphics.print(
		"Increases " .. itemsResponse[currentItem]["stat"] .. " by " .. itemsResponse[currentItem]["bonus"],
		200,
		200
	)
end

return state
