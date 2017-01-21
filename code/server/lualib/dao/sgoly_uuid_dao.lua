
--[[
 * @brief:		sgoly_uuid_dao.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-21
--]]

local model = require "sgoly_uuid"
local dao = {}

--!
--! @brief      查询用户一键注册自增长id
--!
--! @return     bool, table		执行是否成功、查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function dao.select_uuid()
	local status = model.select_uuid()
	if status.err then
		return false, status.err
	end
	return true, status
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
function dao.update_uuid(uuid)
	local status = model.update_uuid(uuid)
	if status.err then
		return false, status.err
	end
	return true, status
end

return dao 