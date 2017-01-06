require "sgoly_query"

local function sql_valid(str)
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

local function parameters_valid(users_nickname, users_pwd)
	if((nil == users_nickname) or (nil == users_pwd)) then
		return false, '无用户名或密码参数错误'
	elseif(("" == users_nickname) or ("" == users_pwd)) then
		return false, '用户名或密码为空'
	elseif(true == sql_valid(users_nickname)) then
		return false, '用户名存在sql注入关键词'
	elseif(true == sql_valid(users_pwd)) then
		return false, '密码存在sql注入关键词'
	else
		return true
	end
end

function login(users_nickname, users_pwd)
 	local lv, msg = parameters_valid(users_nickname, users_pwd)
 	if(true == lv) then
 		local sql = string.format("select users_pwd from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			if(users_pwd == tmptable[1].users_pwd) then
 				return true
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

--]]


 function register(users_nickname, users_pwd)
 	local rv = parameters_valid(users_nickname, users_pwd)
 	if(true == rv) then
 		local sql = string.format("select * from sgoly.users where "
 			.."users_nickname = '%s' ;", users_nickname)
 		local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return false, '用户名已被使用'
 		else

 		end
 	else
 		return false, '存在sql注入关键词'
 	end
 end