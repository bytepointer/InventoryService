local ReplicatedStorage = game:GetService("ReplicatedStorage")
local itemsList = require(ReplicatedStorage.Items.ItemsList)
local utils = require(script.Parent.Parent.utils)

local EMPTY_ITEM_ID = 1

local itemManager = {}

function itemManager.isEmpty(itemIdentificator)
	
	return itemIdentificator == EMPTY_ITEM_ID
end

function itemManager.getItemById(itemIdentificator)

	return itemsList[itemIdentificator] or nil
end

function itemManager.getSlotById(items, id)

	for index, item in pairs(items) do
		if item.id == id then
			return index 
		end
	end

	return nil -- the user did not have the item
end

function itemManager.findSlot(inventory, newItem, mode)

	local firstEmptySlot
	
	for index, item in pairs(inventory.items) do

		if newItem.stacked and mode == "merge" then
			if item.id == newItem.id then
				return index
			end
		end

		if not firstEmptySlot and itemManager.isEmpty(item.id) then
			firstEmptySlot = index
		end
	end

	return firstEmptySlot or nil
end

function itemManager:changeSlot(inventoryData, sourceSlot, targetSlot)

	local inventory = utils:copy(inventoryData)
	
	local sourceItem = inventory.items[sourceSlot]
	local targetItem = inventory.items[targetSlot]

	if sourceItem.id ~= targetItem.id then
		inventory.items[sourceSlot] = targetItem
		inventory.items[targetSlot] = sourceItem
	elseif targetItem.stacked then
		inventory.items[targetSlot].amount += sourceItem.amount
		inventory.items[sourceSlot] = itemManager.getItemById(EMPTY_ITEM_ID)
		inventory.amount -= 1
	end

	return {
		sourceItem = inventory.items[sourceSlot],
		targetItem = inventory.items[targetSlot],
		inventory = inventory
	}
end

return itemManager
