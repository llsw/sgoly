require "sgoly_query"
local sgoly_tool = {}

local function saveUuid(uuid)
	redis_query({"set","uuid", uuid})
end

local function getUuid()

	local uuid = redis_query({"get", "uuid"})
	return tonumber(uuid)
end



function sgoly_tool.getUuid()
	return getUuid()
end

function sgoly_tool.saveUuid(uuid)
	saveUuid(uuid)
end

return sgoly_tool