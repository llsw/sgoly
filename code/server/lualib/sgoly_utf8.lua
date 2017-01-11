--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:57:11
 --]]

require "sgoly_printf"
local sgoly_utf8 = {}

--[[
函数说明：
		函数作用：字符utf8字符长度计算
		传入：字符串input
		返回：字符串长度cnt

--]]
function string.utf8len(input)
	printD("string.utf8len(%S)",input)
    local left = string.len(input)
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function sgoly_utf8.strlen(str)
	return string.utf8len(str)
end

return sgoly_utf8