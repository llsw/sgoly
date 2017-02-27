
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
local socket = require "socket"
local service_config = require "sgoly_service_config"



skynet.start(function ()
	cluster.open("cluster_test")
	skynet.register("test_main")
	
	skynet.error("Cluster_test start")
	printI("Cluster_test start")

	local log = skynet.uniqueservice("sgoly_log")
	skynet.call(log, "lua", "start")

	

	skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end


	--local debug_port = skynet.getenv "debug_port"
	local debug_port = service_config["debug_port"]["test"]
	if debug_port then
		skynet.newservice("debug_console",debug_port)
	end


	--local  watchdog= skynet.uniqueservice("watchdog")
	--skynet.call(watchdog, "lua", "start")
	-- local  server= skynet.uniqueservice("server")
	-- local  hub= skynet.uniqueservice("hub")
	-- skynet.call(hub, "lua", "open","0.0.0.0",7000)
	
	-- local test = skynet.uniqueservice("gate_example")
	-- skynet.name(".gate_example", test)
	-- skynet.call(test,"lua","open", {
	-- 	port = 8889,
	-- 	maxclient =1024,
	-- 	nodelay = true,
	-- })
	-- 
	local test= skynet.uniqueservice("test")
	local msg = skynet.call(test, "lua", "test1")
	print("end send 1")

	skynet.call(test, "lua", "test2")
	print("end send 2")
	
	skynet.exit()
	
end)