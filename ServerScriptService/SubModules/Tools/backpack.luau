local errors = require(script.Parent.Parent.Constants.errors)

local ServerStorage = game:GetService("ServerStorage")

local itemPrompt = ServerStorage.Items.Materials:WaitForChild("ItemPrompt")
	
local backpackManager = {}

function backpackManager:removeBackpackItem(player, itemName)

	local backpack = player:WaitForChild("Backpack")
	local tool = backpack:FindFirstChild(itemName)

	if tool then
		tool:Destroy()
	else
		return false
	end

	return true
end

function backpackManager:addBackpackItem(player, itemName)

	local backpack = player:WaitForChild("Backpack")
	local tool = ServerStorage.Items.Tools:FindFirstChild(itemName)

	if tool then

		tool = tool:Clone()

		tool.Parent = player.Backpack
	else 
		return false
	end

	return true	
end

function backpackManager:dropMaterialOnGround(player, item)

	local itemMaterial = ServerStorage.Items.Materials:FindFirstChild(item.name)

	if not itemMaterial then
		return false
	end
	
	local newPrompt = itemPrompt:Clone()
	local newMaterial = itemMaterial:Clone()
	
	newPrompt.Parent = newMaterial
	
	newMaterial.Parent = workspace
	newMaterial.Position = player.Character.HumanoidRootPart.Position + Vector3.new(1, 0, 0)
	newMaterial:SetAttribute("id", item.id)
	
	if item.amount then newMaterial:SetAttribute("amount", item.amount) end

	return true
end

return backpackManager
