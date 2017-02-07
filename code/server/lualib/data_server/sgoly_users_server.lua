--[[
 * @Version:     1.0
 * @Author:      GitHubNull 
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是1个真对 sgoly_users_dao.lua 模块的执行前逻辑判断模块
 * @DateTime:    2017-01-17 14:39:11
 --]]

 require "sgoly_printf"
 local users_dao = require "sgoly_users_dao"

 local users_server = {}

 --[[
 函数说明：
 		函数作用：检查 users_dao.insert 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname, pwd(用户密码)
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.insert(nickname, pwd)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == pwd) or ("" == pwd)) then
		return false, "密码空值错误"
	else
		return users_dao.insert(nickname, pwd)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.delete 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.delete(nickname, pwd)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == pwd) or ("" == pwd)) then
		return false, "密码空值错误"
	else
		return users_dao.delete(nickname, pwd)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.update_nickname 函数的执行逻辑是否合法,并调用执行
 		传入参数：old_nickname, new_nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.update_nickname(old_nickname, new_nickname, pwd)
	if((nil == old_nickname) or ("" == old_nickname)) then
		return false, "旧昵称空值错误"
	elseif((nil == new_nickname) or ("" == new_nickname)) then
		return false, "新昵称空值错误"
	elseif((nil == pwd) or ("" == pwd)) then
		return false, "密码空值错误"
	else
		return users_dao.update_nickname(old_nickname, new_nickname, pwd)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.update_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname, new_pwd(新的用户密码)
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.update_pwd(nickname, old_pwd, new_pwd)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == old_pwd) or ("" == old_pwd)) then
		return false, "旧密码空值错误"
	elseif((nil == new_pwd) or ("" == new_pwd)) then
		return false, "新密码空值错误"
	else
		return users_dao.update_pwd(nickname, old_pwd, new_pwd)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select(nickname)
	if((nil == old_nickname) or ("" == old_nickname)) then
		return false, "昵称空值错误"
	else
		return users_dao.select(nickname)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select_uid 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select_uid(nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		printD("users_server.select_pwd line 120")
		return users_dao.select_uid(nickname)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select_pwd(nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		printD("users_server.select_pwd line 136")
 		return users_dao.select_pwd(nickname)
 	end
 end

 return users_server