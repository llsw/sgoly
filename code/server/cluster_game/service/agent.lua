local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
local agent = {}

local connection = {}


function agent.main(fd,mes)
	skynet.error(mes)
	skynet.error(mes.SESSION,mes.ID,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST)
	local req=skynet.call(connection[fd].maingame,"lua","calc",fd,mes.SESSION,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST,connection[fd].name)
	return req
end

function agent.start(fd,name)
	  local maingame = skynet.newservice("maingame")
	  c = {
	  	name = name,
	  	maingame = maingame
		}
	  connection[fd] = c 
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)