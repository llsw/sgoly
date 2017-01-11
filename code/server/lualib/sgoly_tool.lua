require "sgoly_query"
local skynet_queue = require "skynet.queue"
local lock = skynet_queue()

local sgoly_tool = {}

local function updateUuid(uuid)
	redis_query({"set","uuid",tostring(uuid)})
end

local function getUuid()

	local uuid = redis_query({"get", "uuid"})
	uuid = tonumber(res)
	updateUuid(uuid + 1)
	return uuid
end



function sgoly_tool.getUuid()
	return lock(getUuid)
end

return sgoly_tool