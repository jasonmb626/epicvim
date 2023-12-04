--https://stackoverflow.com/questions/11117440/is-it-possible-to-emulate-bind-in-lua#:~:text=Yes%2C%20this%20can%20be%20done,functions%20as%20first%2Dclass%20values.&text=This%20particular%20example%20works%20with,take%20arbitrary%20function%2Farguments%20instead.

local function packed_args_append(packed, nb_insert, ...)
	nb_insert = nb_insert > 0 and nb_insert or select("#", ...)

	for i = 1, nb_insert do
		packed[packed.n + 1] = select(i, ...)
		packed.n = packed.n + 1
	end
end

-- replace table.unpack as it doesn't always handle nil values correctly..
local function unpacknil(packed)
	local nb_args = packed.n

	local function unpack_n(n)
		if n == nb_args then
			return packed[n]
		end
		return packed[n], unpack_n(n + 1)
	end
	return unpack_n(1)
end

return function(self, placeholder_format, ...)
	local placeholders = table.pack(...)

	return function(...)
		local args = { n = 0 }
		local arg_idx = 1
		local placeholder_idx = 1

		for c in placeholder_format:gmatch(".") do
			if c == "A" then
				packed_args_append(args, 1, placeholders[placeholder_idx])
				placeholder_idx = placeholder_idx + 1
			elseif c == "." then
				packed_args_append(args, 1, select(arg_idx, ...))
				arg_idx = arg_idx + 1
			elseif c == "~" then
				packed_args_append(args, -1, select(arg_idx, ...))
				break
			end
		end
		--return self(table.unpack(args))
		return self(unpacknil(args))
	end
end
