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
		传入参数： uid(user id), win_times(赢奖次数), times(玩游戏次数), 
				 dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.insert(uid, win_times, times, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif(nil == win_times) then
 		return false, "win_times空值错误"
 	elseif(nil == times) then
 		return false, "times空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.insert(uid, win_times, times, dt)
	 	end
 	end
end

--[[
函数说明：
		函数作用：更改用户当日玩游戏获奖次数
		传入参数：uid(user id), win_times(赢奖次数), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.update_win_times(uid, win_times, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif(nil == win_times) then
 		return false, "win_times空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.update_win_times(uid, win_times, dt)
	 	end
 	end
end

--[[
函数说明：
		函数作用：更改用户当日玩游戏次数
		传入参数：uid(user id), times(玩游戏次数), dt(日期)
		返回参数：true 或者 false , 正确或错误提示的字符串
--]]
function day_times_server.update_times(uid, times, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif(nil == times) then
 		return false, "times空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.update_times(uid, times, dt)
	 	end
 	end
end

--[[
函数说明：
		函数作用：查询用户某日赢奖次数和玩游戏次数
		传入参数：uid(user id), times(玩游戏次数), dt(日期)
		返回参数：true 或者 false , 某日赢奖次数和玩游戏次数 或 错误提示的字符串
--]]
function day_times_server.select(uid, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.select(uid, dt)
	 	end
 	end
end

--[[
函数说明：
		函数作用：查询用户某日赢奖次数
		传入参数：uid(user id), dt(日期)
		返回参数：true 或者 false , 赢奖次数 或 错误提示的字符串
--]]
function day_times_server.select_win_times(uid, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.select_win_times(uid, dt)
	 	end
 	end
end

--[[
函数说明：
		函数作用：查询用户某日玩游戏次数
		传入参数：uid(user id), dt(日期)
		返回参数：true 或者 false , 玩游戏次数 或 错误提示的字符串
--]]
function day_times_server.select_times(uid, dt)
 	if((nil == uid) or ("" == uid)) then
 		return false, "昵称空值错误"
 	elseif((nil == dt) or ("" == dt)) then
 		return false, "日期空值错误"
 	else
 		local tag, uid = users_server.select_uid(uid)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return day_times_dao.select_times(uid, dt)
	 	end
 	end
end

 --!
 --! @brief      更新用户抽奖次数和中奖次数
 --!
 --! @param      uid   用户名
 --! @param      times      抽奖次数
 --! @param      win_times  中奖次数
 --! @param      dt         日期
 --!
 --! @return     bool, table		执行是否成功、执行结果
 --!
 --! @author     kun si, 627795061@qq.com
 --! @date       2017-01-21
 --!
function day_times_server.updateS(nickname, times, win_times, dt)
	if not nickname or not times or not win_times or not dt then
		return false, "Args nil"
	end

 	return day_times_dao.updateS(nickname, times, win_times, dt)
end

return day_times_server