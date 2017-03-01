
--[[
 * @brief:		http_main.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-03-01
--]]

local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
require "skynet.manager"
require "sgoly_printf"
require "sgoly_query"
local service_config = require "sgoly_service_config"

skynet.start(function ()
	cluster.open("cluster_http")
	skynet.register("http_main")
	
	skynet.error("Cluster_http start")
	printI("Cluster_http start")

	local log = skynet.uniqueservice("sgoly_log")
	skynet.call(log, "lua", "start")

	

	skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end


	--local debug_port = skynet.getenv "debug_port"
	local debug_port = service_config["debug_port"]["http"]
	if debug_port then
		skynet.newservice("debug_console",debug_port)
	end



	local httpserver = skynet.newservice("httpserver")

end)