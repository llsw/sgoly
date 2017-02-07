--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about game award
 * @DateTime:    2017-02-07 10:50:22
--]]

require "sgoly_query"

local award = {}

--[[
函数说明：
		函数作用：get award money
		传入参数：type(award name and rank)
		返回参数：mysql excute status
--]]
function award.select_money(type)
	local sql = string.format("select money from sgoly.award where type = '%s' ;",
								type)
	return mysql_query(sql)
end

return award