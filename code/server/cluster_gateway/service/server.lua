local skynet    = require "skynet"
local socket    = require "socket"
local crypt 	= require "crypt"
local sgoly_users=require "sgoly_users"
--local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "skynet.manager"
local add=require "sgoly_service_config"
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
i=111
co = coroutine.create(function ()
		    		 while true do 
		    		 	i=i+1
		    		 	coroutine.yield(i)
		    		 end
		    		end)
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
			skynet.error(mes.ID,mes.NAME,mes.PASSWD)
			if mes.ID=="2" then 
				--mes.passwd=crypt.aesencode(mes.passwd,who,"")
				--mes.passwd = crypt.base64encode(mes.passwd)
			   local bool,msg=sgoly_users.register(mes.NAME, mes.PASSWD)
			   skynet.error(bool,msg)
			--local proxy = cluster.proxy("cluster_game",".maingame")
			--skynet.call(proxy,"lua","calc",10,10,5)
			   local rep={ID=bool,MESSAGE=msg}
			   local str=cjson.encode(rep)
			   local rep1=crypt.aesencode(str,who,"")
			   local str2 = crypt.base64encode(rep1)
			   socket.write(fd,str2.."\n")
		    elseif mes.ID=="1" then
		    	local bool,msg=sgoly_users.login(mes.NAME, mes.PASSWD)
		    	skynet.error(bool,msg)
		        local rep={ID=bool,MESSAGE=msg}
			    local str=cjson.encode(rep)
			    local rep1=crypt.aesencode(str,who,"")
			    local str2 = crypt.base64encode(rep1)
			    socket.write(fd,str2.."\n")		    	--local bool,msg=sgoly_users.register(mes.NAME, mes.passwd)
		    elseif mes.ID=="3" then
		    	id=tourist()
		    	id=tostring(id)
		    	local name,password=randomuserid()
		    	local bool,msg=sgoly_users.register(name,password)
			    while  msg=="昵称已被使用" do
			      local name,password=randomuserid()
		    	   bool,msg=sgoly_users.register(name,password)
			       skynet.error(bool,msg)
			    end
			    if msg=="注册成功" then 
			    	skynet.error("注册成功")
			--local proxy = cluster.proxy("cluster_game",".maingame")
			--skynet.call(proxy,"lua","calc",10,10,5)
			       local rep={ID=true,NAME=name,PASSWD=password}
			       local str=cjson.encode(rep)
			       local rep1=crypt.aesencode(str,who,"")
			       local str2 = crypt.base64encode(rep1)
			       socket.write(fd,str2.."\n")
			    elseif msg=="未知错误" then
			       local rep={ID=false,MESSAGE=msg}
			       local str=cjson.encode(rep)
			       local rep1=crypt.aesencode(str,who,"")
			       local str2 = crypt.base64encode(rep1)
			       socket.write(fd,str2.."\n")
				end
		    	-- local bool,msg=sgoly_users.login(mes.NAME, mes.PASSWD)
		    	-- skynet.error(bool,msg)
		     --    local rep={ID=bool,MESSAGE=msg}
			    -- local str=cjson.encode(rep)
			    -- local rep1=crypt.aesencode(str,who,"")
			    -- local str2 = crypt.base64encode(rep1)	
		    end

		else
			socket.close(fd)
            skynet.error("client"..fd, " ["..addr.."]", "disconnected")
			return
		end
	end
end

function tourist()
	local  ty,id
	repeat 
		ty,id=coroutine.resume(co)
	until(ty)
	return id 
end
function randomuserid()
	local a=string.char(math.random(65,122))
	local b=string.char(math.random(65,122))
	local c=string.char(math.random(65,122))
	local name="tr"..a..b..c..id
	local password ="laohuji"
	return name,password
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