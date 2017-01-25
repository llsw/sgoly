
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

local function redisToMySQL()
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".redisToMySQL")
end)
