--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个检查 sgoly_day_times 模块参数的模块
 * @DateTime:    2017-01-17 11:57:36
 --]]

 require "sgoly_printf"
 local day_times = require "sgoly_day_times"

 local day_times_dao = {}

--[[
函数说明：
		函数作用：检查 day_times.insert 函数的参数,并调用执行
		传入参数：uid(用户id), win_times(用户获奖次数), times(用户玩游戏次数), 
				 dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.insert(uid, win_times, times, dt)
	local status = day_times.insert(uid, win_times, times, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "插入用户当日获奖次数数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查 day_times.update_win_times 函数的参数,并调用执行
		传入参数：uid(用户id), win_times(用户获奖次数),  dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.update_win_times(uid, win_times, dt)
	local status = day_times.update_win_times(uid, win_times, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "更改用户当日获奖次数数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查 day_times.update_times 函数的参数,并调用执行
		传入参数：uid(用户id), times(用户玩游戏次数), dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.update_times(uid, times, dt)
	local status = day_times.update_times(uid, times, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "更改用户当日玩游戏次数数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查 day_times.select 函数的参数,并调用执行
		传入参数：uid(用户id), dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.select(uid, dt)
	local status = day_times.select(uid, dt)
	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查 day_times.select_win_times 函数的参数,并调用执行
		传入参数：uid(用户id), dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.select_win_times(uid, dt)
	local status = day_times.select_win_times(uid, dt)
	if(1 == #status) then
		return true, status[1].win_times
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查 day_times.select_times 函数的参数,并调用执行
		传入参数：uid(用户id), dt(日期)
		返回参数：正确与否的布尔值 以及相关其他相关返回值
--]]
function day_times_dao.select_times(uid, dt)
	local status = day_times.select_times(uid, dt)
	if(1 == #status) then
		return true, status[1].times
	else
		return false, status.err
	end
end

 --!
 --! @brief      更新用户抽奖次数和中奖次数
 --!
 --! @param      nickname   用户名
 --! @param      times      抽奖次数
 --! @param      win_times  中奖次数
 --! @param      dt         日期
 --!
 --! @return     bool, table		执行是否成功、执行结果
 --!
 --! @author     kun si, 627795061@qq.com
 --! @date       2017-01-21
 --!
function day_times_dao.updateS(nickname, times, win_times, dt)
	local status = day_times.updateS(nickname, times, win_times, dt)
	if status.err then
		return false, status.err
	end

	return true, status
end

return day_times_dao