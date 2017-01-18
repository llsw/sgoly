--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 15:43:45
 --]]

 require "sgoly_printf"
 local account_dao = require "sgoly_account_dao"
 local users_server = require "sgoly_users_server"

 local account_server = {}

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function account_server.insert(nickname, money)
 	printD("account_server.insert(%s, %d)", nickname, money)
 	printI("account_server.insert(%s, %d)", nickname, money)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return account_dao.insert(uid, money)
 	end
 end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function account_server.delete(nickname)
	printD("account_server.delete(%s)", nickname)
 	printI("account_server.delete(%s)", nickname)
	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return account_dao.delete(uid)
 	end
end

 --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function account_server.update_money(nickname, money)
	printD("account_server.update_money(%s, %d)", nickname, money)
 	printI("account_server.update_money(%s, %d)", nickname, money)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return account_dao.update_money(uid, money)
 	end
 end

  --[[
 函数说明：
 		函数作用：
 		传入参数：
 		返回参数：
 --]]
 function account_server.select_money(nickname)
	printD("account_server.select_money(%s)", nickname)
 	printI("account_server.select_money(%s)", nickname)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return account_dao.select_money(uid)
 	end
 end

return account_server