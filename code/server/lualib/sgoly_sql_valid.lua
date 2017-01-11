--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:58:09
 --]]

require "sgoly_printf"
local sgoly_sql_valid = {}

--[[
函数说明：
		函数作用：检查字符串是否包含注入语句
		传入：字符串str
		返回：false or true

--]]
function sgoly_sql_valid.valid(str)
	printD("sgoly_sql_valid.valid(%s)", str)
	local injectMap = {'or ',' or ', 'and ', ' and ', ' like ', ' where ', 
	' select ', ' delect ', ' update ',' drop ' }
	local cnt = 0
	for k, v in pairs(injectMap) do
		local x = string.find(str, v)
		if(nil ~= x) then
			cnt = cnt + 1
		end
	end
	if(0 == cnt) then 
		return false
	else
		return true
	end
end

return sgoly_sql_valid