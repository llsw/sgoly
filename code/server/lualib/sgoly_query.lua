
--[[
 * @brief: sgoly_query.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
local cluster = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "sgoly_printf"

function redis_query(args, dbn)

	local redispool = cluster.proxy("cluster_database", ".redispool")
	local redis_cmd = cjson.encode(args)
	local cmd = assert(args[1])
	args[1] = dbn
	local call_ok, call_result = xpcall(skynet.call, xpcall_error, redispool, "lua", cmd, redis_cmd, table.unpack(args))
	return call_result
end

function mysql_query(sql, dbn)
	local mysqlpool = cluster.proxy("cluster_database", ".mysqlpool")
	local call_ok, call_result = xpcall(skynet.call, xpcall_error, mysqlpool, "lua", "execute", sql, dbn)
	return call_result
end