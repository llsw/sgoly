--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about head_server
 * @DateTime:    2017-02-04 16:42:35
--]]

require "sgoly_printf"
local head_dao = require "sgoly_head_dao"
local users_server = require "sgoly_users_server"

local head_server = {}

--[[
函数说明：
		函数作用：插入用户头像数据
		传入参数：nickname(用户昵称), img_name(头像名称), path(头像路径)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_server.insert(nickname, img_name, path)
	if(nil ~= path) then
		printD("head_server.insert(%s, %s, %s)", nickname, img_name, path)
		printI("head_server.insert(%s, %s, %s)", nickname, img_name, path)
	else
		printD("head_server.insert(%s, %s)", nickname, img_name)
		printI("head_server.insert(%s, %s)", nickname, img_name)
	end
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == img_name) or ("" == img_name)) then
		return false, "头像名称空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.insert(uid, img_name, path)
	 	end
	end
end

--[[
函数说明：
		函数作用：更改用户头像名称
		传入参数：nickname(用户昵称), new_img_name(新头像名称)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_server.update_img_name(nickname, new_img_name)
	printD("head_server.update_img_name(%s, %s)", nickname, new_img_name)
	printI("head_server.update_img_name(%s, %s)", nickname, new_img_name)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == new_img_name) or ("" == new_img_name)) then
		return false, "新头像名称空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.update_img_name(uid, new_img_name)
	 	end
	end
end

--[[
函数说明：
		函数作用：更改头像路径
		传入参数：nickname(用户昵称) new_path(新头像路径)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function head_server.update_path(nickname, new_path)
	printD("head_server.update_path(%s, %s)", nickname, new_path)
	printI("head_server.update_path(%s, %s)", nickname, new_path)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	elseif((nil == new_path) or ("" == new_path)) then
		return false, "新头像路径空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.update_path(uid, new_path)
	 	end
	end
end

--[[
函数说明：
		函数作用：获取用户头像所有信息
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_server.select(nickname)
	printD("head_server.select(%s)", nickname)
	printI("head_server.select(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.select(uid)
	 	end
	end
end

--[[
函数说明：
		函数作用：获取用户头像名称
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_server.select_img_name(nickname)
	printD("head_server.select_img_name(%s)", nickname)
	printI("head_server.select_img_name(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.select_img_name(uid)
	 	end
	end
end

--[[
函数说明：
		函数作用：获取用户头像路径
		传入参数：nickname(用户昵称)
		返回参数：(false, err_msg) or (true, true_values)
--]]
function head_server.select_path(nickname)
	printD("head_server.select_path(%s)", nickname)
	printI("head_server.select_path(%s)", nickname)
	if((nil == nickname) or ("" == nickname)) then
		return false, "昵称空值错误"
	else
		local tag, uid = users_server.select_uid(nickname)
	 	if(false == tag ) then
	 		return false, "用户不存在"
	 	else
	 		return head_dao.select_path(uid)
	 	end
	end
end

return head_server