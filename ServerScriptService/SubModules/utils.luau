local errors = require(script.Parent.Constants.errors)

export type UtilsType = {
	mergeObjects: (object: Object, target: Object) -> Object,
	fillTable: (amount: number, value: any) -> Object,
	copy: (target: Object) -> Object
}

local utils: UtilsType = {}

function utils:mergeObjects(object, target)

	for key, value in pairs(target) do

		if not object[key] then
			object[key] = value
		end
	end

	return object
end

function utils:fillTable(amount, value)

	local reply = {}

	for i = 1, amount do

		table.insert(reply, value)
	end

	return reply
end

function utils:copy(target)
	
	local object = {}
	
	for key, value in pairs(target) do
		
		if type(value) == "table" then
			object[key] = utils:copy(value)
		else
			object[key] = value	
		end	
	end

	return object
end

return utils
