--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是1个管理单次获奖数额最大排名对应应该获得多少金币的模块
 * @DateTime:    2017-01-17 15:52:37
 --]]

 require "sgoly_printf"
 local single_award_dao = require "sgoly_single_award_dao"

 local single_award_server = {}

 --[[
 函数说明：
 		函数作用：插入获奖单次最大排名与对应奖励金币数额
 		传入参数：id(排名), value(金币数额)
 		返回参数：true 或者 false , 正确或错误提示的字符串
 --]]
 function single_award_server.insert(id, value)
 	printD("single_award_server.insert(%d, %d)", id, value)
 	printI("single_award_server.insert(%d, %d)", id, value)
 	return single_award_dao.insert(id, value)
 end

 --[[
 函数说明：
 		函数作用：删除第n名获奖
 		传入参数：id(排名)
 		返回参数：true 或者 false , 正确或错误提示的字符串
 --]]
 function single_award_server.delete(id)
 	printD("single_award_server.delete(%d)", id)
 	printI("single_award_server.delete(%d)", id)
 	return single_award_dao.delete(id)
 end

 --[[
 函数说明：
 		函数作用：更改排名对应金币数额
 		传入参数：id(排名), value(金币数额)
 		返回参数：true 或者 false , 正确或错误提示的字符串
 --]]
 function single_award_server.update(id, value)
 	printD("single_award_server.update(%d, %d)", id, value)
 	printI("single_award_server.update(%d, %d)", id, value)
 	return single_award_dao.update(id, value)
 end

 --[[
 函数说明：
 		函数作用：查询排名对应应该获得金币数额
 		传入参数：查询当天玩游戏单次赢得金币数额最大前n名, 排名对应的金币数额
		传入参数：id(排名)
		返回参数：true 或 false 和 金币数额 或 错误提示字符串
 --]]
 function single_award_server.select(id)
 	printD("single_award_server.select(%d)", id)
 	printI("single_award_server.select(%d)", id)
 	return single_award_dao.select(id)
 end

 return single_award_server