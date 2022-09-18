return {
    type = "table",
    entries = {
        name = {
			type = "string",
			default = "Switching",
			description = "Timer text"
		},
        duration = {
			type = "number",
			range = { min = 0 },
			default = 2,
			description = "Time it takes to switch slots in seconds"
		},
        color = {
			type = "string",
			func = function(num)
				assert(#(num:match"^%x+$" or "") == 6, "expected hex color")
			end,
			default = "545AA7",
			description = "Hexadecimal RRGGBB color (without a leading `#`)"
		},
        interact = {
			type = "boolean",
			default = true,
			description = "Whether the `interact` privilege should be revoked temporarily"
		}
    }
}