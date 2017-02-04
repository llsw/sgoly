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
		返回参数：mysql excute status
--]]
function safe.insert(uid, passwd, money)
	printD("safe.insert(%d, %s, %d)", uid, passwd, money)
	printI("safe.insert(%d, %s, %d)", uid, passwd, money)
	local sql = string.format("insert into sgoly.safe value(%d, '%s', %d)", uid,
								passwd, money)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：update users safe passwd
		传入参数：uid(users id), newpasswd(users new pass word)
		返回参数：mysql excute status
--]]
function safe.update_passwd(uid, newpasswd)
	printD("safe.update_passwd(%d, %s)", uid, newpasswd)
	printI("safe.update_passwd(%d)", uid)
	local sql = string.format("update sgoly.safe set passwd = '%s' where uid = "
								.." %d ;", newpasswd, uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：update users money value
		传入参数：uid(users id),  newmoney(users new money value)
		返回参数：mysql excute status
--]]
function safe.update_money(uid, newmoney)
	printD("safe.update_money(%d, %d)", uid, newmoney)
	printI("safe.update_money(%d, %d)", uid, newmoney)
	local sql = string.format("update sgoly.safe set money = %d where uid = "
								.." %d ;", newmoney, uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：查询保险柜所有信息
		传入参数：uid(用户id)
		返回参数：mysql excute status
--]]
function safe.select(uid)
	printD("safe.select(%d)", uid)
	printI("safe.select(%d)", uid)
	local sql = string.format("select * from sgoly.safe where uid = %d ;",
								uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select users pass word
		传入参数：uid(users id)
		返回参数：mysql excute status
--]]
function safe.select_passwd(uid)
	printD("safe.select_passwd(%d)", uid)
	printI("safe.select_passwd(%d)", uid)
	local sql = string.format("select passwd from sgoly.safe where uid = %d ;",
								uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select users money value
		传入参数：uid(users id)
		返回参数：mysql excute status
--]]
function safe.select_money(uid)
	printI("safe.select_money(%d)", uid)
	printD("safe.select_money(%d)", uid)
	local sql = string.format("select money from sgoly.safe where uid = %d ;",
								uid)
	return mysql_query(sql)
end

return safe