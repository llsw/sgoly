--[[
* @Version:     1.0
* @Author:      GitHubNull
* @Email:       641570479@qq.com
* @github:      GitHubNull
* @Description: This is about users head model
* @DateTime:    2017-02-04 15:43:19
--]]

require "sgoly_query"
require "sgoly_printf"

local head = {}

--[[
函数说明：
		函数作用：save usrs head info
		传入参数：uid(users id), img_name(image name), path(image path)
		返回参数：mysql excute status
--]]
function head.insert(uid, img_name, path)
	local sql = ""
	if(nil == path) then
		sql = string.format("insert into sgoly.head value(%d, '%s', null) ;",
								uid, img_name)
	else
		sql = string.format("insert into sgoly.head value(%d, '%s', '%s') ;",
								uid, img_name, path)
	end
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：update users head img_name
		传入参数：uid(users id), new_img_name(new image name)
		返回参数：mysql excute status
--]]
function head.update_img_name(uid, new_img_name)
	local sql = string.format("update sgoly.head set img_name = '%s' where uid "
								.."= %d ;", new_img_name, uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：update users img file path
		传入参数：uid(users id), new_path(new image path)
		返回参数：mysql excute status
--]]
function head.update_path(uid, new_path)
	local sql = string.format("update sgoly.head set path = '%s' where uid "
								.."= %d ;", new_path, uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select all of head info
		传入参数：uid(users id)
		返回参数：mysql excute status
--]]
function head.select(uid)
	local sql = string.format("select * from sgoly.head where uid = %d ;", uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select img_name of head info
		传入参数：uid(users id)
		返回参数：mysql excute status
--]]
function head.select_img_name(uid)
	local sql = string.format("select img_name from sgoly.head where uid = %d ;"
							   , uid)
	return mysql_query(sql)
end

--[[
函数说明：
		函数作用：select path of head info
		传入参数：uid(users id)
		返回参数：mysql excute status
--]]
function head.select_path(uid)
	local sql = string.format("select path from sgoly.head where uid = %d ;", 
								uid)
	return mysql_query(sql)
end

return head