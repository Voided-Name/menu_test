local text = {}

function text.printext(textvalue, position_x, position_y)
	local x, y

	if position_x == 1 then
		x = 0
	elseif position_x == 2 then
		x = (love.graphics.getWidth() / 2) - (love.graphics.getFont():getWidth(textvalue) / 2)
	elseif position_x == 3 then
		x = (love.graphics.getWidth()) - love.graphics.getFont():getWidth(textvalue)
	end

	if position_y == 1 then
		y = 0
	elseif position_y == 2 then
		y = (love.graphics.getHeight() / 2) - (love.graphics.getFont():getHeight() / 2)
	elseif position_y == 3 then
		y = (love.graphics.getHeight()) - love.graphics.getFont():getHeight()
	end

	love.graphics.print(textvalue, x, y)
end

return text
