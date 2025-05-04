local config = {}
local x = 1

config.fonts = {
	big = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 30),
	medium = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 20),
	small = love.graphics.newFont("DepartureMonoNerdFontMono-Regular.otf", 15),
}

config.sounds = {
	mainMusic = love.audio.newSource("sounds/little-slimex27s-adventure-151007.mp3", "stream"),
	minimal = {
		love.audio.newSource("sounds/ui_sounds/Minimalist10.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Minimalist11.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Minimalist12.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Minimalist13.ogg", "static"),
	},
	type = {
		love.audio.newSource("sounds/ui_sounds/Retro2.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Retro3.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Retro4.ogg", "static"),
		love.audio.newSource("sounds/ui_sounds/Retro5.ogg", "static"),
	},
	enter = love.audio.newSource("sounds/ui_sounds/Retro9.ogg", "static"),
	back = love.audio.newSource("sounds/ui_sounds/Wood Block2.ogg", "static"),
	slay = love.audio.newSource("sounds/slay.mp3", "static"),
	beep = love.audio.newSource("sounds/beep.mp3", "static"),
}

config.images = {
	menuBackground = love.graphics.newImage("images/Background.png"),
}

function config.typing()
	config.sounds.type[x]:clone():play()
	x = x + 1

	if x == 5 then
		x = 1
	end
end

return config
