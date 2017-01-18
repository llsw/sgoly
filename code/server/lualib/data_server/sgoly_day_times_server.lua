--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个管理用户当日获奖次数和玩游戏次数的模块
 * @DateTime:    2017-01-17 16:21:06
 --]]

require "sgoly_printf"
local users_server = require "sgoly_users_server"
local day_times_dao = require "sgoly_day_times_dao"

local day_times_server = {}

--[[
函数说明：
		函数作用：插入用户赢奖次数的玩游戏次数
		传入参数：nickname(用户昵称), win_times(赢奖次数), times(玩游戏次数), 
				 dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.insert(nickname, win_times, times, dt)
 	printD("day_times_server.insert(%s, %d, %d, %s)", nickname, win_times, times,
 	 dt)
 	printI("day_times_server.insert(%s, %d, %d, %s)", nickname, win_times, times,
 	 dt)

 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.insert(uid, win_times, times, dt)
 	end
end

--[[
函数说明：
		函数作用：更改用户当日玩游戏获奖次数
		传入参数：nickname(用户昵称), win_times(赢奖次数), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.update_win_times(nickname, win_times, dt)
 	printD("day_times_server.update_win_times(%s, %d, %s)", nickname, win_times,
 	 dt)
 	printI("day_times_server.update_win_times(%s, %d, %s)", nickname, win_times,
 	 dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.update_win_times(uid, win_times, dt)
 	end
end

--[[
函数说明：
		函数作用：更改用户当日玩游戏次数
		传入参数：nickname(用户昵称), times(玩游戏次数), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.update_times(nickname, times, dt)
 	printD("day_times_server.update_times(%s, %d, %s)", nickname, times, dt)
 	printI("day_times_server.update_times(%s, %d, %s)", nickname, times, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.update_times(uid, times, dt)
 	end
end

--[[
函数说明：
		函数作用：查询用户某日赢奖次数和玩游戏次数
		传入参数：nickname(用户昵称), times(玩游戏次数), dt(日期)
		返回参数：true 或者 false , 某日赢奖次数和玩游戏次数 或 错误提示的字符串
--]]
function day_times_server.select(nickname, dt)
 	printD("day_times_server.select(%s, %s)", nickname, dt)
 	printI("day_times_server.select(%s, %s)", nickname, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.select(uid, dt)
 	end
end

--[[
函数说明：
		函数作用：查询用户某日赢奖次数
		传入参数：nickname(用户昵称), dt(日期)
		返回参数：true 或者 false , 赢奖次数 或 错误提示的字符串
--]]
function day_times_server.select_win_times(nickname, dt)
 	printD("day_times_server.select_win_times(%s, %s)", nickname, dt)
 	printI("day_times_server.select_win_times(%s, %s)", nickname, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.select_win_times(uid, dt)
 	end
end

--[[
函数说明：
		函数作用：查询用户某日玩游戏次数
		传入参数：nickname(用户昵称), dt(日期)
		返回参数：true 或者 false , 玩游戏次数 或 错误提示的字符串
--]]
function day_times_server.select_times(nickname, dt)
 	printD("day_times_server.select_times(%s, %s)", nickname, dt)
 	printI("day_times_server.select_times(%s, %s)", nickname, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.select_times(uid, dt)
 	end
end

return day_times_server