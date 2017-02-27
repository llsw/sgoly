--[[
* @Version:     1.0
* @Author:      GitHubNull
* @Email:       641570479@qq.com
* @github:      GitHubNull
* @Description: 这是用户当日最大值数据管理模块
* @DateTime:    2017-01-16 16:17:20
--]]

require "sgoly_query"
require "sgoly_printf"

local day_max = {}

--[[
函数说明：
		函数作用：插入day_max的数据
		传入参数：uid(用户id), single_max(单次最大), conti_max(连续获奖最大值), dt(日期)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function day_max.insert(uid, single_max, conti_max, dt)
	local sql = string.format([[insert into sgoly.day_max(id, uid, single_max, 
								conti_max, s_date) value(null, %d, %d, %d, '%s'
								)]], uid, single_max, conti_max, dt)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "插入成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：更新单次最大值
		传入参数：uid(用户id), single_max(单次最大), dt(日期)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function day_max.update_single_max(uid, single_max, dt)
	local sql = string.format("update sgoly.day_max set single_max = %d where "
							  .."uid = %d and s_date = '%s'; ", single_max, 
							  uid, dt)
	local status = mysql_query(sql)
 	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：更新连续获奖次数最大值
		传入参数：uid(用户id), conti_max(连续获奖最大值), dt(日期)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function day_max.update_conti_max(uid, conti_max, dt)
	local sql = string.format("update sgoly.day_max set conti_max = %d where "
							  .."uid = %d and s_date = '%s'; ", conti_max, 
							  uid, dt)
	local status = mysql_query(sql)
 	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：查询指定的用户昵称以及日期对应的day_max数据
		传入参数：uid(用户id), dt(日期)
		返回参数：(false, err_msg) or (true, value)
--]]
function day_max.select(uid, dt)
	local sql = string.format("select * from sgoly.day_max where uid = %d and "
							   .."s_date = '%s' ;", uid, dt)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：查询指定用户昵称以及日期对应的当日最大单次获奖金币值
		传入参数：uid(用户id), dt(日期)
		返回参数：(false, err_msg) or (true, value)
--]]
function day_max.select_single_max(uid, dt)
	local sql = string.format("select single_max from sgoly.day_max where uid = "
							   .."%d and s_date = '%s' ;", uid, dt)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].single_max
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：查询指定用户昵称以及日期对应的当日连续获奖最大次数
		传入参数：uid(用户id), dt(日期)
		返回参数：(false, err_msg) or (true, value)
--]]
function day_max.select_conti_max(uid, dt)
	local sql = string.format("select conti_max from sgoly.day_max where uid = "
							   .."%d and s_date = '%s' ;", uid, dt)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].conti_max
	else
		return false, status.err
	end
end

--!
--! @brief      更新用户单次中最大奖金额和最大连续中奖次数
--!
--! @param      nickname    用户名
--! @param      single_max  单次中最大奖金额
--! @param      conti_max   最大连续中奖次数
--! @param      dt          日期
--!
--! @return     table       查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function day_max.updateS(nickname, single_max, conti_max, dt)
	local sql = string.format(
		[[
			UPDATE users AS u
	  	LEFT JOIN day_max AS dmax ON u.id = dmax.uid
		SET dmax.single_max = %d,
				dmax.conti_max = %d
		WHERE
			u.id = %d
		AND dmax.s_date = '%s';
	]],single_max, conti_max, nickname, dt)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return true, status
end


return day_max