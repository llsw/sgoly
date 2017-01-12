
--[[
 * @brief: sgoly_tool.lua

 * @author:	  kun si
 * @date:	2017-01-12
--]]


require "sgoly_query"
local sgoly_tool = {}
local sgoly_record = require "sgoly_record"

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

function sgoly_tool.getMoney(nickname)
	local db = "user:" ..  nickname
	local money = redis_query({"hget", db, "money"})
	if money then
		return true, tonumber(money)
	else
		local today = os.date("%Y-%m-%d")
		local judge
		judge, money = sgoly_record.get_money(nickname, today)
		if judge then
			redis_query({"hset", db, "money", money})
			return true, money
		else
			return false, money
		end
	end
end

return sgoly_tool