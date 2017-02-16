
--[[
 * @brief:		inform.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-02-10
--]]

local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
local sgoly_tool=require "sgoly_tool"
local sgoly_pack=require "sgoly_pack"
local crypt     = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"

local CMD ={}

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".warning")
	xpcall(skynet.call, xpcall_error, ".gateway", "lua", "informClient", "服务器将于五分钟后关闭")
	skynet.exit()
end)