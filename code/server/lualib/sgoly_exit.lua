
--[[
 * @brief: 关闭skynet前执行的服务，主要功能是将redis的数据持久化到mysql

 * @author:	  kun si
 * @date:	2017-01-12
--]]


local skynet = require "skynet"
require "skynet.manager"
require "sgoly_query"
local sgoly_record = require "sgoly_record"

skynet.start(function()
	local user = redis_query({"keys", "user:*"})

	for k, v in pairs(user) do
		local money = tonumber(redis_query({"hget", v, "money"}))
		local today = os.date("%Y-%m-%d")
		local nickname = string.match(v,"user:(.+)")
		sgoly_record.opt_update(nickname, money, nil, nil, nil, 
							nil, nil, today)
		redis_query({"del", v})
	end
	skynet.exit()
end)