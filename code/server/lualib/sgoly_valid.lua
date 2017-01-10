--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:57:20
 --]]

local valid_conf = require "sgoly_valid_conf"
local utf8 = require "sgoly_utf8"
require sql_valid require "sgoly_sql_valid"
local sgoly_valid = {}

function sgoly_valid.users_nickname(users_nickname)
	if(nil == users_nickname) then
		return false, "nil value"
	else
		local len = utf8.strlen(users_nickname)
		if(nil == users_nickname) then
			return false, "nil value"
		elseif(len > valid_conf.users_nickname.maxlen) then
			return false, "昵称长度超过"..valid_conf.users_nickname.maxlen.."个字符"
		elseif(len < valid_conf.users_nickname.minlen)
			return false, "昵称长度少于"..valid_conf.users_nickname.maxlen.."个字符"
		elseif(true == sql_valid.valid(users_nickname)) then
			return false, "昵称存在sql注入关键词"
		else
			return true, ""
		end
	end
end

function sgoly_valid.users_pwd(users_pwd)
	if(nil == users_pwd) then
		return false, "nil value"
	else
		local len = utf8.strlen(users_pwd)
		if(len > valid_conf.users_pwd.maxlen) then
			return false, "密码长度超过"..valid_conf.users_pwd.maxlen.."个字符"
		elseif(len < valid_conf.users_pwd.minlen)
			return false, "密码长度少于"..valid_conf.users_pwd.minlen.."个字符"
		elseif(true == sql_valid.valid(users_pwd)) then
			return false, "密码存在sql注入关键词"
		else
			return true, ""
		end
	end
end

require sgoly_valid