
--[[
 * @brief: database_main.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
require "skynet.manager"
require "sgoly_printf"
require "sgoly_query"
local service_config = require "sgoly_service_config"

skynet.start(function ()
	cluster.open("cluster_login")
	skynet.register("login_main")
	
	skynet.error("Cluster_login start")
	printI("Cluster_login start")

	local log = skynet.uniqueservice("sgoly_log")
	skynet.call(log, "lua", "start")

	

	skynet.uniqueservice("protoloader")
	if service_config["console"]["login"] == 1 then
		local console = skynet.newservice("console")
	end

    local login=skynet.uniqueservice("login")
	--local debug_port = skynet.getenv "debug_port"
	local debug_port = service_config["debug_port"]["login"]
	if debug_port then
		skynet.newservice("debug_console",debug_port)
	end



	
end)
