local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
require "sgoly_printf"
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

	skynet.register(".inform")
	local call_ok, call_result = xpcall(skynet.call,xpcall_error,".agent","lua","sclose",false,"服务器将于五分钟后关闭")
	skynet.exit()
end)