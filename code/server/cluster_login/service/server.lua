local skynet    = require "skynet"
local socket    = require "socket"
--local json 		= require "json" 
require "skynet.manager"
local add=require "sgoly_service_config"

function handler(fd, addr)
	socket.start(fd)
	while true do
	   -- local rep = "userid"
	   -- socket.write
		local str = socket.readline(fd)
		if str then
			skynet.error("client"..fd, " says: ", str)
			--str = "server receive a msg: " .. str
			if str=="1" then
				local stc ="输入用户名"
				socket.write(fd,stc.."\n")
			end
			socket.write(fd, str.."\n")
		else
			socket.close(fd)
            skynet.error("client"..fd, " ["..addr.."]", "disconnected")
			return
		end
	end
end

skynet.start(function()
    local fd = assert(socket.listen(add.gateway_server.host))
    socket.start(fd, function(fd, addr)
        skynet.error("client"..fd, " ["..addr.."]", "connected")
        skynet.fork(handler, fd, addr)
    end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".server")
end)
