--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是1个真对 sgoly_users_dao.lua 模块的执行前逻辑判断模块
 * @DateTime:    2017-01-17 14:39:11
 --]]

require "sgoly_printf"
local users = require "sgoly_users"

 local users_dao = {}

 --[[
 函数说明：
 		函数作用：检查 users.insert 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname, pwd(用户密码)
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.insert(nickname, pwd)
	printD("users_dao.insert(%s, %s)", nickname, pwd)
	printI("users_dao.insert(%s)", nickname)
	local tab = users.select(nickname)
	if(1 == #tab) then
		return false, "昵称已被使用"
	else
		local status = users.insert(nickname, pwd)
		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "插入用户数据成功"
		else
			return false, status.err
		end
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.delete 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.delete(nickname, pwd)
	printD("users_dao.delete(%s, %s)", nickname, pwd)
	printI("users_dao.delete(%s)", nickname)
	local tab = users.select(nickname)
	if(0 == #tab) then
		return false, "昵称不存在"
	else
		if(tab[1].pwd ~= pwd) then
			return false, "密码不正确"
		else
			local status = users.delete(nickname)
			if((0 == status.warning_count) and (1 == status.affected_rows)) then
				return true, "删除用户数据成功"
			else
				return false, status.err
			end
		end
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.update_nickname 函数的执行逻辑是否合法,并调用执行
 		传入参数：old_nickname, new_nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.update_nickname(old_nickname, new_nickname, pwd)
	printD("users_dao.update_nickname(%s, %s, %s)", old_nickname, new_nickname,
			pwd)
	printI("users_dao.update_nickname(%s, %s)", old_nickname, new_nickname)
	local tab = users.select(old_nickname)
	local tab2 = users.select(new_nickname)
	if(0 == #tab) then
		return false, "昵称不存在"
	elseif(1 == #tab2) then
		return false, "称已存在"
	else
		if(tab[1].pwd ~= pwd) then
			return false, "密码不正确"
		else
			local status = users.update_nickname(old_nickname, new_nickname)
			if((0 == status.warning_count) and (1 == status.affected_rows)) then
				return true, "更新用户昵称成功"
			else
				return false, status.err
			end
		end
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.update_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname, new_pwd(新的用户密码)
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.update_pwd(nickname, old_pwd, new_pwd)
	printD("users_dao.update_pwd(%s, %s, %s)", nickname, old_pwd, new_pwd)
	printI("users_dao.update_pwd(%s)", nickname)
	local tab = users.select(nickname)
	if(0 == #tab) then
		return false, "用户不存在"
	else
		if(tab[1].pwd ~= old_pwd) then
			return false, "密码不正确"
		else
			local status = users.update_pwd(nickname, new_pwd)
			if((0 == status.warning_count) and (1 == status.affected_rows)) then
				return true, "更新用户密码成功"
			else
				return false, status.err
			end
		end
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.select 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.select(nickname)
	printD("users_dao.select(%s)", nickname)
	printI("users_dao.select(%s)", nickname)
 	local status = users.select(nickname)
 	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.select_uid 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.select_uid(nickname)
	printD("users_dao.select_uid(%s)", nickname)
	printI("users_dao.select_uid(%s)", nickname)
	local status = users.select_uid(nickname)
	if(1 == #status) then
		return true, status[1].id
	else
		return false, status.err
	end
 end

 --[[
 函数说明：
 		函数作用：检查 users.select_pwd 函数的执行逻辑是否合法,并调用执行
 		传入参数：nickname
 		返回参数：执行结果的正确与否的布尔值和相关消息
 --]]
 function users_dao.select_pwd(nickname)
	printD("users_dao.select_pwd(%s)", nickname)
	printI("users_dao.select_pwd(%s)", nickname)
 	local status = users.select_pwd(nickname)
	if(1 == #status) then
		return true, status[1].pwd
	else
		return false, status.err
	end
 end

 return users_dao