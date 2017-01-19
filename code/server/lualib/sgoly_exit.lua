
--[[
 * @brief: 关闭skynet前执行的服务，主要功能是将redis的数据持久化到mysql

 * @author:	  kun si
 * @date:	2017-01-12
--]]


local skynet = require "skynet"
require "skynet.manager"
require "sgoly_query"
local sgoly_dat_ser = require "sgoly_dat_ser"

skynet.start(function()
	local user = redis_query({"keys", "user:*"})

	for k, v in pairs(user) do
		local money = tonumber(redis_query({"hget", v, "money"}))
		local nickname = string.match(v,"user:(.+)")
		-- sgoly_dat_ser.opt_update(nickname, money, nil, nil, nil, 
		-- 					nil, nil, today)
		redis_query({"del", v})
	end
	skynet.exit()
end)