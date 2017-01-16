local skynet = require "skynet"
local socket = require "socket"
local crypt 	= require "crypt"
local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "skynet.manager"
local agent = {}




function agent.main(fd,addr)
	socket.start(fd)
	while true do
		local str = socket.readline(fd)
		if str then
			skynet.error("client"..fd, " says: ", str)
			local str1 = crypt.base64decode(str)
			local password
			local who="123456"
			password=crypt.aesdecode(str1,who,"")
			local mes = cjson.decode(password)
			skynet.error(mes)
			skynet.error(mes.ID,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY)
			if mes.ID=="4" then
				skynet.error("this is 4")
				local proxy = cluster.proxy("cluster_game",".maingame")
				skynet.call(proxy,"lua","calc",fd,10,10,5)
		    end	
		else
			socket.close(fd)
            skynet.error("client"..fd, " ["..addr.."]", "disconnected")
			return
		end
	end
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)