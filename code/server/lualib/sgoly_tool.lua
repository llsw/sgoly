require "sgoly_query"
local sgoly_tool = {}

local function saveUuid(uuid)
	redis_query({"set","uuid",tostring(uuid)})
end

local function getUuid()

	local uuid = redis_query({"get", "uuid"})
	return uuid
end



function sgoly_tool.getUuid()
	return lock(getUuid)
end

return sgoly_tool