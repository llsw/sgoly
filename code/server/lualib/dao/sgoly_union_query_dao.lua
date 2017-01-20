
--[[
 * @brief:		sgoly_union_query.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-19
--]]

require "sgoly_printf"
local union_query = require "sgoly_union_query"
local dao = {}

function dao.get_stamtents_from_MySQL(nickname, dt)
	local status = union_query.get_statmens_from_MySQL(nickname, dt)
	if status.err then
		return false, status.err
	end

	return true, status
end

function dao.get_count_statements_from_MySQL(nickname)
	local status = union_query.get_count_statements_from_MySQL(nickname)
	if status.err then
		return false, status.err
	end

	return true, status
end

return dao