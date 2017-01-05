
--[[
 * @brief: sgoly_query.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
local cluster = require "cluster"

function redis_query(args, dbn)

	local redispool = cluster.proxy("cluster_database", ".redispool")

	local cmd = assert(args[1])
	args[1] = dbn
	return skynet.call(redispool, "lua", cmd, table.unpack(args))
end

function mysql_query(sql, dbn)
	local mysqlpool = cluster.proxy("cluster_database", ".mysqlpool")
	return skynet.call(mysqlpool, "lua", "execute", sql, dbn)
end