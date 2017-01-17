
--[[
 * @brief: gateway.lua

 * @author:	  kun si
 * @date:	2016-12-22
--]]

local skynet = require "skynet"
local socketdriver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local crypt = require"crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "sgoly_printf"


local handler = {}

function handler.open(source, conf)
	printI("Gateway open source[%d]", source)
end

function handler.message(fd, msg)
	
	

		if msg then
			skynet.error("client"..fd, " says: ", msg)
			local str1 = crypt.base64decode(msg)
			local password
			local who="123456"
			password=crypt.aesdecode(str1,who,"")
			local mes = cjson.decode(password)
			skynet.error(mes)
			skynet.error(mes.ID,mes.NAME,mes.PASSWD)
		end
		
end

function handler.connect(fd, addr)
	gateserver.openclient(fd)

	printI("Client fd[%d] connect gateway", fd)
end

function handler.disconnect(fd)
	--gateserver.closeclient(fd)
	printI("Client fd[%d] disconnect gateway", fd)
end

function handler.error(fd, msg)
	printE("Gateway error fd[%d] msg[%s]", fd, msg)
end

function handler.warning(fd, size)
	printE("Gateway warning fd[%d] size[%s]", fd, size)	
end

local CMD = {}

	

function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(...)
end

gateserver.start(handler)
