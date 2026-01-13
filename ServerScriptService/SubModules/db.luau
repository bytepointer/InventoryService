local db = {}

local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("playerData")

local cache = require(script.Parent.cache)

function db:write(user, data)
	
	cache[user] = data

	return true
end

function db:read(user)

	local readSuccess, data = pcall(function()
		return PlayerDataStore:GetAsync("player_" .. user .. "_inventory")
	end)

	return readSuccess, data
end

function db:save(user)
	
	local data = cache[user]
	
	if not data then
		return false
	end
	
	local writeSuccess = pcall(function()
		return PlayerDataStore:SetAsync("player_" .. user .. "_inventory", data)
	end)
	
	return writeSuccess
end

return db
