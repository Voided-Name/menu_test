Timer = Object.extend(Object)
local bigFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 30)
local smallFont = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 15)

function Timer:new(y, time)
	local width = 400
	self.x = love.graphics.getWidth() / 2 - (width / 2)
	self.y = y
	self.width = width
	self.fixedWidth = width
	self.height = 30
	self.time = time
	self.elapsed = 0
	self.finished = false
end

function Timer:update(dt)
	self.elapsed = math.min(self.elapsed + dt, self.time)

	local progress = self.elapsed / self.time
	self.width = self.fixedWidth * (1 - progress)

	if self.elapsed == self.time then
		self.finished = true
	end
end

function Timer:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Timer
