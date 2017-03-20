--[[
* @Version:     1.0
* @Author:      GitHubNull
* @Email:       641570479@qq.com
* @github:      GitHubNull
* @Description: 这是用户金币数额管理数据模块
* @DateTime:    2017-01-16 16:59:03
--]]

require "sgoly_query"
require "sgoly_printf"

local account = {}

--[[
函数说明：
		函数作用：插入用户的金币数额
		传入参数：id(用户id), money(金币数额)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function account.insert(id, money)
	local date = os.date("%Y-%m-%d %H:%M:%S")
	local sql = string.format("insert into sgoly.account(`id`, `money`, `update_time`) value(%d, %d, '%s')", id,
							   money, date)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "插入成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
	函数作用：更改用户的金币数额
	传入参数：id(用户id), money(金币数额)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function account.update_money(id, money)
	local date = os.date("%Y-%m-%d %H:%M:%S")
	local sql = string.format("update sgoly.account set money = %d, update_time = '%s' where id = "
							   .."%d ;", money, date, id)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
	函数作用：查询用户金币数额
	传入参数：id(用户id)
	返回参数：(false, err_msg) or (true, value)
--]]
function account.select_money(id)
	local sql = string.format("select money from sgoly.account where id = %d ;"
							   , id)
	local status = mysql_query(sql)
	if(1 == #status) then
		return true, status[1].money
	else
		return false, status.err
	end
end

--!
--! @brief      更新用户金钱
--!
--! @param      nickname  用户名
--! @param      money     用户金钱
--!
--! @return     table     执行结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function account.update_money_s(nickname, money)
	local sql = string.format(
				[[
					UPDATE account AS acc
					LEFT JOIN users AS u ON acc.id = u.id
					SET acc.money = %d
					WHERE
						u.id = %d;
				]], money, nickname)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	return true, status
end

--!
--! @brief      { function_description }
--!
--! @param      nickname  The nickname
--!
--! @return     { description_of_the_return_value }
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-03-20
--!
function account.update_recharge(uid, number)
	local sql = string.format(
				[[
					UPDATE account 
					SET account.recharge = %d
					WHERE
						account.id = %d;
				]],number, uid)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	return true, status
end

--!
--! @brief      Gets the recharge.
--!
--! @param      uid   The uid
--!
--! @return     The recharge.
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-03-20
--!
function account.get_recharge(uid)

	local sql = string.format(
				[[
					select account.recharge from account 
					WHERE
						account.id = %d;
				]], uid)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	return true, status
end

return account
