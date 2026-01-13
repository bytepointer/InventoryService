local InventoryService = {}

local errors = require(script.Constants.errors)
local config = require(script.Constants.config)

local db = require(script.database)
local utils = require(script.utils)
local inventoryCache = require(script.cache)

local backpackManager = require(script.Tools.backpack)
local itemManager = require(script.Tools.items)

--[[

	SERVICES
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--local getInventory = ReplicatedStorage.Inventory.getInventory or false
local onInventoryChange = ReplicatedStorage.Inventory.Events.inventoryEvent or false

-- local constant
local EMPTY_ITEM_ID = 1

-- INTERNALS
function InventoryService._emitInventoryChange(player, item, slot)

	return onInventoryChange:FireClient(player, item, slot);
end

-- EXTERNALS

function InventoryService:SaveData(player)
	
	local writeSuccess, inventory = db:save(player.UserId)
	
	inventoryCache[player.UserId] = nil
	
	if not writeSuccess then
		return errors["API_ERR"]
	end
	
	return {
		message = "Inventory saved with success",
		status = "success"
	}
end

function InventoryService.getInventory(player)
	
	if inventoryCache[player.UserId] then
		return {
			inventory = utils:copy(inventoryCache[player.UserId]),
			status = "success"
		}
	end  
	
	local success, inventory = db:read(player.UserId)

	if not success then
		return errors["API_ERR"]
	end
	-- FIRST REQUEST (FIRST PLAYER TIME PLAYING)
	if not inventory then 
		
		local newInventory = {
			items = {},
			amount = 0
		}
		
		newInventory.items = utils:fillTable(11, itemManager.getItemById(EMPTY_ITEM_ID))
		inventory = newInventory
		
		db:write(player.UserId, inventory)
	end
	
	-- in case of being an backpack item located in 
	for _, item in pairs(inventory.items) do
		if itemManager.isEmpty(item.id) then
			backpackManager:addBackpackItem(player, item.name)
		end
	end
	
	inventoryCache[player.UserId] = inventory
	
	if success then
		return {
			inventory = inventory,
			status = "success"
		}
	else
		return errors["API_ERR"]
	end
end

function InventoryService.hasItem(player, item)
	
	local inventoryResult = InventoryService.getInventory(player)
	
	if inventoryResult.status ~= "success" then
		return errors["API_ERR"]
	end
	
	local inventory = inventoryResult.inventory
	
	local itemSlot = itemManager.getSlotById(inventory.items, item.id)
	
	local selectedItem = inventory.items[itemSlot]
	
	print(selectedItem)
	
	if not itemSlot or selectedItem.amount < item.amount then
		return {
			has = false,
			status = "success"
		}
	end
	
	return {
		has = true,
		status = "success"
	}
end

function InventoryService:changeInventory(player, sourceSlot, targetSlot)

	local inventoryResult = InventoryService.getInventory(player)

	if inventoryResult.status ~= "success" then
		return errors["API_ERR"]
	end

	local inventory = inventoryResult.inventory

	print(inventory)
	local changedSlots = itemManager:changeSlot(inventory, sourceSlot, targetSlot)

	print("UEE")
	print(changedSlots)
	local writeSuccess = db:write(player.UserId, changedSlots.inventory)

	if not writeSuccess then
		return errors["API_ERR"]
	end

	InventoryService._emitInventoryChange(player, changedSlots.sourceItem, sourceSlot)
	InventoryService._emitInventoryChange(player, changedSlots.targetItem, targetSlot)

	return {
		data = {
			sourceItem = changedSlots.sourceItem,
			targetItem = changedSlots.targetItem
		},
		status = "success"
	}
end
-- MODULE


function InventoryService:addItem(player, item, mode)
	
	mode = mode or "merge"
	
	if typeof(item) ~= "table" or not item.id or typeof(item.id) ~= "number" then
		return errors["INVALID_ITEM"]
	end
	
	local inventoryResult = InventoryService.getInventory(player)
	
	if inventoryResult.status ~= "success" then
		return errors["API_ERR"]
	end
	
	local inventory = inventoryResult.inventory
	
	if inventory.amount == config.maxItems then
		return errors["FULL_INVENTORY"]
	end
	
	-- merge sent old item with item strucutre
	
	utils:mergeObjects(item, itemManager.getItemById(item.id))
	
	-- STACKED PARAMETERS CHECKING 
	if not item.stacked then
		if item.amount and item.amount ~= 1 then
			return errors["AMOUNT_SENT"]
		end
		
		item.amount = 1
	else
		if not item.amount then
			item.amount = 1
		end
		
		if item.amount <= 0 or item.amount >= 1000 then return errors["INVALID_AMOUNT_SENT"] end
	end
	
	local selectedSlot = itemManager.findSlot(inventory, item, mode)
	
	local selectedItem = inventory.items[selectedSlot]
	
	-- SET ITEM AMOUNT
	if not itemManager.isEmpty(selectedItem.id) then
		if item.stacked then
			item.amount += selectedItem.amount
		end 
	else
		inventory.amount += 1
	end
	
	inventory.items[selectedSlot] = item
	
	local writeSuccess = db:write(player.UserId, inventory)
	
	-- EMIT TO CLIENT THAT DATA WAS CHANGED
	
	if not writeSuccess then
		return errors["API_ERR"]
	end
	
	InventoryService._emitInventoryChange(player, item, selectedSlot)

	return {
		message = "Item added successfully",
		status = "success"
	}
end

function InventoryService:RemoveItem(player, item)
	
	local slot
	
	print(item)
	if not item then
		return errors["INVALID_ITEM"] 
	end
	
	local inventoryResult = InventoryService.getInventory(player) -- change later to internal function bcs it will be better idk
	
	if inventoryResult.status ~= "success" then 
		return errors["API_ERR"]
	end
	
	local inventory = inventoryResult.inventory
	
	--print(inventory)
	if item.id then
		
		local itemSlot = itemManager.getSlotById(inventory.items, item.id)
		
		print(itemSlot)
		
		if not itemSlot then
			return errors["INVALID_ITEM"] -- he do not have the item
		else
			slot = itemSlot
		end
		
	elseif item.slot then
		slot = item.slot
	end
	
	local selectedItem = inventory.items[slot]
	
	if not selectedItem or itemManager.isEmpty(selectedItem.id) then
		return errors["INVALID_ITEM"]
	end
	
	print(selectedItem)
	
	if selectedItem.stacked and not item.amount then
		print("UE")
		item.amount = selectedItem.amount
	end

	if  not selectedItem.stacked or selectedItem.amount - item.amount <= 0 then
		inventory.items[slot] = itemManager.getItemById(EMPTY_ITEM_ID)
		inventory.amount -= 1
	elseif selectedItem.stacked then
		print("function")
		inventory.items[slot].amount -= item.amount
	end
	
	local writeSuccess = db:write(player.UserId, inventory)

	if not writeSuccess then
		return errors["API_ERR"]
	end
		
	backpackManager:removeBackpackItem(player, selectedItem.name)
	
	InventoryService._emitInventoryChange(player, inventory.items[slot], slot)
	
	return {
		message = "Item successfully removed from the player inventory.",
		status = "success"
	}
end

function InventoryService:SplitItem(player, item)
	
	if not item then 
		return errors["INVALID_ITEM"]
	end
	
	if item.amount <= 0 then 
		return errors["INVALID_AMOUNT_SENT"]
	end
	
	local inventoryResult = InventoryService.getInventory(player)
	
	if inventoryResult.status ~= "success" then
		return errors["API_ERR"]
	end
	
	local inventory = inventoryResult.inventory
	
	-- get item instance in inventory and ur infos
	
	local slotItem = inventory.items[item.slot]
	
	if not slotItem then 
		return errors["API_ERR"]
	end
	
	if item.amount >= slotItem.amount then 
		return errors["INVALID_AMOUNT_SENT"]
	end
	
	slotItem.amount = item.amount
	
	local removeReply = InventoryService:RemoveItem(player, item)
	
	if removeReply.status ~= "success" then 
		return errors["API_ERR"]
	end
	
	local addReply = InventoryService:addItem(player, slotItem, "split")

	if addReply.status ~= "success" then
		return errors["API_ERR"]
	end
	
	return {
		message = "Item successfully splitted.",
		status = "success"
	}
end

function InventoryService:DropItem(player, slot)
	
	local inventoryResult = InventoryService.getInventory(player)
	
	if inventoryResult.status ~= "success" then 
		return errors["API_ERR"]
	end
	
	local inventory = inventoryResult.inventory
	
	local slotItem = inventory.items[slot]
	
	if not slotItem or itemManager.isEmpty(slotItem.id) then
		return errors["INVALID_ITEM"]
	end
	
	local removeReply = InventoryService:RemoveItem(player, { slot = slot })
	
	if removeReply.status ~= "success" then
		return errors["API_ERR"]
	end
	
	local success = backpackManager:dropMaterialOnGround(player, slotItem)
	
	if not success then 
		return errors["API_ERR"] 
	end
	
	return {
		message = "Item dropped",
		status = "success"
	}
end

return InventoryService
