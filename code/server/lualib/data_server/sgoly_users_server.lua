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
	printD("users_server.insert(%s, %s)", nickname, pwd)
	printI("users_server.insert(%s)", nickname)
	local tag, res = users_dao.select(nickname)
	if(true == tag) then
		return false, "昵称已被使用"
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
 function users_server.delete(nickname)
	printD("users_server.delete(%s)", nickname)
	printI("users_server.delete(%s)", nickname)
	local tag, res = users_dao.select(nickname)
	if(false == tag) then
		return false, nickname.." 不存在"
	else
		return users_dao.delete(nickname)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.update_nickname 函数的执行逻辑是否合法,并调用执行
 		传入参数：old_nickname, new_nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.update_nickname(old_nickname, new_nickname)
	printD("users_server.update_nickname(%s, %s)", old_nickname, new_nickname)
	printI("users_server.update_nickname(%s, %s)", old_nickname, new_nickname)
	local tag, res = users_dao.select(old_nickname)
	local tag2, res2 = users_dao.select(new_nickname)
	if(false == tag) then
		return false, old_nickname.." 不存在"
	elseif(true == tag2) then
		return false, new_nickname.." 已存在"
	else
		return users_dao.update_nickname(old_nickname, new_nickname)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.update_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname, new_pwd(新的用户密码)
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.update_pwd(nickname, new_pwd)
	printD("users_server.update_pwd(%s, %s)", nickname, new_pwd)
	printI("users_server.update_pwd(%s)", nickname)
	local tag, res = users_dao.select(nickname)
	if(false == tag) then
		return false, nickname.." 不存在"
	else
		return users_dao.update_pwd(nickname, new_pwd)
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select(nickname)
	printD("users_server.select(%s)", nickname)
	printI("users_server.select(%s)", nickname)
 	return users_dao.select(nickname)
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select_uid 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select_uid(nickname)
	printD("users_server.select_uid(%s)", nickname)
	printI("users_server.select_uid(%s)", nickname)
	return users_dao.select_uid(nickname)
 end

 --[[
 函数说明：
 		函数作用：检查 users_dao.select_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_server.select_pwd(nickname)
	printD("users_server.select_pwd(%s)", nickname)
	printI("users_server.select_pwd(%s)", nickname)
 	return users_dao.select_pwd(nickname)
 end

 return users_server