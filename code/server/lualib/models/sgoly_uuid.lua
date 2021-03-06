
--[[
 * @brief:		sgoly_uuid.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-21
--]]
require "sgoly_query"

local model = {}

--!
--! @brief      查询用户一键注册自增长id
--!
--! @return     table	查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function model.select_uuid()
	local sql = "select uuid from uuid;"
	return mysql_query(sql)
end

--!
--! @brief      更新用户一键注册自增长id
--!
--! @param      uuid  用户一键注册自增长id
--!
--! @return     table	查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function model.update_uuid(uuid)
	local sql = string.format("update uuid set uuid = %d;", uuid)
	return mysql_query(sql)
end

return model