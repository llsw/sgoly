
--[[
 * @brief: database_main.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
local service_config =require "sgoly_service_config"
require "skynet.manager"
require "sgoly_printf"
require "sgoly_query"

skynet.start(function ()
	cluster.open("cluster_gateway")
	skynet.register("gateway_main")
	
	skynet.error("Cluster_gateway start")
	printI("Cluster_gateway start")

	local log = skynet.uniqueservice("sgoly_log")
	skynet.call(log, "lua", "start")

	

	skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end


	--local debug_port = skynet.getenv "debug_port"
	--skynet.newservice("debug_console",debug_port)


	--local  watchdog= skynet.uniqueservice("watchdog")
	--skynet.call(watchdog, "lua", "start")
	-- local  server= skynet.uniqueservice("server")
	-- local  hub= skynet.uniqueservice("hub")
	-- skynet.call(hub, "lua", "open","0.0.0.0",7000)
	--skynet.exit()
	local gateway = skynet.uniqueservice("gateway")
	skynet.name(".gateway", gateway)
	xpcall(skynet.call, xpcall_error, gateway,"lua","open", {
		port = tonumber(string.sub(service_config["gateway_server"]["host"],9,12)),
		maxclient =1024,
		nodelay = true,
	})
	
end)