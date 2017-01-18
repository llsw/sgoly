--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是用户账户金币资产的数据管理服务模块
 * @DateTime:    2017-01-17 15:43:45
 --]]

 require "sgoly_printf"
 local account_dao = require "sgoly_account_dao"
 local users_server = require "sgoly_users_server"

 local account_server = {}

 --[[
 函数说明：
 		函数作用：插入用户的金币数据
 		传入参数：nickname(用户昵称), money(金币数额)
 		返回参数：true 或者 false , 正确或错误提示的字符串
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
		函数作用：删除用户金币账户
		传入参数：nickname(用户昵称)
		返回参数：true 或者 false , 正确或错误提示的字符串
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
 		函数作用：更改用户账户金币数额
 		传入参数：nickname(用户昵称), money(金币数额)
 		返回参数：true 或者 false , 正确或错误提示的字符串
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
 		函数作用：查询用户账户金币数额
 		传入参数：nickname(用户昵称)
 		返回参数：true 或者 false , 正确或错误提示的字符串
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