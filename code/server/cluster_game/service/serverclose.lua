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

	skynet.register(".serverclose")
	local call_ok, call_result = xpcall(skynet.call,xpcall_error,".agent","lua","sclose",true,"暂无")
end)