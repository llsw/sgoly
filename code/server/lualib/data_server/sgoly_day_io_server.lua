--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 16:10:18
 --]]

require "sgoly_printf"
local users_server = require "sgoly_users_server"
local day_io_dao = require "sgoly_day_io_dao"

local day_io_server = {}

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.insert(nickname, win, cost, dt)
	printD("day_io_server.insert(%s, %d, %d, %s)", nickname, win, cost, dt)
	printI("day_io_server.insert(%s, %d, %d, %s)", nickname, win, cost, dt)
	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.insert(uid, win, cost, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.update_win(nickname, win, dt)
 	printD("day_io_server.update_win(%s, %d, %s)", nickname, win, dt)
 	printI("day_io_server.update_win(%s, %d, %s)", nickname, win, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.update_win(uid, win, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.update_cost(nickname, win, dt)
 	printD("day_io_server.update_cost(%s, %d, %s)", nickname, win, dt)
 	printI("day_io_server.update_cost(%s, %d, %s)", nickname, win, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.update_cost(uid, win, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.select(nickname, dt)
 	printD("day_io_server.select(%s, %s)", nickname, dt)
 	printI("day_io_server.select(%s, %s)", nickname, dt)
	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.select(uid, win, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.select_win(nickname, dt)
 	printD("day_io_server.select_win(%s, %s)", nickname, dt)
 	printI("day_io_server.select_win(%s, %s)", nickname, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.select_win(uid, dt)
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function day_io_server.select_cost(nickname, dt)
 	printD("day_io_server.select_cost(%s, %s)", nickname, dt)
 	printI("day_io_server.select_cost(%s, %s)", nickname, dt)
 	local tag, uid = users_server.select_uid(nickname)
 	if(false == tag ) then
 		return false, nickname.." 不存在"
 	else
 		return day_io_dao.select_cost(uid, dt)
 	end
end

return day_io_server