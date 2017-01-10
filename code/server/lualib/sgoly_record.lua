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

local sgoly_record = {}
local users = require "sgoly_users"


function add_valid(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max)
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
	else
		return true, ""
	end		
end

function sgoly_record.add(nickname, win_money, cost_money, win_times, times, 
							single_max, continuous_max)
	printD("sgoly_record.add... %s, %d, %d, %d, %d, %d, %d", nickname, 
			win_money, cost_money, win_times, times, single_max, continuous_max)
	local res, msg = add_valid(nickname, win_money, cost_money, win_times, times
								, single_max, continuous_max)
	if(false == res) then
		return false, msg
	else
		
	end
end