--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about safe_dao
 * @DateTime:    2017-02-03 15:37:32
--]]

require "sgoly_printf"
local safe = require "sgoly_safe"

local safe_dao = {}

--[[
函数说明：
		函数作用：insert user money value to safe and valid return values
		传入参数：uid(users id), passwd(pass word), money(money value)
		返回参数：(false, status.err) or (true, "插入用户保险柜数据成功")
--]]
function safe_dao.insert(uid, passwd, money)
	local status = safe.insert(uid, passwd, money)
	if(status.err) then
		return false, status.err
	else
		return true, "插入用户保险柜数据成功"
	end
end

--[[
函数说明：
		函数作用：update users safe passwd and valid return value
		传入参数：uid(users id), newpasswd(users new pass word)
		返回参数：(false, status.err) or (true, "更改保险柜密码成功")
--]]
function safe_dao.update_passwd(uid, newpasswd)
	local status = safe.update_passwd(uid, newpasswd)
	if(status.err) then
		return false, status.err
	else
		return true, "更改保险柜密码成功"
	end
end

--[[
函数说明：
		函数作用：update users money value and valid return value
		传入参数：uid(users id),  newmoney(users new money value)
		返回参数：(false, status.err) or (true, "更改保险柜金币数值成功")
--]]
function safe_dao.update_money(uid, newmoney)
	local status = safe.update_money(uid, newmoney)
	if(status.err) then
		return false, status.err
	else
		return true, "更改保险柜金币数值成功"
	end
end

--[[
函数说明：
		函数作用：select safe_info word and valid return values
		传入参数：uid(users id)
		返回参数：(false, status.err) or (true, status[1].passwd)
--]]
function safe_dao.select(uid)
	local status = safe.select(uid)
	if(status.err) then
		return false, status.err
	else
		if(1 == #status) then
			return true, status
		else
			return false, nil
		end
	end
end

--[[
函数说明：
		函数作用：select users _safe_pass word and valid return values
		传入参数：uid(users id)
		返回参数：(false, status.err) or (true, status[1].passwd)
--]]
function safe_dao.select_passwd(uid)
	local status = safe.select_passwd(uid)
	if(status.err) then
		return false, status.err
	else
		return true, status[1].passwd
	end
end

--[[
函数说明：
		函数作用：select users money value and valid return values
		传入参数：uid(users id)
		返回参数：(false, status.err) or (true, status[1].money)
--]]
function safe_dao.select_money(uid)
	local status = safe.select_money(uid)
	if(status.err) then
		return false, status.err
	else
		return true, status[1].money
	end
end

return safe_dao