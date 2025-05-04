local state = {}
local manageUser = require("api.manageUser")
local buttonManager = require("buttonManager")
local misc = require("api.misc")
local config = require("config")
local alert = require("alert")
local wordManager = require("gameplay.wordState")
local session = require("session_manager")
local timer = require("timer")
local counter, dmgToEnemy, enemyHp, enemyDmg, yourHealth, score, yourDmg, yourSpd, yourDef, setScore, totalHealth
local alertLevelBool, alertOver
local slaySound = config.sounds.slay:clone()
local typeTimer

local base_time = 5
local min_time = 0.5
local difficulty = 0.05

require("print_r")

local function fibonacci(n)
	if n <= 0 then
		return 0
	end
	if n == 1 then
		return 1
	end

	local a, b = 0, 1
	for i = 2, n do
		a, b = b, a + b
	end
	return b
end

local function drawTextBar(x, y, current, maximum, symbol)
	symbol = symbol or "|"
	local ratio = math.max(0, math.min(1, current / maximum))

	local totalSlots = 30
	local fillSlots = math.floor(ratio * totalSlots + 0.5)
	local emptySlots = totalSlots - fillSlots

	local bar = string.rep(symbol, fillSlots) .. string.rep(" ", emptySlots)
	love.graphics.print(bar, x, y)
end

local function calculateTime()
	local timePerWord = (base_time + (1 + (yourSpd * 0.05))) * math.exp(-difficulty * counter)
	timePerWord = math.max(min_time, timePerWord)
	return timePerWord
end

local function calculateEnemyHealth(enemiesDefeated)
	local startHealth = 5
	local targetHealth = 60
	local anchorEnemy = 40

	local growthRate = math.log(targetHealth / startHealth) / anchorEnemy

	return startHealth * math.exp(growthRate * enemiesDefeated)
end

local function calculateEnemyDamage(enemiesDefeated)
	local startDamage = 1
	local targetDamage = 10
	local anchorEnemy = 40

	local growthRate = math.log(targetDamage / startDamage) / anchorEnemy
	return startDamage * math.exp(growthRate * enemiesDefeated)
end

local function round(n)
	return math.floor(n + 0.5)
end

local function getEnemyDamage()
	local reduction = yourDef / (yourDef + 10)
	local reducedDamage = enemyDmg * (1 - reduction)
	return math.max(1, math.floor(reducedDamage + 0.5))
end

function state.load()
	wordManager.loadWord("short")
	counter = 0
	dmgToEnemy = calculateEnemyHealth(counter)
	yourHealth = 5
	totalHealth = 5
	yourDmg = session["currentChar"]["stats"]["attack"]
	yourSpd = session["currentChar"]["stats"]["speed"]
	yourDef = session["currentChar"]["stats"]["defense"]
	enemyHp = calculateEnemyHealth(counter)
	enemyDmg = calculateEnemyDamage(counter)
	score = 0
	alertOver = alert(1, 1, 500, 100, "Score: " .. score, "")
	alertOver:setColor(139, 128, 0)
	setScore = false

	local ownedItems, code = misc.getItems(session["currentChar"]["id"])
	if code == 200 and ownedItems then
		for _, item in ipairs(ownedItems) do
			local stat = item.stat -- "attack" | "speed" | "defense"
			local bonus = tonumber(item.bonus)
			if stat == "atk" then
				yourDmg = yourDmg + bonus
			elseif stat == "spd" then
				yourSpd = yourSpd + bonus
			elseif stat == "def" then
				yourDef = yourDef + bonus
			elseif stat == "hp" then
				yourHealth = yourHealth + bonus
				totalHealth = yourHealth
			end
		end
		-- update session so future code sees the buffed values too
		session["currentChar"]["stats"]["attack"] = yourDmg
		session["currentChar"]["stats"]["speed"] = yourSpd
		session["currentChar"]["stats"]["defense"] = yourDef
	end

	typeTimer = timer(400, calculateTime())
end

function state.textinput(t)
	if alertLevelBool == true then
		alertLevelBool = false
		return
	end

	print(t)
	wordManager.input(t)

	print("Word Manage State: ")
	print(wordManager.completed)

	if wordManager.getState() then
		if counter < 5 then
			wordManager.loadWord("short")
		elseif counter < 15 then
			wordManager.loadWord("medium")
		elseif counter < 30 then
			wordManager.loadWord("long")
		else
			wordManager.loadWord("longest")
		end

		dmgToEnemy = dmgToEnemy - yourDmg

		print(dmgToEnemy)

		if dmgToEnemy <= 0 then
			slaySound:stop()
			slaySound:play()

			config.sounds.slay:clone():play()
			score = score + counter
			counter = counter + 1
			enemyHp = round(calculateEnemyHealth(counter))
			dmgToEnemy = enemyHp
			enemyDmg = round(calculateEnemyDamage(counter))
		else
			config.sounds.enter:clone():play()
		end

		typeTimer = timer(400, calculateTime())

		if counter == total then
			-- local response, code = manageUser.modifyStat(session["user_id"], session["currentChar"]["id"], "speed", 1)

			-- if response["status"] == "success" then
			-- 	print("status success")
			--
			-- 	local response_2, code_2 = manageUser.getCharacter(session["currentChar"]["id"])
			-- 	session["currentChar"]["stats"] = response_2[1]["stats"]
			--
			-- 	alertLevelBool = true
			-- end
			--
			-- counter = 0
			-- total = fibonacci(session["currentChar"]["stats"]["speed"])
			-- typeTimer = timer(20, calculateSetTime())
		end
	end
end

function state.keypressed(key, scancode, isrepeat, switchState, session)
	if alertLevelBool == true then
		alertLevelBool = false
		return
	end

	if scancode == "escape" then
		switchState("playMenu")
	end
end

function state.update(dt)
	typeTimer:update(dt)

	if yourHealth > 0 then
		if typeTimer.finished then
			yourHealth = yourHealth - getEnemyDamage()
			typeTimer = timer(400, calculateTime())
			config.sounds.beep:clone():play()

			if counter < 5 then
				wordManager.loadWord("short")
			elseif counter < 15 then
				wordManager.loadWord("medium")
			elseif counter < 30 then
				wordManager.loadWord("long")
			else
				wordManager.loadWord("longest")
			end
		end
	else
		yourHealth = 0
		alertOver = alert(1, 1, 500, 100, "Score: " .. score, "")
		alertOver:setColor(139, 128, 0)

		if not setScore then
			print("Current Character ID:")
			manageUser.setHighScore(session["currentChar"]["id"], score)
			manageUser.addGold(session["currentChar"]["id"], round(score / 10))
			setScore = true

			session["currentChar"]["gold"] = session["currentChar"]["gold"] + round(score / 10)

			if session["currentChar"]["points"] < score then
				session["currentChar"]["points"] = score
			end
		end
	end
end

function state.draw()
	love.graphics.draw(config.images.menuBackground, 0, -150)

	love.graphics.setFont(config.fonts.big)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Enemy (" .. (counter + 1) .. ") Damage: " .. enemyDmg, 10, 10)
	love.graphics.print("Total Score: " .. score, 10, 50)

	local screenW, screenH = love.graphics.getDimensions()
	local areaH = 80
	local areaY = screenH - areaH

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", 0, areaY, screenW, areaH)

	love.graphics.setFont(config.fonts.small)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(("You:   %d / %d"):format(yourHealth, totalHealth), 10, areaY + 10)
	love.graphics.setColor(255, 0, 0)
	love.graphics.print(
		("Enemy (" .. (counter + 1) .. "): %d / %d"):format(dmgToEnemy, enemyHp),
		screenW / 2 + 10,
		areaY + 10
	)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(config.fonts.small) -- same font, ensures fw is correct
	drawTextBar(10, areaY + 40, yourHealth, totalHealth, "*")
	love.graphics.setColor(255, 0, 0)
	drawTextBar(screenW / 2 + 10, areaY + 40, dmgToEnemy, enemyHp, "*")

	love.graphics.setFont(config.fonts.big)
	wordManager.draw()
	typeTimer:draw()

	if yourHealth < 1 then
		alertOver:draw()
	end
end

return state
