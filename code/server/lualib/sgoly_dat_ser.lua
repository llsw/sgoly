--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-17 16:33:15
 --]]

local use_ser = require "sgoly_users_server"
local acc_ser = require "sgoly_account_server"
local day_io_ser = require "sgoly_day_io_server"
local day_max_ser = require "sgoly_day_max_server"
local day_tim_ser = require "sgoly_day_times_server"
local max_awa_ser = require "sgoly_max_award_server"
local max_tim_awa_ser = require "sgoly_max_times_award_server"
local sin_awa_ser = require "sgoly_single_award_server"

local dat_ser = {}

--[[
函数说明：
		函数作用：用户注册
		传入参数：nickname(用户你从), pwd(密码)
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.register(nickname, pwd)
	printD("dat_ser.register(%s, %s)", nickname, pwd)
	printI("dat_ser.register(%s)", nickname)
	return use_ser.insert(nickname, pwd)
end

--[[
函数说明：
		函数作用：用户登录
		传入参数：nickname(用户你从), pwd(密码)
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.login(nickname, pwd)
	printD("dat_ser.login(%s, %s)", nickname, pwd)
	printI("dat_ser.login(%s)", nickname)
	local tag, status = use_ser.select_pwd(nickname)
	if(false == tag) then
		return false, status
	elseif(status ~= pwd) then
		return false, "密码错误"
	else
		return true, "登录成功"
	end
end

--[[
函数说明：
		函数作用：更改用户的昵称
		传入参数：old_nic(旧昵称), new_nick()新昵称, pwd(密码)
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.cha_nic(old_nic, new_nick, pwd)
	printD("dat_ser.cha_nic(%s, %s, %s)", old_nic, new_nick, pwd)
	printI("dat_ser.cha_nic(%s, %s, %s)", old_nic, new_nick, pwd)
	local tag, status = use_ser.select_pwd(old_nic)
	if(false == tag) then
		return false, status
	elseif(status ~= pwd) then
		return false, "密码错误"
	else
		return use_ser.update_nickname(old_nic, new_nick)
	end
end

--[[
函数说明：
		函数作用：更改用户的密码
		传入参数：nic(用户昵称), old_pwd(旧的密码), new_pwd(新密码)
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.cha_pwd(nic, old_pwd, new_pwd)
	printD("dat_ser.cha_pwd(%s, %s, %s)", nic, old_pwd, new_pwd)
	printI("dat_ser.cha_pwd(%s, %s, %s)", nic, old_pwd, new_pwd)
	local tag, status = use_ser.select_pwd(nic)
	if(false == tag) then
		return false, status
	elseif(status ~= pwd) then
		return false, "密码错误"
	else
		return use_ser.update_pwd(nic, new_pwd)
	end
end

--[[
函数说明：
		函数作用：初始化用户金币数额
		传入参数：nickname(用户你从), money(金币数额)
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.usr_init(nickname, money)
	printD("dat_ser.usr_init(%s, %d)", nickname, money)
	printI("dat_ser.usr_init(%s, %d)", nickname, money)
	return acc_ser.insert(nickname, money)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function dat_ser.del_acc(nickname)
	printD("dat_ser.del_acc(%s)", nickname)
	printI("dat_ser.del_acc(%s)", nickname)
	return acc_ser.delete(nickname)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function dat_ser.del_usr(nickname, pwd)
	local tag, status = use_ser.select_pwd(nickname)
	if(false == tag) then
		return false, status
	elseif(status ~= pwd) then
		return false, "密码错误"
	else
		return use_ser.delete(nickname)
	end
end

--[[
函数说明：
		函数作用：获得排名对应的赢得的金币数额
		传入参数：award_name(排名项目名字), id(名次)
				 award_name 可选参数:max_award(当日获得金币数额最大的前n名的)
				 					max_times_award(当日获奖次数最大的前n名)
				 					single_award(单次获得金币最大的前n名)
		返回参数：true, 金币数额 或者 false, 错误信息
--]]
function dat_ser.get_award(award_name, id)
	printD("dat_ser.get_award(%s, %d)", award_name, id)
	printI("dat_ser.get_award(%s, %d)", award_name, id)
	if((nil == award_name) or ("" == award_name)) then
		return false, "排名项目名称为空错误"
	else
		if("max_award" == award_name) then
			return max_awa_ser.select(id)
		elseif("max_times_award" == award_name) then
			return max_tim_awa_ser.select(id)
		elseif("single_award" == award_name) then
			return sin_awa_ser.select(id)
		else
			return false, "不在查找范围"
		end
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function dat_ser.get_money(nickname)
	printD("dat_ser.get_money(%s)", nickname)
	return acc_ser.select_money(nickname)
end

return dat_ser