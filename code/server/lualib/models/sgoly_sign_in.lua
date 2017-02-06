--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about sign in model
 * @DateTime:    2017-02-06 10:18:38
--]]

require "sgoly_query"
require "sgoly_printf"

local sign_in = {}

--[[
函数说明：
		函数作用：insert users sign in data
		传入参数：uid(u用户id), date(日期)
		返回参数：mysql excute status
--]]
function sign_in.insert(uid, date)
	local sql = string.format("insert into sgoly.sign_in value(%d, %s", uid, 
								date)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select users sign_in date
		传入参数：uid(u用户id)
		返回参数：(false, err_msg) or (true, true_value)
--]]
function sign_in.select_date(uid)
	local sql = string.format([["select s_date 
								 from sgoly.sign_in 
								 where uid = %d 
								 order by
								 			s_date desc
								 limit 7 ;
								]]
								, uid)
	return mysql_query(sql)
end

return sign_in