-- src/api/auth.lua
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json")

local manageUser = {}

-- optional: move this helper here if only used for auth
local function url_encode(str)
	str = string.gsub(str, "([^%w])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str
end

function manageUser.getCharacter(char_id)
	local request_body = json.encode({ ["_id"] = char_id })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/getCharacter",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.setHighScore(char_id, score)
	local request_body = json.encode({ char_id = tostring(char_id), score = score })
	print(json.decode(request_body))
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/setHighScore",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.getChars(user_id)
	local request_body = json.encode({ ["_id"] = user_id })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/getChars",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.modifyStat(user_id, char_id, stat, points)
	local request_body = json.encode({ _id = user_id, char_id = char_id, stat = stat, points = points })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/modifyStat",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.checkChars(user_id)
	local request_body = "_id=" .. user_id
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/checkChars",
		method = "POST",
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local responseText = table.concat(response_body)
	return responseText, code
end

function manageUser.addChar(user_id, charName)
	local request_body = "_id=" .. user_id .. "&charname=" .. charName
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/addChar",
		method = "POST",
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local responseText = table.concat(response_body)
	return responseText, code
end

function manageUser.addGold(char_id, gold_amount)
	local request_body = json.encode({ _id = char_id, gold = gold_amount })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/addGold",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.reduceGold(char_id, gold_amount)
	local request_body = json.encode({ _id = char_id, gold = gold_amount })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/reduceGold",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

function manageUser.addItem(char_id, itemId)
	local request_body = json.encode({ _id = char_id, itemId = itemId })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/addItem",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#request_body),
		},
		source = ltn12.source.string(request_body),
		sink = ltn12.sink.table(response_body),
	})

	local raw_response = table.concat(response_body)
	print("Raw response from server:")
	print(raw_response)

	local responseText = json.decode(table.concat(response_body))
	return responseText, code
end

return manageUser
