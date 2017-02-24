local skynet    = require "skynet"
local crypt 	= require "crypt"
local coroutine = require "skynet.coroutine"
local dat_ser   = require "sgoly_dat_ser"
local sgoly_pack = require "sgoly_pack"
local cluster   = require "cluster"
require "skynet.manager"
require "sgoly_printf"
local md5 = require "md5"
local sgoly_tool=require"sgoly_tool"
local CMD={}
local loginuser = {}
function handler(fd, mes)
	-- printI("login NAME=%s,SESSION=%s,CMD=%s,ID=%s",mes.NAME,mes.SESSION,mes.CMD,mes.ID)
-------------------------用户注册-----------------------------------			
	if  mes.ID=="2" then  
		local bo1=sgoly_pack.filter_account(mes)
		if bo1==false then
			return sgoly_pack.returnfalse(mes,"2","帐号含有非法字符")
        end
        local bo2 = sgoly_pack.filter_password(mes)
        if bo2==false then
        	return sgoly_pack.returnfalse(mes,"2","密码含有非法字符")
        end
	    mes.PASSWD=md5.sumhexa(mes.PASSWD)
		local bool,msg=dat_ser.register(mes.NAME,mes.PASSWD)
		printI("%s,%s",bool,msg)
		if bool then            
			local resuss={SESSION=mes.SESSION,ID="2",STATE=bool}
			local resuss1_2=sgoly_pack.encode(resuss)
		  	return resuss1_2.."\n"
		elseif not bool then 
			return sgoly_pack.returnfalse(mes,"2",msg)
		end
-------------------------用户登录-------------------------------------
    elseif mes.ID=="1" then   
		local bo1=sgoly_pack.filter_account(mes)
		if bo1==false then
			return sgoly_pack.returnfalse(mes,"1","帐号含有非法字符")
        end
        local bo2 = sgoly_pack.filter_password(mes)
        if bo2==false then
        	return sgoly_pack.returnfalse(mes,"1","密码含有非法字符")
        end          
		    mes.PASSWD=md5.sumhexa(mes.PASSWD)
		    local bool,msg=dat_ser.login(mes.NAME, mes.PASSWD)
		    printI("%s,%s",bool,msg)
		if bool then     --登录成功返回拥有金钱
				local boolfd,reqfd=sgoly_tool.getUserFdFromRedis(tonumber(msg))
                if reqfd then
                   local req3={ID="15",STATE=true,MESSAGE="该账号已在其他地方上线，您已被强迫下线"}
				   local result2_2 = sgoly_pack.encode(req3)
                   local call_ok, call_result = xpcall(cluster.call,xpcall_error,"cluster_gateway",".gateway","seclose",reqfd,result2_2,false)
               	   skynet.sleep(100)
               	   local call_ok, req=xpcall(cluster.call, xpcall_error, "cluster_game",".agent","close",reqfd)
            	end
                sgoly_tool.setUserFdToRedis(tonumber(msg), fd)
		        local boo,money =sgoly_tool.getMoney(tonumber(msg))
		        printI("money is %s",money)
		        xpcall(cluster.call, xpcall_error, "cluster_gateway",".gateway","saveAddrToRedis",fd,tonumber(msg))
		    if boo then
				local reqmoney={SESSION=mes.SESSION,ID="1",STATE=boo,MONEY=money,NAME=msg}
			    local str5_1=sgoly_pack.encode(reqmoney)
			    local call_ok, call_result = xpcall(cluster.call, xpcall_error, "cluster_gateway",".gateway","heart",fd,mes.NAME,mes.SESSION)
			    local call_ok, call_result = xpcall(cluster.call, xpcall_error, "cluster_game",".agent","start",fd,msg)
			    dat_ser.setUserLoginTime(tonumber(msg))
			    return str5_1.."\n"
		    else
		    	return sgoly_pack.returnfalse(mes,"1",money)
			end
		else
			    return sgoly_pack.returnfalse(mes,"1",msg)
		end 	
-------------------------游客登录--------------------------------------			        	
    elseif mes.ID=="3" then               
		   id=tourist()
		   id=tostring(id)
		   local name,password=randomuserid(id)
		   local trpd=md5.sumhexa(password)
		   local bool,msg=dat_ser.register(name,trpd)
		   while  msg=="昵称已被使用" do
			    local name,trpd=randomuserid()
		    	bool,msg=dat_ser.register(name,trpd)
			    printI("%s,%s",bool,msg)
			end
	    if msg=="注册成功" then 
			    printI("注册成功")
			    printI("%s,%s",name,trpd)           
				local rep={SESSION=mes.SESSION,ID="3",STATE=true,NAME=name,PASSWD=password}
				local str2=sgoly_pack.encode(rep)
				return str2.."\n"
	    else
	    	   return sgoly_pack.returnfalse(mes,"3",msg)
	    end 
-------------------------修改密码----------------------------------	    
    elseif  mes.ID=="11" then  
    	  	local x={}
    	 	x.PASSWD=mes.PASSWARD
	      	local bo2 = sgoly_pack.filter_password(x)
	        if bo2==false then
	        	return sgoly_pack.returnfalse(mes,"11","密码含有非法字符")
	        end          
		    local PASSWD=md5.sumhexa(mes.PASSWARD)
		    local CURPASSWARD=md5.sumhexa(mes.CURPASSWARD)
			local bool,msg=dat_ser.cha_pwd(mes.NAME,CURPASSWARD,PASSWD)
			printI("%s,%s",bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="11",STATE=true}
					local resuss1_2=sgoly_pack.encode(resuss)
				  	return resuss1_2.."\n"
			else 
				return sgoly_pack.returnfalse(mes,"11",msg)
			end
-------------------------修改头像----------------------------------
	elseif  mes.ID=="12" then 
	    if  mes.TYPE=="query"  then         
			local bool,msg=dat_ser.get_img_name(mes.NAME)
			printI("%s,%s",bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="12",STATE=true,TYPE="query",PORTRAIT=msg}
					local resuss1_2=sgoly_pack.encode(resuss)
				  	return resuss1_2.."\n"
			else 
				return sgoly_pack.typereturn(mes,"12",msg)
			end
		elseif mes.TYPE=="reset" then
			local bool,msg=dat_ser.cha_img_name(mes.NAME,mes.PORTRAIT)
			printI("%s,%s",bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="12",STATE=true,TYPE="reset",PORTRAIT=tonumber(mes.PORTRAIT)}
					local resuss1_2=sgoly_pack.encode(resuss)
				  	return resuss1_2.."\n"
			else 
				return sgoly_pack.typereturn(mes,"12",msg)
			end
		else
			local str6_1=sgoly_pack.typereturn(mes,mes.ID,"未知错误")
		    return str6_1.."\n"
		end
	elseif  mes.ID=="13" then 
		    --cluster.call("cluster_game",".agent","setline",fd)
		    return nil
    else
    	local str6_1=sgoly_pack.returnfalse(mes,mes.ID,"未知错误")
      	return str6_1.."\n"
    end
end

function tourist()           --游客登录协程互斥防止获取相同ID
	local  ty,id
	repeat 
		ty,id=coroutine.resume(co)
		sgoly_tool.saveUuid(id)
	until(ty)
	return id 
end
function randomuserid(id)     --游客登录随机ID     
	local a,b,c
	local a1=math.random(1,100)
	local b1=math.random(1,100)
	local c1=math.random(1,100)
		if a1<50 then
		    a=string.char(math.random(65,90))
		else
			a=string.char(math.random(97,122))
		end
		if b1<50 then
		    b=string.char(math.random(65,90))
		else
			b=string.char(math.random(97,122))
		end
		if c1<50 then
		    c=string.char(math.random(65,90))
		else
			c=string.char(math.random(97,122))
		end
	local name="tr"..a..b..c..id
	local password ="laohuji"
	return name,password
end


function CMD.signin(fd,mes)
	return handler(fd,mes)
end





skynet.start(function()
	i=sgoly_tool.getUuid()
	printI("i=%s",i)
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
