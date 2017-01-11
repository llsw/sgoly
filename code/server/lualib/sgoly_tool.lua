require "sgoly_query"

local soly_tool = {}

function sgoly_tool.getUuid()

	local res = redis_query({"get", "uuid"})
	res = tonumber(res)
	return res
end

function sgoly_tool.updateUuid(uuid)
	redis_query({"set","uuid",tostring(uuid)})
end

return sgoly_tool