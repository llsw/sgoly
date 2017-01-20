--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个检查 day_max 模块参数的模块
 * @DateTime:    2017-01-17 10:11:08
 --]]
 
require "sgoly_printf"
local day_max = require "sgoly_day_max"

local day_max_dao = {}

--[[
函数说明：
		函数作用：检查day_max.insert的参数,并调用执行day_max.insert
		传入参数：uid, single_max(单次最大), conti_max(最大连续值), dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关消息
--]]
function day_max_dao.insert(uid, single_max, conti_max, dt)
	printD("day_max_dao.insert(%d, %d, %d, %s)", uid, single_max, conti_max, dt)
 	printI("day_max_dao.insert(%d, %d, %d, %s)", uid, single_max, conti_max, dt)
	local status = day_max.insert(uid, single_max, conti_max, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "插入用户当日最值数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查day_max.update_single_max的参数,并调用执行
				 day_max.update_single_max
		传入参数：uid, single_max(单次最大), dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function day_max_dao.update_single_max(uid, single_max, dt)
 	printD("day_max_dao.update_single_max(%d, %d, %s)", uid, single_max, dt)
 	printI("day_max_dao.update_single_max(%d, %d, %s)", uid, single_max, dt)
	local status = day_max.update_single_max(uid, single_max, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "更新用户当日单次最大数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查day_max.update_conti_max的参数,并调用执行
				 day_max.update_conti_max
		传入参数：uid, conti_max(最大连续值), dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function day_max_dao.update_conti_max(uid, conti_max, dt)
 	printD("day_max_dao.update_conti_max(%d, %d, %s)", uid, conti_max, dt)
 	printI("day_max_dao.update_conti_max(%d, %d, %s)", uid, conti_max, dt)
	local status = day_max.update_conti_max(uid, conti_max, dt)
	if((0 == status.warning_count) and (1 == status.affected_rows)) then
		return true, "更新用户当日连续最大数据成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查day_max.select的参数,并调用执行day_max.select
		传入参数：uid, dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function day_max_dao.select(uid, dt)
 	printD("day_max_dao.select(%d, %s)", uid, dt)
 	printI("day_max_dao.select(%d, %s)", uid, dt)
	local status = day_max.select(uid, dt)
	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查day_max.select_single_max的参数,并调用执行
				 day_max.select_single_max
		传入参数：uid, dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function day_max_dao.select_single_max(uid, dt)
 	printD("day_max_dao.select_single_max(%d, %s)", uid, dt)
 	printI("day_max_dao.select_single_max(%d, %s)", uid, dt)
	local status = day_max.select_single_max(uid, dt)
	if(1 == #status) then
		return true, status[1].single_max
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：检查day_max.select_conti_max的参数,并调用执行
				 day_max.select_conti_max
		传入参数：uid, dt(日期)
		返回参数：执行结果的正确与否的布尔值和相关返回值
--]]
function day_max_dao.select_conti_max(uid, dt)
 	printD("day_max_dao.select_conti_max(%d, %s)", uid, dt)
 	printI("day_max_dao.select_conti_max(%d, %s)", uid, dt)
	local status = day_max.select_conti_max(uid, dt)
	if(1 == #status) then
		return true, status[1].conti_max
	else
		return false, status.err
	end
end

function day_max_dao.updateS(nickname, single_max, conti_max, dt)
	local status = day_max.updateS(nickname, single_max, conti_max, dt)
	if status.err then
		return false, status.err
	end

	return true, status
end


return day_max_dao