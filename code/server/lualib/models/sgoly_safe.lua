--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about safe model
 * @DateTime:    2017-02-03 11:44:19
--]]

require "sgoly_query"
require "sgoly_printf"

local safe = {}

--[[
函数说明：
		函数作用：insert user money value to safe
		传入参数：uid(users id), passwd(pass word), money(money value)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe.insert(uid, passwd, money)
	local sql = string.format([[insert into sgoly.safe(uid, passwd, money) 
								value(%d, '%s', %d)]], uid, passwd, money)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "插入成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：update users safe passwd
		传入参数：uid(users id), newpasswd(users new pass word)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe.update_passwd(uid, newpasswd)
	local sql = string.format("update sgoly.safe set passwd = '%s' where uid = "
								.." %d ;", newpasswd, uid)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：update users money value
		传入参数：uid(users id),  newmoney(users new money value)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe.update_money(uid, newmoney)
	local sql = string.format("update sgoly.safe set money = %d where uid = "
								.." %d ;", newmoney, uid)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：get users safe all info
		传入参数：uid(用户id)
		返回参数：(false, err_msg) or (true, value)
--]]
function safe.select(uid)
	local sql = string.format("select * from sgoly.safe where uid = %d ;",
								uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：select users pass word
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function safe.select_passwd(uid)
	local sql = string.format("select passwd from sgoly.safe where uid = %d ;",
								uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].passwd
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：select users money value
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function safe.select_money(uid)
	local sql = string.format("select money from sgoly.safe where uid = %d ;",
								uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].money
	else
		return false, 0
	end
end

return safe
