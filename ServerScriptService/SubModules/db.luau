export type dbType = {
	write: (user: number, data: Object) -> boolean,
	read: (user: number) -> (boolean, Object),
	save: (user: number) -> boolean,
}

local db: dbType = {}

local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("playerData")

local cache = require(script.Parent.cache)

function db:write(user: number, data: Object)
	
	cache[user] = data

	return true
end

function db:read(user: number)

	local readSuccess, data = pcall(function()
		return PlayerDataStore:GetAsync("player_" .. user .. "_inventory")
	end)

	return readSuccess, data
end

function db:save(user: number)
	
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
