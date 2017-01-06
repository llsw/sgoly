--[[
@by:王光汉
--]]

require "sgoly_query"
require "sgoly_printf"
local sgoly_users = {}

local function sql_valid(str)
	printI("sql_valid str =%s", str)
	local injectMap = {'or ',' or ', 'and ', ' and ', ' like ', ' where ', ' select ', 
	' delect ', ' update ',' drop ' }
	local cnt = 0
	for k, v in pairs(injectMap) do
		local x = string.find(str, v)
		if(nil ~= x) then
			cnt = cnt + 1
		end
	end
	if(1 <= cnt) then 
		return false
	else
		return true
	end
end


--[[
函数说明：
		函数作用：字符utf8字符长度计算
		传入：字符串input
		返回：字符串长度cnt

--]]
function string.utf8len(input)
	printI("string.utf8len input =%s",input)
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

--[[
函数说明：
		函数作用：参数检查
		传入：users_nickname, users_pwd
		返回：如果参数无问题返回true和空字符串，否则返回false和错误信息

--]]
local function parameters_valid(users_nickname, users_pwd)
	printI("parameters_valid users_nickname =%s, users_pwd =%s", users_nickname, 
 		users_pwd)
	if((nil == users_nickname) or (nil == users_pwd)) then
		return false, '无昵称或密码参数错误'
	elseif(("" == users_nickname) or ("" == users_pwd)) then
		return false, '昵称或密码为空'
	elseif(36 <= utf8len(users_nickname)) then
		return false, '昵称长度超过35个字符'
	elseif(17 <= utf8len(users_pwd)) then
		return false, '密码长度超过16个字符'
	elseif(true == sql_valid(users_nickname)) then
		return false, '昵称存在sql注入关键词'
	elseif(true == sql_valid(users_pwd)) then
		return false, '密码存在sql注入关键词'
	else
		return true, ''
	end
end

--[[
函数说明：
		函数作用：用户登录
		传入：users_nickname, users_pwd
		返回：如果登录成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
function sgoly_users.login(users_nickname, users_pwd)
	printI("sgoly_users.login users_nickname =%s, users_pwd =%s", users_nickname, 
 		users_pwd)
 	local lv, msg = parameters_valid(users_nickname, users_pwd)
 	if(true == lv) then
 		local sql = string.format("select users_pwd from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			if(users_pwd == tmptable[1].users_pwd) then
 				return true, ''
 			else
 				return false, '密码不正确'
 			end
 		else
 			return false, '未知错误'
 		end
 	else
 		return false, msg
 	end
 end

--[[
函数说明：
		函数作用：用户注册
		传入：users_nickname, users_pwd
		返回：如果注册成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
 function sgoly_users.register(users_nickname, users_pwd)
 	printI("sgoly_users.register users_nickname =%s, users_pwd =%s", users_nickname, 
 		users_pwd)
 	local rv, msg = parameters_valid(users_nickname, users_pwd)
 	if(true == rv) then
 		local sql = string.format("select * from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return false, '昵称已被使用'
 		else
 			sql = string.format("insert into sgoly.users values('%', '%s')",
 				users_nickname, users_pwd)
 			local status = mysql_query(sql)
 			if((0 == status.warning_count) and (1 <= status.affected_rows)) then
				return true, ''
			else
				return false, '未知错误'
			end
 		end
 	else
 		return false, msg
 	end
 end

--[[
函数说明：
		函数作用：更改昵称
		传入：users_nickname
		返回：如果注册成功返回true和空字符串两个参数，否则返回false和错误信息
--]]
 function sgoly_users.change_nickname(old_users_nickname, new_users_nickname)
 	printI("sgoly_users.change_nickname old_users_nickname =%s, "
 		.."new_users_nickname =%s", old_users_nickname, new_users_nickname)
 	if((nil ~= ))

 end

 return sgoly_users