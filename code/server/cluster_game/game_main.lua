
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
	cluster.open("cluster_game")
	skynet.register("game_main")
	
	skynet.error("Cluster_game start")
	printI("Cluster_game start")

	local log = skynet.uniqueservice("sgoly_log")
	skynet.call(log, "lua", "start")

	

	skynet.uniqueservice("protoloader")
	if service_config["console"]["game"] == 1 then
		local console = skynet.newservice("console")
	end


	--local debug_port = skynet.getenv "debug_port"
	local debug_port = service_config["debug_port"]["game"]
	if debug_port then
		skynet.newservice("debug_console",debug_port)
	end
    local  agent= skynet.newservice("agent")
	-- local  maingame= skynet.newservice("maingame")
	-- local  stats= skynet.newservice("stats")
end)