-- SERVER

local InventoryService = require(script.Parent.InventoryService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local getInventory = ReplicatedStorage.Inventory.getInventory or false
local changeInventory = ReplicatedStorage.Inventory.changeInventory or false
local splitItem = ReplicatedStorage.Inventory.splitItem or false
local dropItem = ReplicatedStorage.Inventory.dropItem or false

-- INVENTORY

getInventory.OnServerInvoke = function(player)
	
	-- GIVE DIAMODN TO PLAYER -- TEST ONLY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	--[[InventoryService:AddItem(player, {
		id = 4,
		amount = 10
	})--]]
	
	return InventoryService.getInventory(player)
end

changeInventory.OnServerEvent:Connect(function(player, sourceSlot, targetSlot)
	
	InventoryService:ChangeInventory(player, sourceSlot, targetSlot)
end)

splitItem.onServerEvent:Connect(function(player, item)
	
	InventoryService:SplitItem(player, item)
end)

dropItem.onServerEvent:Connect(function(player, slot)
	
	InventoryService:DropItem(player, slot)
end)

game.Players.PlayerRemoving:Connect(function(player)
	
	InventoryService:SaveData(player)
end)
