
--[[
 * @brief:		redisToMySQL.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-25
--]]

local skynet = require "skynet"
local cluster = require "cluster"
require "skynet.manager"
require "sgoly_query"
local sgoly_tool = require "sgoly_tool"

--!
--! @brief      定时保存Rdis数据到MySQL
--!
--! @return     nil
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-25
--!
local function redisToMySQL()
	local date = os.date("%Y-%m-%d")
	local timeEnd = os.time({day=tonumber(os.date("%d")), month=tonumber(os.date("%m")), year=tonumber(os.date("%Y")),hour = 17, min=40, sec=0})
	local time = timeEnd - os.time() 
	skynet.sleep(time * 100)


	-- local key1 = "rank:" .. "serialWinNum" .. date
	-- local key2 = "rank:" .. "winMoney" .. date
	sgoly_tool.saveRankToMySQL("serialWinNum", date)
	sgoly_tool.saveRankToMySQL("winMoney", date)

	while true do
		local date = os.date("%Y-%m-%d")
		skynet.sleep( 24 * 60 * 60 * 100)
		sgoly_tool.saveRankToMySQL("serialWinNum", date)
		sgoly_tool.saveRankToMySQL("winMoney", date)
	end

end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	skynet.fork(redisToMySQL)

	skynet.register(".redisToMySQL")
end)
