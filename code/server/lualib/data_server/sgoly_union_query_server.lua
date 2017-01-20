
--[[
 * @brief:		sgoly_union_query_server.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-20
--]]

local union_query_dao = require "sgoly_union_query_dao"

local server = {}

function server.get_stamtents_from_MySQL(nickname, dt)
	local ok, result = union_query_dao.get_stamtents_from_MySQL(nickname, dt)
	if ok then
		return ok, result
	end
	return ok, {}
end

function server.get_count_statements_from_MySQL(nickname)
	local ok, result = union_query_dao.get_count_statements_from_MySQL(nickname)
	if ok then
		return ok, result
	end
	return ok, {}
end


return server