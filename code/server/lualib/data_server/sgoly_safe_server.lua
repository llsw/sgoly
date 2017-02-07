--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about safe_server
 * @DateTime:    2017-02-03 16:23:28
--]]

require "sgoly_printf"
local safe_dao = require "sgoly_safe_dao"
local users_server = require "sgoly_users_server"

local safe_server = {}

--[[
函数说明：
		函数作用：insert user money value to safe and valid args
		传入参数：nickname(users nickname), passwd(pass word), money(money value)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe_server.insert(nickname, passwd, money)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	elseif((nil == passwd) or ("" == passwd)) then
 		return false, "保险柜空密码值错误"
 	elseif(nil == money) then
 		return false, "金币空值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return safe_dao.insert(uid, passwd, money)
	 	end
	end
end

--[[
函数说明：
		函数作用：update users safe passwd and valid args
		传入参数：nickname(users nickname), oldpasswd(old pass word), 
				 newpasswd(users new passwd)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe_server.update_passwd(nickname, oldpasswd, newpasswd)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	elseif((nil == oldpasswd) or ("" == oldpasswd)) then
 		return false, "旧保险柜空密码值错误"
 	elseif((nil == newpasswd) or ("" == newpasswd)) then
 		return false, "新保险柜空密码值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		local tag, passwd = safe_dao.select_passwd(uid)
	 		if(tag == false) then
	 			return false, passwd
	 		else
	 			if(passwd ~= oldpasswd) then
	 				return false, "旧密码错误"
	 			else
	 				return safe_dao.update_passwd(uid, newpasswd)
	 			end
	 		end
	 	end
	end
end

--[[
函数说明：
		函数作用：update users money value and valid args
		传入参数：nickname(users nickname), newmoney(new money value)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function safe_server.update_money(nickname, newmoney)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	elseif(nil == newmoney) then
 		return false, "新金币空值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return safe_dao.update_money(uid, newmoney)
	 	end
	end
end

--[[
函数说明：
		函数作用：select safe_info word and valid args
		传入参数：nickname(users nickname)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function safe_server.select(nickname)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return safe_dao.select(uid)
	 	end
	end
end

--[[
函数说明：
		函数作用：select users pass word and valid args
		传入参数：nickname(users nickname)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function safe_server.select_passwd(nickname)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return safe_dao.select_passwd(uid)
	 	end
	end
end

--[[
函数说明：
		函数作用：select users money value and valid args
		传入参数：nickname(users nickname)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function safe_server.select_money(nickname)
	if((nil == nickname) or ("" == nickname)) then
 		return false, "昵称空值错误"
 	else
	 	local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return safe_dao.select_money(uid)
	 	end
	end
end

return safe_server