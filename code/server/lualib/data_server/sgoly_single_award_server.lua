--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 15:52:37
 --]]

 require "sgoly_printf"
 local single_award_dao = require "sgoly_single_award_dao"

 local single_award_server = {}

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function single_award_server.insert(id, value)
 	printD("single_award_server.insert(%d, %d)", id, value)
 	printI("single_award_server.insert(%d, %d)", id, value)
 	return single_award_dao.insert(id, value)
 end

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function single_award_server.delete(id)
 	printD("single_award_server.delete(%d)", id)
 	printI("single_award_server.delete(%d)", id)
 	return single_award_dao.delete(id)
 end

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function single_award_server.update(id, value)
 	printD("single_award_server.update(%d, %d)", id, value)
 	printI("single_award_server.update(%d, %d)", id, value)
 	return single_award_dao.update(id, value)
 end

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function single_award_server.select(id)
 	printD("single_award_server.select(%d)", id)
 	printI("single_award_server.select(%d)", id)
 	return single_award_dao.select(id)
 end

 return single_award_server