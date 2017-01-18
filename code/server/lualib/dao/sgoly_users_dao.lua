--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个sgoly_users.lua数据管理模块的参数检查模块
 * @DateTime:    2017-01-17 09:39:58
 --]]

require "sgoly_printf"
local users = require "sgoly_users"

local users_dao = {}

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用sgoly_users.insert
		传入参数：nickname, pwd
		返回参数：执行结果的正确与否的布尔值和相关消息
--]]
function users_dao.insert(nickname, pwd)
	printD("users_dao.insert(%s, %s)", nickname, pwd)
	printI("users_dao.insert(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == pwd) or ("" == pwd)) then
		return false, "密码空值错误"
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
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用sgoly_users.delete
		传入参数：nickname
		返回参数：执行结果的正确与否的布尔值和相关消息
--]]
function users_dao.delete(nickname)
	printD("users_dao.delete(%s)", nickname)
	printI("users_dao.delete(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local status = users.delete(nickname)
		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "删除用户数据成功"
		else
			return false, status.err
		end
	end
end

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用
				 sgoly_users.update_nickname
		传入参数：nickname
		返回参数：执行结果的正确与否的布尔值和相关消息
--]]
function users_dao.update_nickname(old_nickname, new_nickname)
	printD("users_dao.update_nickname(%s, %s)", old_nickname, new_nickname)
	printI("users_dao.update_nickname(%s, %s)", old_nickname, new_nickname)
	if((nil == old_nickname) or ("" == old_nickname)) then
		return false, "旧昵称空值错误"
	elseif((nil == new_nickname) or ("" == new_nickname)) then
		return false, "新昵称空值错误"
	else
		local status = users.update_nickname(old_nickname, new_nickname)
		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "更新用户昵称成功"
		else
			return false, status.err
		end
	end
end

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用
				 sgoly_users.update_pwd
		传入参数：nickname, new_pwd
		返回参数：执行结果的正确与否的布尔值和相关消息
--]]
function users_dao.update_pwd(nickname, new_pwd)
	printD("users_dao.update_pwd(%s, %s)", nickname, new_pwd)
	printI("users_dao.update_pwd(%s, %s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == new_pwd) or ("" == new_pwd)) then
		return false, "新密码空值错误"
	else
		local status = users.update_pwd(nickname, new_pwd)
		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "更新用户密码成功"
		else
			return false, status.err
		end
	end
end

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用sgoly_users.select
		传入参数：nickname
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function users_dao.select(nickname)
	printD("users_dao.select(%s)", nickname)
	printI("users_dao.select(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local status = users.select(nickname)
		if(1 == #status) then
			return true, status[1]
		else
			return false, status.err
		end
	end
end

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用
				 sgoly_users.select_uid
		传入参数：nickname
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function users_dao.select_uid(nickname)
	printD("users_dao.select_uid(%s)", nickname)
	printI("users_dao.select_uid(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local status = users.select_uid(nickname)
		if(1 == #status) then
			return true, status[1].id
		else
			return false, status.err
		end
	end
end

--[[
函数说明：
		函数作用：参数检查(包括sql语句执行结果状态返回检测)然后调用
				 sgoly_users.select_pwd
		传入参数：nickname
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function users_dao.select_pwd(nickname)
	printD("users_dao.select_pwd(%s)", nickname)
	printI("users_dao.select_pwd(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local status = users.select_pwd(nickname)
		if(1 == #status) then
			return true, status[1].pwd
		else
			return false, status.err
		end
	end
end

return users_dao