local skynet    = require "skynet"

local crypt 	= require "crypt"
local sgoly_users=require "sgoly_users"
local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "skynet.manager"
local md5 = require "md5"
local record=require "sgoly_record"
local sgoly_tool=require"sgoly_tool"
local CMD={}
local loginuser = {}
function handler(fd, mes)
			local who="123456"
----------------------------用户注册-----------------------------------			
		    if mes.ID=="2" then 
			   skynet.error("2",mes.PASSWD)            
			   mes.PASSWD=md5.sumhexa(mes.PASSWD)
			   local bool,msg=sgoly_users.register(mes.NAME,mes.PASSWD)
			   skynet.error(bool,msg)
			   if bool then            
				  local bo,message=record.record_init(mes.NAME,500000)
				  skynet.error("asdasd=",bo,message)--test
				  if bo then
				  		local resuss={SESSION=mes.SESSION,ID="2",STATE=bo}
				  		local resuss1=cjson.encode(resuss)
			   			local resuss1_1=crypt.aesencode(resuss1,who,"")
			  			local resuss1_2 = crypt.base64encode(resuss1_1)
			  	  		return resuss1_2.."\n"
			  	  elseif not bo then
			  	  	    local reinit={SESSION=mes.SESSION,ID="2",STATE=bo,MESSAGE=message}
				  		local reinit1=cjson.encode(reinit)
			   			local reinit1_1=crypt.aesencode(reinit1,who,"")
			  			local reinit1_2 = crypt.base64encode(reinit1_1)
			  	  		return reinit1_2.."\n"
			      end
			   elseif not bool then 
			   		local refal={SESSION=mes.SESSION,ID="2",STATE=bool,MESSAGE=msg}
			   		local refal1=cjson.encode(refal)
			   		local refal1_1=crypt.aesencode(refal1,who,"")
			   		local refal1_2 = crypt.base64encode(refal1_1)
			   		print("zxcgfdsgrfy")
			  		return refal1_2.."\n"
			   end
------------------------- --用户登录-------------------------------------
		    elseif mes.ID=="1" then               
				mes.PASSWD=md5.sumhexa(mes.PASSWD)
		    	local bool,msg=sgoly_users.login(mes.NAME, mes.PASSWD)
		    	skynet.error(bool,msg)
		    	-------	登录成功返回拥有金钱-----------	
		    	if bool then
		            local boo,money =sgoly_tool.getMoney(mes.NAME)
		            skynet.error("money is",money)
		            if boo then
				 	    local reqmoney={SESSION=mes.SESSION,ID="1",STATE=boo,MONEY=money}
					    local str5=cjson.encode(reqmoney)
					    local rep5=crypt.aesencode(str5,who,"")
					    local str5_1 = crypt.base64encode(rep5)
					    return str5_1.."\n"
					    -- return(fd,str3_1.."\n")
				     --    loginuser[fd]=true
					elseif not boo then
						local reqmoney={SESSION=mes.SESSION,ID="1",STATE=boo,MESSAGE=money}
					    local str3=cjson.encode(reqmoney)
					    local rep3=crypt.aesencode(str3,who,"")
					    local str3_1 = crypt.base64encode(rep3)
					    return str3_1.."\n"
					end
			    elseif	not bool then
			        local rep4={SESSION=mes.SESSION,ID="1",STATE=bool,MESSAGE=msg}
				    local str4=cjson.encode(rep4)
				    local rep4_1=crypt.aesencode(str4,who,"")
				    local str4_1 = crypt.base64encode(rep4_1)
				    return str4_1.."\n"	
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
				       local rep={SESSION=mes.SESSION,ID="3",STATE=bo,NAME=name,PASSWD=password}
				       local str=cjson.encode(rep)
				       local rep1=crypt.aesencode(str,who,"")
				       local str2 = crypt.base64encode(rep1)
				       return str2.."\n"
			        elseif not bo then
				       	local rep5={SESSION=mes.SESSION,ID="3",STATE=bo,MESSAGE=message}
					    local str5=cjson.encode(rep5)
					    local rep5_1=crypt.aesencode(str5,who,"")
					    local str5_1 = crypt.base64encode(rep5_1)
					    return str5_1.."\n"
					end
			    elseif msg=="未知错误" then
			       local rep={SESSION=mes.SESSION,ID="3",STATE=false,MESSAGE=msg}
			       local str=cjson.encode(rep)
			       local rep1=crypt.aesencode(str,who,"")
			       local str2 = crypt.base64encode(rep1)
			       return str2.."\n"
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


function CMD.signin(fd,mes)
	return handler(fd,mes)
end


skynet.start(function()
	    i=sgoly_tool.getUuid()
	    skynet.error("i=",i)
	 	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
		co = coroutine.create(function ()
		    		 while true do 
		    		 	i=i+1
		    		 	coroutine.yield(i)
		    		 end
		    		end)
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".login")
end)
