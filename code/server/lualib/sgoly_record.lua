--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:28:48
 --]]

require "sgoly_query"
require "sgoly_printf"
local utf8 = require "sgoly_utf8"
local sql_valid = require "sgoly_sql_valid"
local dtv = require "sgoly_dateformat_valid"

local sgoly_record = {}
local users = require "sgoly_users"

--[[
函数说明：
		函数作用：获取用户id
		传入参数：nickname
		返回参数：用户id或nil
--]]
function get_users_id(nickname)
	local sql = string.format("select users_id from sgoly.users where "
		.."users_nickname = '%s' ;", nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return tmptable[1].users_id
 		else
 			return nil
 		end
end

--[[
函数说明：
		函数作用：add函数参数检查
		传入参数：add的所有参数
		返回参数：通过则返回true和空字符串，否则返回false和错误信息
--]]
function add_valid(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max, record_date)
	if(nil == nickname) then
		return false, "nil nickname"
	elseif(nil == win_money) then
		return false, "nil win_money"
	elseif(nil == cost_money) then
		return false, "nil cost_money"
	elseif(nil == win_times) then
		return false, "nil win_times"
	elseif(nil == times) then
		return false, "nil times"
	elseif(nil == single_max) then
		return false, "nil single_max"
	elseif(nil == continuous_max) then
		return false, "nil continuous_max"
	elseif(false == sql_valid.valid(nickname)) then
		return false, "sql valid false"
	elseif(false == sql_valid.valid(win_money)) then
		return false, "sql valid win_money"
	elseif(false == sql_valid.valid(cost_money)) then
		return false, "sql valid cost_money"
	elseif(false == sql_valid.valid(win_times)) then
		return false, "sql valid win_times"	
	elseif(false == sql_valid.valid(times)) then
		return false, "sql valid times"	
	elseif(false == sql_valid.valid(single_max)) then
		return false, "sql valid single_max"
	elseif(false == sql_valid.valid(continuous_max)) then
		return false, "sql valid continuous_max"
	elseif(false == users.users_exist(nickname)) then
		return false, "不存在该用户: "..nickname
	elseif(false == dtv.valid(record_date)) then
		return false, "日期格式非法"
	else
		return true ""
	end			
end

--[[
函数说明：
		函数作用：add a new record for users
		传入参数：nickname, win_money, cost_money, win_times, times, single_max, 
				continuous_max
		返回参数：true and "" or false and errormsg  
--]]
function sgoly_record.add(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max)
	printD("sgoly_record.add... %s, %d, %d, %d, %d, %d, %d", nickname, 
			win_money, cost_money, win_times, times, single_max, continuous_max)
	local res, msg = add_valid(nickname, win_money, cost_money, win_times, times
								, single_max, continuous_max)
	if(false == res) then
		return false, msg
	else
		local dt = os.date("%Y-%m-%d")
		local sql = string.format("select record_date from sgoly.record where "
				.."record_date = '%s' ", dt)
		local tmp = mysql_query(sql)
		if(1 <= #tmp) then
			return false, "记录已存在"
		else
			sql = string.format("select users_id from sgoly.users where" 
				.."users_nickname = '%s' ", nickname)
			tmp = mysql_query(sql)
			record_uid = tmp[1].users_id
			sql = string.format("insert into sgoly.record(null, '%d', '%d', "
				.."'%d', '%d', '%d', '%d', '%s' );", record_uid, win_money, 
				cost_money, win_times, times, single_max, continuous_max, dt)
			tmp = mysql_query(sql)
			if((0 == tmp.warning_count) and (1 <= tmp.affected_rows)) then
				return true, "插入记录成功"
			else
				return false, '未知错误'
			end
		end
	end
end

--[[
函数说明：
		函数作用：检查del函数的合法性
		传入参数：nickname（用户昵称）, dt（日期 格式：2017-01-11）
		返回参数：true and "" or false and errormsg
--]]
function del_valid(nickname, dt)
	if(nil == nickname) then
		return false, "nil nickname"
	elseif(nil == dt) then
		return false, "nil dt"
	elseif(false == sql_valid.valid(nickname)) then
		return false, "sql valid nickname"
	elseif(false == sql_valid.valid(dt)) then
		return false, "sql valid dt"
	elseif(false == users.users_exist(nickname)) then
		return false, "不存在该用户: "..nickname
	elseif(false == dtv.valid(dt)) then
		return false, "日期格式非法"
	else
		return true, "参数检查通过"
	end
end

--[[
函数说明：
		函数作用：删除用户的战绩数据
		传入参数：nickname（用户昵称）, dt（日期 格式：2017-01-11）
		返回参数：true and "" or false and errormsg
--]]
function sgoly_record.del(nickname, dt)
	local res, msg= del_valid(nickname, dt)
	if(false == res) then
		return false, msg
	else
		local tmpuid = get_users_id(nickname)
		local sql = string.format("delete * from sgoly.record where "
				.."record_uid = '%s' and record_date = '%s' ;", tmpuid, dt)
		local status = mysql_query(sql)
		if((0 == status.warning_count) and (1 <= status.affected_rows)) then
			return true, "删除战绩成功"
		else
			return false, "未知错误"
		end
	end
end

--[[
函数说明：
		函数作用：检测get的参数合法性
		传入参数：nickname（用户昵称）, dt（日期 格式：2017-01-11）
		返回参数：true and "" or false and errormsg
--]]
function get_valid(nickname, dt)
	if(nil == nickname) then
		return false, "nil nickname"
	elseif(nil == dt) then
		return false, "nil dt"
	elseif(false == sql_valid.valid(nickname)) then
		return false, "sql valid nickname"
	elseif(false == sql_valid.valid(dt)) then
		return false, "sql valid dt"
	elseif(false == users.users_exist(nickname)) then
		return false, "不存在该用户: "..nickname
	elseif(false == dtv.valid(dt)) then
		return false, "日期格式非法"
	else
		return true, "参数检查通过"
	end
end

--[[
函数说明：
		函数作用：获取用户战绩数据
		传入参数：nickname（用户昵称）, dt（日期 格式：2017-01-11）
		返回参数：nil or 获取用户战绩数据table
--]]
function sgoly_record.get(nickname, dt)
	local res, msg = get_valid(nickname, dt)
	if(false == res) then
		return false, msg
	else
		local uid = get_users_id(nickname)
		local sql = string.format("select * from sgoly.record where record_uid "
			.."= '%s' record_date = '%s' ;", uid, dt)
		local tmptable = mysql_query(sql)
		return tmptable
	end
end

--[[
函数说明：
		函数作用：update函数参数检查
		传入参数：update的所有参数
		返回参数：通过则返回true和空字符串，否则返回false和错误信息
--]]
function update_valid(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max, dt)
	if(nil == nickname) then
		return false, "nil nickname"
	elseif(nil == win_money) then
		return false, "nil win_money"
	elseif(nil == cost_money) then
		return false, "nil cost_money"
	elseif(nil == win_times) then
		return false, "nil win_times"
	elseif(nil == times) then
		return false, "nil times"
	elseif(nil == single_max) then
		return false, "nil single_max"
	elseif(nil == continuous_max) then
		return false, "nil continuous_max"
	elseif(false == sql_valid.valid(nickname)) then
		return false, "sql valid false"
	elseif(false == sql_valid.valid(win_money)) then
		return false, "sql valid win_money"
	elseif(false == sql_valid.valid(cost_money)) then
		return false, "sql valid cost_money"
	elseif(false == sql_valid.valid(win_times)) then
		return false, "sql valid win_times"	
	elseif(false == sql_valid.valid(times)) then
		return false, "sql valid times"	
	elseif(false == sql_valid.valid(single_max)) then
		return false, "sql valid single_max"
	elseif(false == sql_valid.valid(continuous_max)) then
		return false, "sql valid continuous_max"
	elseif(false == users.users_exist(nickname)) then
		return false, "不存在该用户: "..nickname
	elseif(false == dtv.valid(dt)) then
		return false, "日期格式非法"
	else
		return true ""
	end		
end

--[[
函数说明：
		函数作用：更新用户战绩数据
		传入参数：nickname, win_money, cost_money, win_times, times, single_max, 
				 continuous_max
		返回参数：
--]]
function sgoly_record.update(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max, dt)
	printD("sgoly_record.update... %s, %d, %d, %d, %d, %d, %d", nickname, 
			win_money, cost_money, win_times, times, single_max, continuous_max)
	local res, msg = update_valid(nickname, win_money, cost_money, win_times, 
		times, single_max, continuous_max, dt)
	if(false == res) then
		return false, msg
	else
		local uid = get_users_id(nickname)
		local sql = string.format("update sgoly.record set win_money = '%s', "
			.."cost_money = '%s',  win_times = '%s',  times = '%s', single_max ="
			.." '%s', continuous_max = '%s' where  record_uid = '%s' and "
			.."record_date = '%s' ;", win_money, cost_money, win_times, times, 
							single_max, continuous_max, uid, dt)
		local status = mysql_query(sql)
		if((0 == status.warning_count) and (1 <= status.affected_rows)) then
			return true, "更新战绩数据成功"
		else
			return false, "未知错误"
		end
	end
end

return sgoly_record