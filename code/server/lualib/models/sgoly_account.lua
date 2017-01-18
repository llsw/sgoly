--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是用户金币数额管理数据模块
 * @DateTime:    2017-01-16 16:59:03
 --]]

require "sgoly_query"
require "sgoly_printf"

 local account = {}

 --[[
 函数说明：
 		函数作用：插入用户的金币数额
 		传入参数：id(用户id), money(金币数额)
 		返回参数：返回参数：sql语句执行状态
 --]]
 function account.insert(id, money)
 	printD("account.insert(%d, %d)", id, money)
 	printI("account.insert(%d, %d)", id, money)
 	local sql = string.format("insert into sgoly.account value(%d, %d)", id,
 							   money)
 	return mysql_query(sql)
 end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function account.delete(id)
	printD("account.delete(%d)", id)
 	printI("account.delete(%d)", id)
 	local sql = string.format("delete from sgoly.account where id = %d;", id)
 	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：更改用户的金币数额
		传入参数：id(用户id), money(金币数额)
 		返回参数：返回参数：sql语句执行状态
--]]
function account.update_money(id, money)
	printD("account.update_money(%d, %d)", id, money)
 	printI("account.update_money(%d, %d)", id, money)
 	local sql = string.format("update sgoly.account set money = %d where id = "
 							   .."%d ;", money, id)
 	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：查询用户金币数额
		传入参数：id(用户id)
		返回参数：返回参数：sql语句执行状态
--]]
function account.select_money(id)
	printD("account.update_money(%d)", id)
 	printI("account.update_money(%d)", id)
 	local sql = string.format("select money from sgoly.account where id = %d ;"
 							   , id)
 	return mysql_query(sql)
end

return account