--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about award_server
 * @DateTime:    2017-02-07 11:01:05
--]]

local award = require "sgoly_award"

local award_server = {}

--[[
函数说明：
		函数作用：get award money and valid args and return values
		传入参数：type
		返回参数：(false, err_msg) or (true, true_value)
--]]
function award_server.select_money(type)
	if((nil == type) or ("" == type)) then
		return false, "nil type"
	else
		local status = award.select_money(type)
		if(0 >= #status) then
			return false, nil
		else
			return true, status[1].money
		end
	end
end

return award_server