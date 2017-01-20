--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个管理用户一天收支情况的服务模块
 * @DateTime:    2017-01-17 16:10:18
 --]]

require "sgoly_printf"
local users_server = require "sgoly_users_server"
local day_io_dao = require "sgoly_day_io_dao"

local day_io_server = {}

--[[
函数说明：
		函数作用：插入用户一天的收支情况
		传入参数：nickname(昵称), win(收入), cost(支出), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_io_server.insert(nickname, win, cost, dt)
	printD("day_io_server.insert(%s, %d, %d, %s)", nickname, win, cost, dt)
	printI("day_io_server.insert(%s, %d, %d, %s)", nickname, win, cost, dt)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif(nil == win) then
		return false, "win空值错误"
	elseif(nil == cost) then
		return false, "cost空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.insert(uid, win, cost, dt)
	 	end
	end
end

--[[
函数说明：
		函数作用：更改用户1天收入数额
		传入参数：nickname(昵称), win(收入), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_io_server.update_win(nickname, win, dt)
 	printD("day_io_server.update_win(%s, %d, %s)", nickname, win, dt)
 	printI("day_io_server.update_win(%s, %d, %s)", nickname, win, dt)
 	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif(nil == win) then
		return false, "win空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.update_win(uid, win, dt)
	 	end
	end
end

--[[
函数说明：
		函数作用：更改用户1天的支出数额
		传入参数：nickname(昵称), cost(支出), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_io_server.update_cost(nickname, cost, dt)
 	printD("day_io_server.update_cost(%s, %d, %s)", nickname, cost, dt)
 	printI("day_io_server.update_cost(%s, %d, %s)", nickname, cost, dt)
 	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif(nil == win) then
		return false, "win空值错误"
	elseif(nil == cost) then
		return false, "cost空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.update_cost(uid, cost, dt)
	 	end
	end
end

--[[
函数说明：
		函数作用：查询用户某天的收支情况
		传入参数：nickname(昵称), dt(日期)
		返回参数：true 或者 false , 收支情况 或 错误提示的字符串
--]]
function day_io_server.select(nickname, dt)
 	printD("day_io_server.select(%s, %s)", nickname, dt)
 	printI("day_io_server.select(%s, %s)", nickname, dt)
 	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.select(uid, win, dt)
	 	end
	end
end

--[[
函数说明：
		函数作用：查询用户某天的收入情况
		传入参数：nickname(昵称), dt(日期)
		返回参数：true 或者 false , 收入数值 或 错误提示的字符串
--]]
function day_io_server.select_win(nickname, dt)
 	printD("day_io_server.select_win(%s, %s)", nickname, dt)
 	printI("day_io_server.select_win(%s, %s)", nickname, dt)
 	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.select_win(uid, dt)
	 	end
	end
end

--[[
函数说明：
		函数作用：查询用户某天的支出情况
		传入参数：nickname(昵称), dt(日期)
		返回参数：true 或者 false , 支出 或 错误提示的字符串
--]]
function day_io_server.select_cost(nickname, dt)
 	printD("day_io_server.select_cost(%s, %s)", nickname, dt)
 	printI("day_io_server.select_cost(%s, %s)", nickname, dt)
 	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_io_dao.select_cost(uid, dt)
	 	end
	end
end

function day_io_server.updateS(nickname, win, cost, dt)
	if not nickname or not win or not cost or not dt then
		return false, "Day_io_server.updateS args nil"
	end

 	return day_io_dao.updateS(nickname, win, cost, dt)

end

return day_io_server