--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是用户基本信息数据管理模块
 * @DateTime:    2017-01-16 14:27:19
 --]]

require "sgoly_query"
require "sgoly_printf"

 local users = {}

 --[[
 函数说明：
 		函数作用：插入新用户数据
 		传入参数：nickname(昵称), pwd(密码)
 		返回参数：sql语句执行状态
 --]]
 function users.insert(nickname, pwd)
 	printD("users.insert(%s, %s)", nickname, pwd)
 	printI("users.insert(%s)", nickname)
 	local sql = string.format("insert into sgoly.users value(null, '%s', '%s')",
 				nickname, pwd)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：删除用户数据
 		传入参数：nickname(昵称)
 		返回参数：sql语句执行状态
 --]]
 function users.delete(nickname)
 	printD("users.delete(%s)", nickname)
 	printI("users.delete(%s)", nickname)
 	local sql = string.format("delete from sgoly.users where "
			.."nickname = '%s' ;", nickname)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改用户昵称
 		传入参数：old_nickname(旧昵称), new_nickname(新昵称)
 		返回参数：sql语句执行状态
 --]]
 function users.update_nickname(old_nickname, new_nickname)
 	printD("users.update_nickname(%s, %s)", old_nickname, new_nickname)
 	printI("users.update_nickname(%s, %s)", old_nickname, new_nickname)
 	local sql = string.format("update sgoly.users set nickname = '%s' "
 				.."where nickname = '%s' ;", new_nickname, old_nickname)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：更改用户密码
 		传入参数：nickname(昵称), new_pwd(新密码)
 		返回参数：sql语句执行状态
 --]]
 function users.update_pwd(nickname, new_pwd)
 	printD("users.update_pwd(%s, %s)", nickname, new_pwd)
 	printI("users.update_pwd(%s)", nickname)
 	sql = string.format("update sgoly.users set pwd = '%s' "
 				.."where nickname = '%s' ;", new_pwd, nickname)
 	return mysql_query(sql)
 end

--[[
函数说明：
		函数作用：选出指定用户名的所有信息
		传入参数：nickname(用户昵称)
		返回参数：用户信息表
--]]
function users.select(nickname)
	printD("users.select_users(%s)", nickname)
	printI("users.select_users(%s)", nickname)
	local sql = string.format("select * from sgoly.users where "
		.."nickname = '%s' ;", nickname)
 	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：选出指定用户名的id
		传入参数：nickname(用户昵称)
		返回参数：用户信息表
--]]
function users.select_uid(nickname)
	printD("users.select_uid(%s)", nickname)
	printI("users.select_uid(%s)", nickname)
	local sql = string.format("select id from sgoly.users where "
		.."nickname = '%s' ;", nickname)
 	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：选出指定用户名的pwd
		传入参数：nickname(用户昵称)
		返回参数：用户信息表
--]]
function users.select_pwd(nickname)
	printD("users.select_pwd(%s)", nickname)
	printI("users.select_pwd(%s)", nickname)
	local sql = string.format("select pwd from sgoly.users where "
		.."nickname = '%s' ;", nickname)
 	return mysql_query(sql)
end

return users