local errors = {
	API_ERR = {
		--message = "API Error",
		code = 98,
		status = "error"
	},
	INVALID_ITEM = {
		--message = "You did not sent the correct Item Object.",
		code = 99,
		status = "error"
	},
	FULL_INVENTORY = {
		--message = "The inventory size was bypassed",
		code = 100,
		status = "error"
	},
	AIR_ITEM = {
		--message = "You can't interact with air",
		code = 101,
		status = "error"
	},
	AMOUNT_SENT = {
		--message = "You cant send amount more than 1 in a unstacked item",
		code = 102,
		status = "error"
	},
	INVALID_AMOUNT_SENT = {
		--message = "You cant send a invalid amount",
		code = 103,
		status = "error"
	},
	NO_FOUND = {
		--message = "Object not found",
		code = 104,
		status = "error"
	}
}

return errors
