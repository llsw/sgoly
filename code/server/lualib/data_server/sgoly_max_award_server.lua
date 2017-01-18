--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 15:58:29
 --]]

require "sgoly_printf"
local max_award_dao = require "sgoly_max_award_dao"

local max_award_server = {}

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function max_award_server.insert(id, value)
 	printD("max_award_server.insert(%d, %d)", id, value)
 	printI("max_award_server.insert(%d, %d)", id, value)
 	return max_award_dao.insert(id, value)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function max_award_server.delete(id)
 	printD("max_award_server.delete(%d)", id)
 	printI("max_award_server.delete(%d)", id)
 	return max_award_dao.delete(id)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function max_award_server.update(id, value)
 	printD("max_award_server.update(%d, %d)", id, value)
 	printI("max_award_server.update(%d, %d)", id, value)
	return max_award_dao.update(id, value)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function max_award_server.select(id)
 	printD("max_award_server.select(%d)", id)
 	printI("max_award_server.select(%d)", id)
 	return max_award_dao.select(id)
end

return max_award_server