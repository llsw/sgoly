--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: -- test
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
local sgoly_union_query_server = require "sgoly_union_query_server"
local sgoly_uuid_server = require "sgoly_uuid_server"
local sgoly_rank_server = require "sgoly_rank_server"
local saf_ser = require "sgoly_safe_server"
local head_ser = require "sgoly_head_server"
local sign_in_ser = require "sgoly_sign_in_server"
local skynet = require "skynet"

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
		函数作用：get users id
		传入参数：nickname
		返回参数：(false, err_msg) or (true, true_value)
--]]
function dat_ser.get_uid(nickname)
	return use_ser.select_uid(nickname)
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
	return use_ser.update_nickname(old_nic, new_nick, pwd)
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
	return use_ser.update_pwd(nic, old_pwd, new_pwd)
end

--[[
函数说明：
		函数作用：初始化用户金币数额
		传入参数：nickname(用户你从), money(金币数额),
				 img_name(图片名称), path(图片路径, 不需要可设置为: nil )
		返回参数：ture和成功提示信息 或者 false 和错误信息
--]]
function dat_ser.usr_init(nickname, money, img_name, path)
	printD("dat_ser.usr_init(%s, %d, %s, %s)", nickname, money, img_name, path)
	printI("dat_ser.usr_init(%s, %d, %s, %s)", nickname, money, img_name, path)
	tag1, msg1 = acc_ser.insert(nickname, money)
	tag2, msg2 = head_ser.insert(nickname, img_name, path)
	if(not tag1) then
		return false, msg1
	elseif(not tag2) then
		return false, msg2
	else
		return true, "初始化用户信息成功"
	end
end

--[[
函数说明：
		函数作用：dell users and users conf
		传入参数：nickname(用户昵称), pwd(密码)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.del_usr(nickname, pwd)
	printD(" dat_ser.del_usr(%s, %s)", nickname, pwd)
	printI(" dat_ser.del_usr(%s, %s)", nickname, pwd)
	return use_ser.delete(nickname, pwd)
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
		函数作用：get users account money
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function dat_ser.get_money(nickname)
	printD("dat_ser.get_money(%s)", nickname)
	return acc_ser.select_money(nickname)
end

--[[
函数说明：
		函数作用：更新用户账户金币数额
		传入参数：nickname(用户你从), money(金币数额)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.upd_acc(nickname, money)
	printD("dat_ser.up_acc(%s, %d)", nickname, money)
	printI("dat_ser.up_acc(%s, %d)", nickname, money)
	return acc_ser.update_money(nickname, money)
end

--!
--! @brief      查询用结算
--!
--! @param      nickname  用户名
--! @param      dt        日期
--!
--! @return     bool, table	执行是否成功、执行结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-20
--!
function dat_ser.get_statments_from_MySQL(nickname, dt)
	printD("dat_ser.get_statements_from_mysql(%s)", nickname)
	printI("dat_ser.get_statements_from_mysql(%s)", nickname)
	if not nickname or not dt then
		return false, "Args nil"
	end

	local ok, result = sgoly_union_query_server.get_stamtents_from_MySQL(nickname, dt)
	if #result > 0 then

		return ok, 
		{
			winMoney = result[1].win, 
			costMoney = result[1].cost, 
			playNum = result[1].times, 
			winNum = result[1].win_times, 
			maxWinMoney = result[1].single_max, 
			serialWinNum = result[1].conti_max,
		}

	end
	
	local today = os.date("%Y-%m-%d")

	if dt == today then
		day_io_ser.insert(nickname, 0, 0, today)
		day_tim_ser.insert(nickname, 0, 0, today)
		day_max_ser.insert(nickname, 0, 0, today)
	end

	return true, 
	{
		winMoney = 0, 
		costMoney = 0, 
		playNum = 0, 
		winNum = 0, 
		maxWinMoney = 0, 
		serialWinNum = 0,
	}
end

--!
--! @brief      更新用户结算
--!
--! @param      nickname      用户名
--! @param      winMoney      中奖金额
--! @param      costMoney     消耗金额
--! @param      playNum       抽奖次数
--! @param      winNum        中奖次数
--! @param      maxWinMoney   最大中奖金额
--! @param      serialWinNum  连续中奖次数
--! @param      dt            日期
--!
--! @return     bool, table	执行是否成功、执行结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-20
--!
function dat_ser.update_statments_to_MySQL(nickname, winMoney, costMoney, playNum, winNum, maxWinMoney, serialWinNum, dt)
	if not nickname or not dt then
		return false, "Args nil"
	end
	local ok, result = day_io_ser.updateS(nickname, winMoney, costMoney, dt)
	if not ok then
		printE("error:%s", reslut)
		return ok, result
	end

	ok, result = day_tim_ser.updateS(nickname, playNum, winNum, dt)
	if not ok then
		printE("error:%s", reslut)
		return ok, result
	end

	ok, result = day_max_ser.updateS(nickname, maxWinMoney, serialWinNum, dt)
	if not ok then
		printE("error:%s", reslut)
		return ok, result
	end

	return true, "Save statments to MySQL success"
	
end


--!
--! @brief      统计用户结算
--!
--! @param      nickname  用户名
--!
--! @return     bool, table	执行是否成功、执行结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function dat_ser.get_count_statements_from_MySQL(nickname, dt)
	if not nickname then
		return false, "Args nil"
	end
	local ok, result = sgoly_union_query_server.get_count_statements_from_MySQL(nickname, dt)
	if #result > 0 then

		return ok, 
		{
			winMoney = result[1].win, 
			costMoney = result[1].cost, 
			playNum = result[1].times, 
			winNum = result[1].win_times, 
			maxWinMoney = result[1].single_max, 
			serialWinNum = result[1].conti_max,
		}

	end
end

--!
--! @brief      更新用户金钱
--!
--! @param      nickname  用户名
--! @param      money     用户金钱
--!
--! @return     bool, table	执行是否成功、执行结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function dat_ser.upadate_money_to_MySQL(nickname, money)
	local ok, result = acc_ser.update_money_s(nickname, money)
	return ok, result
	
end

--!
--! @brief      查询用户一键注册自增长id
--!
--! @return     bool, table		执行是否成功、查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function dat_ser.select_uuid()	
	return sgoly_uuid_server.select_uuid()
end

--!
--! @brief      更新用户一键注册自增长id
--!
--! @param      uuid  用户一键注册自增长id
--!
--! @return     bool, table		执行是否成功、查询结果
--! 
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function dat_ser.update_uuid(uuid)
	return sgoly_uuid_server.update_uuid(uuid)
end

--!
--! @brief      保存排行榜到MySQL
--!
--!	@paaram		rank_type 	排行榜类型
--! @param      rank  		排行榜table
--! @param      args  		用户数据table
--! @param      date  		日期
--!
--! @return     bool, string		执行是否成功、查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function dat_ser.save_rank_to_MySQL(rank_type, rank, args, date)
	return sgoly_rank_server.save_rank_to_MySQL(rank_type, rank, args, date)
end

--!
--! @brief      从MySQL中查询排行榜
--!
--! @param      rank_type  排行绑类型 "serialWinNum"或"winMoney"
--! @param      date       The date
--!
--! @return     bool, table		执行是否成功、查询结果
--! 
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function dat_ser.get_rank_from_MySQL(rank_type, date)
	return sgoly_rank_server.get_rank_from_MySQL(rank_type, date)
end

--[[
函数说明：
		函数作用：检查用户是否已设置保险柜密码
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function dat_ser.seted_safe_pwd(nickname)
	printD("dat_ser.seted_safe_pwd(%s)", nickname)
	printI("dat_ser.seted_safe_pwd(%s)", nickname)
	local tag, status = saf_ser.select(nickname)
	if( false == tag) then
		return false, status
	else
		if(nil == status) then
			return false, "未设置保险柜密码"
		else
			return true, "已设置保险柜密码"
		end
	end
end

--[[
函数说明：
		函数作用：设置保险柜密码
		传入参数：nickname(用户昵称), passwd(用户保险柜密码)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.set_safe_pwd(nickname, passwd)
	printD("dat_ser.set_safe_pwd(%s, %s)", nickname, passwd)
	printI("dat_ser.set_safe_pwd(%s)", nickname)
	local init_saf_money = 0
	return saf_ser.insert(nickname, passwd, init_saf_money)
end

--[[
函数说明：
		函数作用：打开保险柜
		传入参数：nickname(用户昵称), passwd(用户保险柜密码)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.open_saf(nickname, passwd)
	printD("dat_ser.open_saf(%s, %s)", nickname, passwd)
	printI("dat_ser.open_saf(%s)", nickname)
	local tag, status = saf_ser.select_passwd(nickname)
	if(false == tag) then
		return false, status
	else
		if(status == passwd) then
			return true, "保险柜打开成功"
		else
			return false, "保险柜打开不成功"
		end
	end
end

--[[
函数说明：
		函数作用：查询保险柜余额
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function dat_ser.query_saf_money(nickname)
	printD("dat_ser.query_saf_money(%s)", nickname)
	printI("dat_ser.query_saf_money(%s)", nickname)
	return saf_ser.select_money(nickname)
end

--[[
函数说明：
		函数作用：存金币到保险柜
		传入参数：nickname(用户昵称), money(金币数额)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.save_money_2saf(nickname, money)
	printD("dat_ser.save_money_2saf(%s, %d)", nickname, money)
	printI("dat_ser.save_money_2saf(%s, %d)", nickname, money)
	local tag1, src_money = saf_ser.select_money(nickname)
	if(false == tag1) then
		return false, src_money
	end
	local dst_money = src_money + money
	local tag2, status = saf_ser.update_money(nickname, dst_money)
	if(false == tag2) then
		printD("dat_ser.save_money_2saf() 存钱失败 status = %s", status)
		return false, "存金币失败"
	else
		return true, "存金币成功"
	end
end

--[[
函数说明：
		函数作用：从保险柜取出金币
		传入参数：nickname(用户昵称), money(金币数额)
		返回参数：(false, err_msg) or (true, 要取数额)
--]]
function dat_ser.get_saf_money(nickname, money)
	printD("dat_ser.get_saf_money(%s, %d)", nickname, money)
	printI("dat_ser.get_saf_money(%s, %d)", nickname, money)
	local tag1, src_money = saf_ser.select_money(nickname)
	if(false == tag1) then
		return false, src_money
	end
	if(src_money < money) then
		return false, "取金币失败,余额小于要取数额"
	end
	local dst_money = src_money - money
	local tag2, status = saf_ser.update_money(nickname, dst_money)
	if(false == tag2) then
		printD("dat_ser.get_saf_money() 取金币失败 status = %s", status)
		return false, "取金币失败"
	else
		return true, money
	end
end

--[[
函数说明：
		函数作用： 更改保险柜密码
		传入参数：nickname(用户昵称), old_pwd(旧密码), new_pwd(新密码)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.cha_saf_pwd(nickname, old_pwd, new_pwd)
	printD("dat_ser.cha_saf_pwd(%s, %s, %s)", nickname, old_pwd, new_pwd)
	printI("dat_ser.cha_saf_pwd(%s)", nickname)
	return saf_ser.update_passwd(nickname, old_pwd, new_pwd)
end

--[[
函数说明：
		函数作用：设置用户头像
		传入参数：nickname(用户昵称), img_name(头像名称), path(头像路径, 可为空值)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.set_head(nickname, img_name, path)
	if(nil ~= path) then
		printD("dat_ser.set_head(%s, %s, %s)", nickname, img_name, path)
		printI("dat_ser.set_head(%s, %s, %s)", nickname, img_name, path)
	else
		printD("dat_ser.set_head(%s, %s)", nickname, img_name)
		printI("dat_ser.set_head(%s, %s)", nickname, img_name)
	end
	return head_ser.insert(nickname, img_name, path)
end

--[[
函数说明：
		函数作用：更改用户头像名称
		传入参数：nickname(用户昵称), new_img_name(新头像名称)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.cha_img_name(nickname, new_img_name)
	printD("dat_ser.cha_img_name(%s, %s)", nickname, new_img_name)
	printI("dat_ser.cha_img_name(%s, %s)", nickname, new_img_name)
	return head_ser.update_img_name(nickname, new_img_name)
end

--[[
函数说明：
		函数作用：更改头像路径
		传入参数：nickname(用户昵称) new_path(新头像路径)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.cha_path(nickname, new_path)
	printD("dat_ser.cha_path(%s, %s)", nickname, new_path)
	printI("dat_ser.cha_path(%s, %s)", nickname, new_path)
	return head_ser.update_path(nickname, new_path)
end

--[[
函数说明：
		函数作用：获取用户头像名称
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function dat_ser.get_img_name(nickname)
	printD("dat_ser.get_img_name(%s)", nickname)
	printI("dat_ser.get_img_name(%s)", nickname)
	return head_ser.select_img_name(nickname)
end

--[[
函数说明：
		函数作用：获取用户头像路径
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function dat_ser.get_img_path(nickname)
	printD("dat_ser.get_img_path(%s)", nickname)
	printI("dat_ser.get_img_path(%s)", nickname)
	return head_ser.select_path(nickname)
end

--[[
函数说明：
		函数作用：签到
		传入参数：uid(u用户id), date(日期)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function dat_ser.sign(uid, date)
	printD("sign_in_ser.sign(%d, %s)", uid, date)
	printI("sign_in_ser.sign(%d, %s)", uid, date)
	return sign_in_ser.insert(uid, date)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function dat_ser.query_sign(uid)
	
end

return dat_ser