--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about sign in server
 * @DateTime:    2017-02-06 11:30:23
--]]

require "sgoly_printf"
local sign_in = require "sgoly_sign_in"

local sign_in_server = {}

--[[
函数说明：
		函数作用：insert users sign in data
		传入参数：uid(u用户id), date(日期)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function sign_in_server.insert(uid, date)
	if(nil == uid) then
		return false, "uid nil"
	elseif((nil == date) or ("" == date)) then
		return false, "date nil"
	else
		local status = sign_in.insert(uid, date)
		if(status.err) then
			return false, "签到失败"
		else
			return true, "签到成功"
		end
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function sign_in_server.select_date(uid)
	local tmptab = {}
	if(nil == uid) then
		return false, "uid nil"
	else
		local status = sign_in.select_date(uid)
		if(0 >= #status) then
			return true, tmptab
		else
			for k, v in pairs(status) do
				table.insert(tmptab, v.s_date)
			end
			return true, tmptab
		end
	end
end

return sign_in_server