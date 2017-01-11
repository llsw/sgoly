local skynet    = require "skynet"
local socket    = require "socket"
local crypt 	= require "crypt"
local sgoly_users=require "sgoly_users"
--local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
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
			local str1 = crypt.base64decode(str)
			local password
			local who="123456"
			password=crypt.aesdecode(str1,who,"")
			local mes = cjson.decode(password)
			skynet.error(mes)
			skynet.error(mes.userid,mes.password)
			-- socket.write(fd,mes.ID.." "..mes.CDate.."\n")
			local bool,msg=sgoly_users.register(mes.userid, mes.password)
		--	skynet.error("json is",mes)
			--str = "server receive a msg: " .. str
			--[[if str=="1" then
				local stc ="输入用户名"
				socket.write(fd,stc.."\n")]]
			--local proxy = cluster.proxy("cluster_game",".maingame")
			--skynet.call(proxy,"lua","calc",10,10,5)
			-- local rep = cjson.encode(mes)
			-- local repaes = crypt.aesencode(rep,who,"")
			-- local challenge = crypt.base64encode(repaes)
			local a=tostring(bool)
			socket.write(fd,a..msg.."\n")


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
        --  local hub= skynet.uniqueservice("hub")
        -- skynet.call(hub, "lua", "open", fd,"192.168.100.77", 7000)
    end)
    -- local hub= skynet.uniqueservice("hub")
    --     skynet.call(hub, "lua", "open", fd,"192.168.100.77", 7000)
    -- 要注册个服务的名字，以.开头
    skynet.register(".server")
end)