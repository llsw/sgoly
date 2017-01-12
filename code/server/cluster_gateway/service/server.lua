local skynet    = require "skynet"
local socket    = require "socket"
local crypt 	= require "crypt"
local sgoly_users=require "sgoly_users"
local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "skynet.manager"
local md5 = require "md5"
local add=require "sgoly_service_config"
local record=require "sgoly_record"
local sgoly_tool=require"sgoly_tool"


function handler(fd, addr)
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
			skynet.error(mes.ID,mes.NAME,mes.PASSWD)

----------------------------用户注册-----------------------------------			
			if mes.ID=="2" then 
			   skynet.error("2",mes.PASSWD)            
			   mes.PASSWD=md5.sumhexa(mes.PASSWD)
			   local bool,msg=sgoly_users.register(mes.NAME,mes.PASSWD)
			   skynet.error(bool,msg)
			   if bool then            
				  local bo,message=record.record_init(mes.NAME,500000)
				  skynet.error("asdasd=",bo,message)--test
			   end
			   local rep={ID=bool,MESSAGE=msg}
			   local str=cjson.encode(rep)
			   local rep1=crypt.aesencode(str,who,"")
			   local str2 = crypt.base64encode(rep1)
			   socket.write(fd,str2.."\n")

------------------------- --用户登录-------------------------------------
		    elseif mes.ID=="1" then               
				--mes.passwd = crypt.base64encode(mes.passwd)
				mes.PASSWD=md5.sumhexa(mes.PASSWD)
		    	local bool,msg=sgoly_users.login(mes.NAME, mes.PASSWD)
		    	skynet.error(bool,msg)
		    	-------	登录成功返回拥有金钱-----------	
		    	if bool then
		        -- local bool,msg=sgoly_users.login(mes.NAME, mes.PASSWD)
		      --   skynet.error(bool,msg)
		            local boo,money =sgoly_tool.getMoney(mes.NAME)
		            skynet.error("money is",money)
		            if boo then
				 	    local reqmoney={ID=boo,MONEY=money}
					    local str3=cjson.encode(reqmoney)
					    local rep3=crypt.aesencode(str3,who,"")
					    local str3_1 = crypt.base64encode(rep3)
					    socket.write(fd,str3_1.."\n")
					elseif not boo then
						local reqmoney={ID=boo,MESSAGE=money}
					    local str3=cjson.encode(reqmoney)
					    local rep3=crypt.aesencode(str3,who,"")
					    local str3_1 = crypt.base64encode(rep3)
					    socket.write(fd,str3_1.."\n")
					end
			    elseif	not bool then
			        local rep4={ID=bool,MESSAGE=msg}
				    local str4=cjson.encode(rep4)
				    local rep4_1=crypt.aesencode(str4,who,"")
				    local str4_1 = crypt.base64encode(rep4_1)
				    socket.write(fd,str4_1.."\n")	
				end 	


---------------------------游客登录--------------------------------------			        	
		    elseif mes.ID=="3" then               
		    	id=tourist()
		    	id=tostring(id)
		    	local name,password=randomuserid(id)
				local trpd=md5.sumhexa(password)
		    	local bool,msg=sgoly_users.register(name,trpd)
			    while  msg=="昵称已被使用" do
			       local name,trpd=randomuserid()
		    	   bool,msg=sgoly_users.register(name,trpd)
			       skynet.error(bool,msg)
			    end
			    if msg=="注册成功" then 
			       skynet.error("注册成功")
			       skynet.error(name,trpd)           
				   local bo,message=record.record_init(name,500000)
				   skynet.error("record_init=",bo,message)--test
			       if bo then 
				       local rep={ID=true,NAME=name,PASSWD=password}
				       local str=cjson.encode(rep)
				       local rep1=crypt.aesencode(str,who,"")
				       local str2 = crypt.base64encode(rep1)
				       socket.write(fd,str2.."\n")
			       elseif not bo then
				       	local rep5={ID=bo,MESSAGE=message}
					    local str5=cjson.encode(rep5)
					    local rep5_1=crypt.aesencode(str5,who,"")
					    local str5_1 = crypt.base64encode(rep5_1)
					    socket.write(fd,str5_1.."\n")
					end
			    elseif msg=="未知错误" then
			       local rep={ID=false,MESSAGE=msg}
			       local str=cjson.encode(rep)
			       local rep1=crypt.aesencode(str,who,"")
			       local str2 = crypt.base64encode(rep1)
			       socket.write(fd,str2.."\n")
				end	
--------------------------主游戏逻辑-----------------------------				
			elseif mes.ID=="4" then	
				skynet.error("this is 4")
				local proxy = cluster.proxy("cluster_game",".maingame")
				local a=skynet.call(proxy,"lua","calc",10,10,5)
		    end
		else
			socket.close(fd)
            skynet.error("client"..fd, " ["..addr.."]", "disconnected")
			return
		end
	end
end

function tourist()          --游客登录协程互斥防止获取相同ID
	local  ty,id
	repeat 
		ty,id=coroutine.resume(co)
		sgoly_tool.saveUuid(id)
	until(ty)
	return id 
end
function randomuserid(id)     --游客登录随机ID     
	local a=string.char(math.random(65,122))
	local b=string.char(math.random(65,122))
	local c=string.char(math.random(65,122))
	local name="tr"..a..b..c..id
	local password ="laohuji"
	return name,password
end

skynet.start(function()
	    i=sgoly_tool.getUuid()
	    skynet.error("i=",i)
	 	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
		co = coroutine.create(function ()
			print("co","asdfgg")
		    		 while true do 
		    		 	i=i+1
		    		 	coroutine.yield(i)
		    		 end
		    		end)

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