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
		函数作用：指定的昵称和日期的签到数据是否存在
		传入参数：nickname(昵称), dt(日期 形如:2017-01-10)
		返回参数：存在则返回true 反之返回false
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
		函数作用：签到参数检查
		传入参数：nickname(昵称), dt(日期)
		返回参数：false和msg(错误信息)或true和uid(昵称对应的用户的id)
--]]
function signin_valid(nickname, dt)
	printD("signin_valid(%s, %s)", nickname, dt)
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
 			return true, tmptable[1].users_id
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
 function signin_record.signin(nickname, dt)
 	printD("signin_record.set(%s, %s)", nickname, dt)
 	printI("signin_record(%s, %s)", nickname, dt)
 	local res, msg = signin_valid(nickname, dt)
 	if(false == res) then
 		return false, msg
 	else
 		if(true == exist_signin_record(nickname, dt)) then
 			return true, "已签到成功"
 		else
 			local dt = os.date("%Y-%m-%d")
 			local sql = string.format("insert into sgoly.signin_record value(null, %d, %d, "
 			.."%s);", msg, 1, )
 			local status = mysql_query(sql)
 			if((0 == status.warning_count) and (1 <= status.affected_rows)) then
				return true, '已签到成功'
			else
				return false, status.err
			end
 		end
 	end
 end

--[[
函数说明：
		函数作用：获取日期对应的签到值,用于判定给定日期是否签到
		传入参数：日期(格式形如:2017-01-10)的一个table
		返回参数：true和返回日期对应签到与否的值的表 或者 false和msg错误信息
--]]
function signin_record.get_signin_days(nickname,dts)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local uid = users.get_uid(nickname)
		if(nil == uid) then
			return false, "不存在该用户"
		else
			for k, dt in pairs(dts) do
				local res, msg = dtvalid.valid(dt)
				if(false == res) do
					return false, msg
				end
			end
			local res_table = {}
			for k, dt in pairs(dts) do
				local sql = string.format("select count from sgoly.signin_record"
				.." where uid = '%d' and  signin_date = '%s' ;", uid, dt)
				local tmptable = mysql_query(sql)
				if(1 == #tmptable) then
					res_table[dt] = 1
				else
					res_table[dt] = 0
				end
			end
			return true, res_table
		end
	end
end

 return signin_record