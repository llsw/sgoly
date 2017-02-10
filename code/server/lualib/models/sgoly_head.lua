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
		返回参数：(false, err_msg) or (true, true_msg)
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
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "插入成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：update users head img_name
		传入参数：uid(users id), new_img_name(new image name)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head.update_img_name(uid, new_img_name)
	local sql = string.format("update sgoly.head set img_name = '%s' where uid "
								.."= %d ;", new_img_name, uid)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：update users img file path
		传入参数：uid(users id), new_path(new image path)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head.update_path(uid, new_path)
	local sql = string.format("update sgoly.head set path = '%s' where uid "
								.."= %d ;", new_path, uid)
	local status = mysql_query(sql)
	if(0 == status.warning_count) then
		return true, "更新成功"
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：select all of head info
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function head.select(uid)
	local sql = string.format("select * from sgoly.head where uid = %d ;", uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1]
	else
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：select img_name of head info
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function head.select_img_name(uid)
	local sql = string.format("select img_name from sgoly.head where uid = %d ;"
							   , uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].img_name
	else
		printD("%s", status)
		return false, status.err
	end
end

--[[
函数说明：
		函数作用：select path of head info
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, value)
--]]
function head.select_path(uid)
	local sql = string.format("select path from sgoly.head where uid = %d ;", 
								uid)
	local status = mysql_query(sql)
 	if(1 == #status) then
		return true, status[1].path
	else
		return false, status.err
	end
end

return head