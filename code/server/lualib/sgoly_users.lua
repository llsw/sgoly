--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:57:36
 --]]

require "sgoly_query"
require "sgoly_printf"
local utf8 = require "sgoly_utf8"
local sql_valid = require "sgoly_sql_valid"
local sgoly_users = {}

--[[
函数说明：
		函数作用：获取用户id
		传入参数：nickname
		返回参数：用户id或nil
--]]
function sgoly_users.get_uid(nickname)
	printD("sgoly_users.get_uid( '%s' )", nickname)
	local sql = string.format("select users_id from sgoly.users where "
		.."users_nickname = '%s' ;", nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return tmptable[1].users_id
 		else
 			return nil
 		end
end

--[[
函数说明：
		函数作用：检查给定的昵称的用户是否存在
		传入：用户的昵称字符串users_nickname
		返回：true or false

--]]
function sgoly_users.users_exist(users_nickname)
	printD("sgoly_users.users_exist(%s)", users_nickname)
	local sql = string.format("select * from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 	local tmptable = mysql_query(sql)
 	if(1 == #tmptable) then
 		return true
 	else
 		return false
 	end
end

--[[
函数说明：
		函数作用：登录和注册函数的参数检查
		传入：users_nickname, users_pwd
		返回：如果参数无问题返回true和空字符串，否则返回false和错误信息

--]]
function parameters_valid(users_nickname, users_pwd)
	printD("parameters_valid(%s, %s)", users_nickname, users_pwd)
	if((nil == users_nickname) or (nil == users_pwd)) then
		return false, '无昵称或密码参数错误'
	end
	if(("" == users_nickname) or ("" == users_pwd)) then
		return false, '昵称或密码为空'
	end
	if(35 < utf8.strlen(users_nickname)) then
		return false, '昵称长度超过35个字符'
	end
	if(32 < utf8.strlen(users_pwd)) then
		return false, '密码长度超过32个字符'
	end
	if(true == sql_valid.valid(users_nickname)) then
		return false, '昵称存在sql注入关键词'
	end
	if(true == sql_valid.valid(users_pwd)) then
		return false, '密码存在sql注入关键词'
	else
		return true, ''
	end
end

--[[
函数说明：
		函数作用：用户登录
		传入：users_nickname, users_pwd
		返回：如果登录成功返回true和'登录成功'字符串两个参数，否则返回false和错误信息
--]]
function sgoly_users.login(users_nickname, users_pwd)
	printD("sgoly_users.login(%s, %s)", users_nickname, users_pwd)
	printI("sgoly_users.login(%s, users_pwd)", users_nickname)
 	local lv, msg = parameters_valid(users_nickname, users_pwd)
 	if(true == lv) then
 		local sql = string.format("select users_pwd from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			if(users_pwd == tmptable[1].users_pwd) then
 				return true, '登录成功'
 			else
 				return false, '密码不正确'
 			end
 		else
 			return false, '未知错误'
 		end
 	else
 		return false, msg
 	end
 end

--[[
函数说明：
		函数作用：用户注册
		传入：users_nickname, users_pwd
		返回：如果注册成功返回true和'注册成功'字符串两个参数，否则返回false和错误信息
--]]
 function sgoly_users.register(users_nickname, users_pwd)
 	printD("sgoly_users.register(%s, %s)",users_nickname, users_pwd)
 	printI("sgoly_users.register(%s, users_pwd)", users_nickname)
 	local rv, msg = parameters_valid(users_nickname, users_pwd)
 	if(true == rv) then
 		if(true == sgoly_users.users_exist(users_nickname)) then
 			return false, '昵称已被使用'
 		else
 			sql = string.format("insert into sgoly.users values(null, '%s', '%s')",
 				users_nickname, users_pwd)
 			local status = mysql_query(sql)
 			if((0 == status.warning_count) and (1 <= status.affected_rows)) then
				return true, '注册成功'
			else
				return false, '未知错误'
			end
 		end
 	else
 		return false, msg
 	end
 end

--[[
函数说明：
		函数作用：更改昵称参数检查
		传入：old_nickname, new_nickname
		返回：如果参数无问题返回true和空字符串两个参数，否则返回false和错误信息
--]]
function change_nickname_valid(old_nickname, new_nickname)
	printD("sgoly_users.change_nickname old_nickname =%s, "
 		.."new_nickname =%s", old_nickname, new_nickname)
 	if((nil == old_nickname) or (nil == new_nickname)) then
 		return false, '无新或旧昵称参数'
 	end
 	if(('' == old_nickname) or ('' == new_nickname)) then
 		return false, '新或旧昵称参数为空'
 	end
 	if(35 < utf8.strlen(old_nickname)) then
 		return false, '旧昵称长度大于35'
 	end
 	if(35 < utf8.strlen(new_nickname)) then
 		return false, '新昵称长度大于35'
 	end
 	 if(true == sql_valid.valid(old_nickname)) then
 		return false, '旧昵称存在sql注入关键词'
 	end
 	if(true == sql_valid.valid(new_nickname)) then
 		return false, '新昵称存在sql注入关键词'
 	end
 	if(false == sgoly_users.users_exist(old_nickname)) then
 		return false, '不存在该用户: '..nickname
 	else
 		return true, ''
 	end
end

--[[
函数说明：
		函数作用：更改昵称
		传入：old_nickname, new_nickname
		返回：如果成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
 function sgoly_users.change_nickname(old_nickname, new_nickname)
 	printD("sgoly_users.change_nickname(%s, %s)", old_nickname, new_nickname)
 	printI("sgoly_users.change_nickname(%s, new_nickname)", old_nickname)
 	local cnv, msg = change_nickname_valid(old_nickname, new_nickname)
 	if(false == cnv) then
 		return false, msg
 	else
 		local sql = string.format("update sgoly.users set users_nickname = '%s' "
 				.."where users_nickname = '%s' ;", new_nickname, old_nickname)
 		local status = mysql_query(sql)
		if((0 == status.warning_count) and (1 <= status.affected_rows)) then
			return true, '更改昵称成功'
		else
			return false, '未知错误'
		end
 	end
 end

--[[
函数说明：
		函数作用：更改用户密码参数检查
		传入：nickname, old_pwd, new_pwd
		返回：如果成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
function change_pwd_valid(nickname, old_pwd, new_pwd)
	printD("change_pwd_valid nickname =%s, old_pwd =%s, new_pwd =%s", 
		nickname, old_pwd, new_pwd)
	if(nil == nickname) then
 		return false, '无昵称参数'
 	elseif(nil == old_pwd) then
 		return false, '无旧密码参数'
 	elseif(nil == new_pwd) then
 		return false, '无新密码参数'
 	elseif('' == nickname) then
 		return false, '昵称为空'
 	elseif('' == old_pwd) then
 		return false, '旧密码为空'
 	elseif('' == new_pwd) then
 		return false, '新密码为空'
 	elseif(35 < utf8.strlen(nickname)) then
 		return false, '昵称长度大于35'
 	 elseif(32 < utf8.strlen(old_pwd)) then
 		return false, '旧密码长度大于32'
 	elseif(32 < utf8.strlen(new_pwd)) then
 		return false, '新密码长度大于32'
 	elseif(true == sql_valid.valid(nickname)) then
 		return false, '昵称存在sql注入关键词'
 	elseif(true == sql_valid.valid(old_pwd)) then
 		return false, '旧密码存在sql注入关键词'
 	elseif(true == sql_valid.valid(new_pwd)) then
 		return false, '新密码存在sql注入关键词'
 	elseif(false == sgoly_users.users_exist(nickname)) then
 		return false, '不存在该用户: '..nickname
 	else
 		local sql = string.format("select users_pwd from sgoly.users where "
 			.."users_nickname = '%s' ;", nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			if(old_pwd == tmptable[1].users_pwd) then
 				return true, ''
 			else
 				return false, '旧密码不正确'
 			end
 		else
 			return false, '未知错误'
 		end
 	end
end



--[[
函数说明：
		函数作用：更改密码
		传入：nickname, old_pwd, new_pwd
		返回：如果注册成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
 function sgoly_users.change_pwd(nickname, old_pwd, new_pwd)
 	printD("sgoly_users.change_pwd(%s, %s, %s)", nickname, old_pwd, new_pwd)
 	printI("sgoly_users.change_pwd(%s, %s, %s)", nickname, old_pwd, new_pwd)
 	local cpv, msg = change_pwd_valid(nickname, old_pwd, new_pwd)
 	if(false == cpv) then
 		return false, msg
 	else
 		sql = string.format("update sgoly.users set users_pwd = '%s' "
 				.."where users_nickname = '%s' ;", new_pwd, nickname)
 		local status = mysql_query(sql)
		if((0 == status.warning_count) and (1 <= status.affected_rows)) then
			return true, '更改密码成功'
		else
			return false, '未知错误'
		end
 	end
 end

--[[
函数说明：
		函数作用：删除用户参数检查
		传入：nickname, pwd
		返回：如果成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
function delete_user_valid(nickname, pwd)
	printD("delete_user_valid nickname =%s, pwd =%s", nickname, pwd)
	if(nil == nickname) then
 		return false, '无昵称参数'
 	elseif(nil == pwd) then
 		return false, '无密码参数'
 	elseif('' == nickname) then
 		return false, '昵称为空'
 	elseif('' == pwd) then
 		return false, '密码为空'
 	elseif(35 < utf8.strlen(nickname)) then
 		return false, '昵称长度大于35'
 	 elseif(32 < utf8.strlen(pwd)) then
 		return false, '密码长度大于32'
 	elseif(true == sql_valid.valid(nickname)) then
 		return false, '昵称存在sql注入关键词'
 	elseif(true == sql_valid.valid(pwd)) then
 		return false, '密码存在sql注入关键词'
 	elseif(false == sgoly_users.users_exist(nickname)) then
 		return false, '不存在该用户: '..nickname
 	else
 		local sql = string.format("select users_pwd from sgoly.users where "
 			.."users_nickname = '%s' ;", nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			if(pwd == tmptable[1].users_pwd) then
 				return true, ''
 			else
 				return false, '密码不正确'
 			end
 		else
 			return false, '未知错误'
 		end
 	end
end

--[[
函数说明：
		函数作用：删除用户
		传入：nickname, pwd
		返回：如果成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
function sgoly_users.delete_user(nickname, pwd)
	printD("sgoly_users.delete_user(%s, %s)", nickname, pwd)
	printI("sgoly_users.delete_user(%s, pwd)", nickname)
	local duv, msg = delete_user_valid(nickname, pwd)
	if(false == duv) then
		return false, msg
	else
		local sql = string.format("delete from sgoly.users where "
			.."users_nickname = '%s' ;", nickname)
		local status = mysql_query(sql)
		if((0 == status.warning_count) and (1 <= status.affected_rows)) then
			return true, '删除用户成功'
		else
			return false, '未知错误'
		end
	end
end

 return sgoly_users