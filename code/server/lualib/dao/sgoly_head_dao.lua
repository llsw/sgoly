--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about head dao
 * @DateTime:    2017-02-04 16:23:21
--]]

require "sgoly_printf"
local head = require "sgoly_head"

local head_dao = {}

--[[
函数说明：
		函数作用：save usrs head info and valid return values
		传入参数：uid(users id), img_name(image name), path(image path)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_dao.insert(uid, img_name, path)
	if(nil ~= path) then
		printD("head_dao.insert(%d, %s,%s", uid, img_name, path)
		printI("head_dao.insert(%d, %s,%s", uid, img_name, path)
	else
		printD("head_dao.insert(%d, %s)", uid, img_name)
		printI("head_dao.insert(%d, %s)", uid, img_name)
	end
	local status = head.insert(uid, img_name, path)
	if(status.err) then
		return false, status.err
	else
		return true, "插入用户头像数据成功"
	end
end

--[[
函数说明：
		函数作用：update users head img_name and valid return values
		传入参数：uid(users id), new_img_name(new image name)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_dao.update_img_name(uid, new_img_name)
	printD("head_dao.update_img_name(%d, %s)", uid, new_img_name)
	printI("head_dao.update_img_name(%d, %s)", uid, new_img_name)
	local status = head.update_img_name(uid, new_img_name)
	if(status.err) then
		return false, status.err
	else
		return true, "更改用户头像数据成功"
	end
end

--[[
函数说明：
		函数作用：update users head path and valid return values
		传入参数：uid(users id), new_path(new image path)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_dao.update_path(uid, new_path)
	printD("head_dao.update_path(%d, %s)", uid, new_path)
	printI("head_dao.update_path(%d, %s)", uid, new_path)
	local status = head.update_path(uid, new_path)
	if(status.err) then
		return false, status.err
	else
		return true, "更改用户头像文件路径数据成功"
	end
end

--[[
函数说明：
		函数作用：select head info and valid return value
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_dao.select(uid)
	printD("head_dao.select(%d)", uid)
	printI("head_dao.select(%d)", uid)
	local status = head.select(uid)
	if(1 == #status) then
		return true, status
	else
		return false, "select head err"
	end
end

--[[
函数说明：
		函数作用：select img_name of head info and valid return value
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_dao.select_img_name(uid)
	printD("head_dao.select_img_name(%d)", uid)
	printI("head_dao.select_img_name(%d)", uid)
	local status = head.select_img_name(uid)
	if(1 == #status) then
		return true, status[1].img_name
	else
		return false, "select img_name err"
	end
end

--[[
函数说明：
		函数作用：select path of head info and valid return value
		传入参数：uid(users id)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_dao.select_path(uid)
	printD("head_dao.select_path(%d)", uid)
	printI("head_dao.select_path(%d)", uid)
	local status = head.select_path(uid)
	if(1 == #status) then
		return true, status[1].path
	else
		return false, "select path err"
	end
end

return head_dao