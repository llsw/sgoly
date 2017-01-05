
--[[
 * @brief: mysqlpool.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
require "skynet.manager"
local mysql = require "mysql"
local crypt = require "crypt"
local dbPool = require "sgoly_mysql_connection"
local service_config = require "sgoly_service_config"
require "sgoly_printf"
local CMD = {}
local dbc


function CMD.start()

	local dbconf = service_config["database_mysql_config"]
	local rwho = "interface"
	local rpassword = dbconf.password
	
	rpassword = crypt.base64decode(rpassword)
	rpassword = crypt.aesdecode(rpassword,rwho,"")
	dbconf.password = rpassword

	dbc = dbPool.new()
	dbc:init(dbconf)
end

function CMD.execute(sql, dbn)
	local db = dbc:get()
	if not db then
		printE("execute sql[%s] fail!Not get DB ", sql)
		return "error"
	else
		printI("execute sql[%s]", sql)
		dbc:free(db)
		return db:query(sql)
		
	end
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".mysqlpool")
end)