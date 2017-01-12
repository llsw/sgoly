--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-11 14:29:04
 --]]

require "sgoly_query"
require "sgoly_printf"
local dtvalid = require "sgoly_dateformat_valid"
 local signin_record = {}

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function exist_signin_record(nickname, dt)
	printD("exist_signin_record(%s, %s)", nickname, dt)
	local sql = string.format("select * from sgoly.signin_record where nickname "
		"= '%s' and signin_date = '%s' ", nickname, dt)
	local tmptable = mysql_query(sql)
 	if(1 == #tmptable) then
 		return false
 	else
 		return false
 	end
end

--[[
函数说明：
		函数作用：
		传入参数：nickname(昵称), dt(日期)
		返回参数：false和msg(错误信息)或true和uid(昵称对应的用户的id)
--]]
function set_valid(nickname, dt)
	printD("set_valid(%s, %s)", nickname, dt)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == dt) or ("" == dt)) then
		return false, "日期空值错误"
	else
		local res, msg = dtvalid.valid(dt)
		if(false == res) then
			return false, msg
		else
			local sql = string.format("select users_id from sgoly.users where "
				.."users_nickname = '%s' ;" nickname)
			local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return tmptable[1].users_id, ""
 		else
 			return false, "不存在该用户"
 		end
	end		
end

 --[[
 函数说明：
 		函数作用：签到记录
 		传入参数：nickname(昵称)和dt(日期)
 		返回参数：true和空字符串或者false和错误信息提示
 --]]
 function signin_record.set(nickname, dt)
 	printD("signin_record.set(%s, %s)", nickname, dt)
 	printI("signin_record(%s, %s)", nickname, dt)
 	local res, msg = set_valid(nickname, dt)
 	if(false == res) then
 		return false, msg
 	else
 		local sql = string.format("insert into sgoly.signin_record(null, %s, %d, "
 			.."%s);")
 	end
 end