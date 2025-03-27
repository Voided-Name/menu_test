hidden = Button:extend()
local bigFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 30)
local smallFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 15)

function hidden:draw()
	love.graphics.setColor(255, 255, 255)
	if self.selected == true then
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setFont(bigFont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(
			"> " .. string.rep("*", string.len(self.text)),
			self.textX - bigFont:getWidth("> "),
			self.textY
		)
	else
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setFont(bigFont)
		love.graphics.print(string.rep("*", string.len(self.text)), self.textX, self.textY)
	end
	love.graphics.setFont(smallFont)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.labelText, self.x, self.y - smallFont:getHeight())
end

return hidden
