local state = {}
local config = require("config")

function state.load() end

function state.keypressed(key, scancode, isrepeat, switchState, user_id)
	if scancode == "escape" then
		switchState("buffStats")
	end
end

function state.update(dt) end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 190, love.graphics.getWidth(), 150)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Attack increases damage to enemy HP", 200, 200)
	love.graphics.print("Speed increases time to type out words", 200, 250)
	love.graphics.print("Defense reduces damage taken", 200, 300)
end

return state
