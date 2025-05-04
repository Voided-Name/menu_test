local json = require("json") -- or "lunajson"

local contents = love.filesystem.read("words_by_length.json")
local word_data = json.decode(contents)

local words = {}

-- Function to get a random word of a given length
function words.get_random(length)
	local key = tostring(length)
	local list = word_data[key]
	if not list then
		return nil
	end
	local index = math.random(1, #list)
	return list[index]
end

return words
