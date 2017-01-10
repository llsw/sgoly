--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 该模块用于检查日期格式的合法性，检查给定的日期字符串是否符合形如：
 				 2017-01-10这种格式
 * @DateTime:    2017-01-10 17:03:52
 --]]

local mydate_valid = {}

--[[
函数说明：
		函数作用：检查日期格式，是否符合2017-01-10这种格式
		传入参数：日期字符串
		返回参数：true和提示检查通过的字符串，或者false和检查不通过的提示字符串
--]]
function mydate_valid.valid(dt)
	local year = tonumber(string.sub(dt, 1, 4))
	local momth = tonumber(string.sub(dt, 6, 7))
	local day = tonumber(string.sub(dt, 9, 10))
	if(nil == year) then
		return false, "年: " .. (string.sub(dt, 1, 4)) .. " 非法年份格式"
	elseif(nil == momth) then
		return false, "月: " .. (string.sub(dt, 6, 7)) .." 非法月份格式"
	elseif(nil == day) then
		return false, "日: " .. (string.sub(dt, 9, 10)) .. " 非法日期格式"
	elseif(2016 >= year) then
		return false, "年: " .. (string.sub(dt, 1, 4)) .. " 早于当前日期年份"
	elseif((1 > momth) or (13 <= momth)) then
		return false, "月: " .. (string.sub(dt, 6, 7)) .." 月份范围非法"
	elseif((1 > day) or (31 < day)) then
		return false, "日: " .. (string.sub(dt, 9, 10)) .. " 日期范围非法"
	else
		return true, dt .." 是合法格式日期"
	end
end

return mydate_valid