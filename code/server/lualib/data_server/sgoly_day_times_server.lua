--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 16:21:06
 --]]

require "sgoly_printf"
local users_server = require "sgoly_users_server"
local day_times_dao = require "sgoly_day_times_dao"

local day_times_server = {}

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_times_server.insert(nickname, win_times, times, dt)
 	printD("day_times_server.insert(%s, %d, %d, %s)", nickname, win_times, times, dt)
 	printI("day_times_server.insert(%s, %d, %d, %s)", nickname, win_times, times, dt)

 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.insert(uid, win_times, times, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_times_server.update_win_times(nickname, win_times, dt)
 	printD("day_times_server.update_win_times(%s, %d, %s)", nickname, win_times, dt)
 	printI("day_times_server.update_win_times(%s, %d, %s)", nickname, win_times, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_times_dao.update_win_times(uid, win_times, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
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
		函数作用：
		传入参数：
		返回参数：
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
		函数作用：
		传入参数：
		返回参数：
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
		函数作用：
		传入参数：
		返回参数：
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