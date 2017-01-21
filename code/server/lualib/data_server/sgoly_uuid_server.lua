
--[[
 * @brief:		sgoly_uuid_server.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-21
--]]

local dao = require "sgoly_uuid_dao"

local server = {}
--!
--! @brief      查询用户一键注册自增长id
--!
--! @return     bool, table		执行是否成功、查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function server.select_uuid()
	local ok, result = dao.select_uuid()
	if ok then
		return ok, result[1].uuid
	end
	return ok, result
end

--!
--! @brief      更新用户一键注册自增长id
--!
--! @param      uuid  用户一键注册自增长id
--!
--! @return     bool, table		执行是否成功、查询结果
--! 
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function server.update_uuid(uuid)
	if not uuid then
		return false, "Args nil"
	end
	
	local ok, result = dao.update_uuid(uuid)
	if status.err then
		return false, status.err
	end
	return ok, result
end

return server