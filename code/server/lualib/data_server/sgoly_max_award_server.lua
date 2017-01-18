--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是1个管理当日玩游戏赢奖数额最大前n名应该获得多少奖励的模块
 * @DateTime:    2017-01-17 15:58:29
 --]]

require "sgoly_printf"
local max_award_dao = require "sgoly_max_award_dao"

local max_award_server = {}

--[[
函数说明：
		函数作用：插入排名与对应奖励金币数额
		传入参数：id(排名), value(金币数额)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function max_award_server.insert(id, value)
 	printD("max_award_server.insert(%d, %d)", id, value)
 	printI("max_award_server.insert(%d, %d)", id, value)
 	return max_award_dao.insert(id, value)
end

--[[
函数说明：
		函数作用：删除排名与对应奖励金币数额
		传入参数：id(排名)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function max_award_server.delete(id)
 	printD("max_award_server.delete(%d)", id)
 	printI("max_award_server.delete(%d)", id)
 	return max_award_dao.delete(id)
end

--[[
函数说明：
		函数作用：更改排名对应的金币数额
		传入参数：id(排名), value(金币数额)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function max_award_server.update(id, value)
 	printD("max_award_server.update(%d, %d)", id, value)
 	printI("max_award_server.update(%d, %d)", id, value)
	return max_award_dao.update(id, value)
end

--[[
函数说明：
		函数作用：查询当天玩游戏赢得金币最大前n名, 排名对应的金币数额
		传入参数：id(排名)
		返回参数：true 或 false 和 金币数额 或 错误提示字符串
--]]
function max_award_server.select(id)
 	printD("max_award_server.select(%d)", id)
 	printI("max_award_server.select(%d)", id)
 	return max_award_dao.select(id)
end

return max_award_server