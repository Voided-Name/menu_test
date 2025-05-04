-- src/api/auth.lua
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json")

local auth = {}

-- optional: move this helper here if only used for auth
local function url_encode(str)
	str = string.gsub(str, "([^%w])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str
end

function auth.login(username, password)
	local encodedUsername = url_encode(username)
	local encodedPassword = url_encode(password)
	local hashedPassword = love.data.encode("string", "hex", love.data.hash("sha256", encodedPassword))
	local request_body = "username=" .. encodedUsername .. "&password=" .. hashedPassword

	local response_body = {}
	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/login",
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

function auth.register(username, password)
	local encodedUsername = url_encode(username)
	local encodedPassword = url_encode(password)
	local hashedPassword = love.data.encode("string", "hex", love.data.hash("sha256", encodedPassword))
	local request_body = "username=" .. encodedUsername .. "&password=" .. hashedPassword

	local response_body = {}
	local res, code, _, _ = http.request({
		url = "http://127.0.0.1:5000/register",
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

return auth
