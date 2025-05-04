-- src/api/auth.lua
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json")

local misc = {}

function misc.getShopItems(char_id)
	local request_body = json.encode({ char_id = char_id })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/getShopItems",
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

function misc.getItems(char_id)
	local request_body = json.encode({ char_id = char_id })
	local response_body = {}

	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/getItems",
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

return misc
