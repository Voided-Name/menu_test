alert = Button:extend()

local bigFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 30)
local smallFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 15)

function alert:setColor(r, g, b)
	self.r = r
	self.g = g
	self.b = b
end

function alert:draw()
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setFont(bigFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(self.text, self.textX, self.textY)
end

return alert
