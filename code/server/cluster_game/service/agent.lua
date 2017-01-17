local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
local agent = {}




function agent.main(fd,mes)
			skynet.error(mes)
			skynet.error(mes.SESSION,mes.ID,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY)
		    skynet.call(".maingame","lua","calc",fd,10,10,10)
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)