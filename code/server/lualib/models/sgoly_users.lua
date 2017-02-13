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
 		返回参数：(false, err_msg) or (true, true_msg)
 --]]
 function users.insert(nickname, pwd)
 	local sql = string.format("insert into sgoly.users value(null, '%s', '%s')",
 				nickname, pwd)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "插入成功"
	else
		return false, status.err
	end
 end

 --[[
 函数说明：
 		函数作用：删除用户数据
 		传入参数：nickname(昵称)
 		返回参数：(false, err_msg) or (true, true_msg)
 --]]
 function users.delete(nickname)
 	local sql = string.format("delete from sgoly.users where "
			.."nickname = '%s' ;", nickname)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "删除成功"
	else
		return false, status.err
	end
 end

 --[[
 函数说明：
 		函数作用：更改用户昵称
 		传入参数：id(users id), new_nickname(新昵称)
 		返回参数：(false, err_msg) or (true, true_msg)
 --]]
 function users.update_nickname(id, new_nickname)
 	local sql = string.format("update sgoly.users set nickname = '%s' "
 				.."where id = %d ;", new_nickname, id)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
 end

  --[[
 函数说明：
 		函数作用：更改用户密码
 		传入参数：id(users id), new_pwd(新密码)
 		返回参数：(false, err_msg) or (true, true_msg)
 --]]
 function users.update_pwd(id, new_pwd)
 	sql = string.format("update sgoly.users set pwd = '%s' "
 				.."where id = %d ;", new_pwd, id)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
 end

--[[
函数说明：
		函数作用：选出指定用户名的所有信息
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, value)
--]]
function users.select(nickname)
	local sql = string.format("select * from sgoly.users where "
		.."nickname = '%s' ;", nickname)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：选出指定用户名的id
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, value)
--]]
function users.select_uid(nickname)
	local sql = string.format("select id from sgoly.users where "
		.."nickname = '%s' ;", nickname)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].id
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：获取用户的昵称
		传入参数：id(用户id)
		返回参数：(false, err_msg) or (true, value)
--]]
function users.select_nickname(id)
	local sql = string.format("select nickname from sgoly.users where "
		.."id = %d ;", id)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].nickname
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：选出指定用户名的pwd
		传入参数：id(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function users.select_pwd(id)
	local sql = string.format("select pwd from sgoly.users where "
		.."id = %d ;", id)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].pwd
	else
		return false, status.err
	end
end

return users