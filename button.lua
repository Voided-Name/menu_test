Button = Object.extend(Object)
local bigFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 30)
local smallFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 15)

function Button:new(numButtons, orderNum, width, height, text, label)
	local totalWhitespace = love.graphics.getHeight() - (height * numButtons)
	local whitespace = totalWhitespace / (numButtons + 1)
	local whitespaceInstance = whitespace * orderNum
	local blockspace = height * (orderNum - 1)
	self.x = love.graphics.getWidth() / 2 - (width / 2)
	self.y = whitespaceInstance + blockspace
	self.width = width
	self.height = height
	self.text = text
	self.textX = (love.graphics.getWidth() / 2) - (bigFont:getWidth(text) / 2)
	self.textY = whitespaceInstance + blockspace + ((height / 2) - (bigFont:getHeight() / 2))
	self.selected = false
	self.labelText = label
end

function Button:update()
	self.textX = (love.graphics.getWidth() / 2) - (bigFont:getWidth(self.text) / 2)
end

function Button:printValues()
	print(self.x)
	print(self.y)
	print(self.width)
	print(self.height)
end

function Button:draw()
	love.graphics.setColor(255, 255, 255)
	if self.selected == true then
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setFont(bigFont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("> " .. self.text, self.textX - bigFont:getWidth("> "), self.textY)
	else
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setFont(bigFont)
		love.graphics.print(self.text, self.textX, self.textY)
	end
	love.graphics.setFont(smallFont)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.labelText, self.x, self.y - smallFont:getHeight())
end

return Button
