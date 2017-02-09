local skynet    = require "skynet"
local crypt 	= require "crypt"
local coroutine = require "skynet.coroutine"
local dat_ser=require "sgoly_dat_ser"
local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
require "skynet.manager"
require "sgoly_printf"
local md5 = require "md5"
local sgoly_tool=require"sgoly_tool"
local CMD={}
local loginuser = {}
local sessionID={} 
function handler(fd, mes)
	local who="123456"
	-- printI("login NAME=%s,SESSION=%s,CMD=%s,ID=%s",mes.NAME,mes.SESSION,mes.CMD,mes.ID)
-------------------------用户注册-----------------------------------			
	if  mes.ID=="2" then            
	    mes.PASSWD=md5.sumhexa(mes.PASSWD)
		local bool,msg=dat_ser.register(mes.NAME,mes.PASSWD)
		skynet.error(bool,msg)
		if bool then            
		    local bo,message=dat_ser.usr_init(mes.NAME,500000,"0",nil)
			skynet.error("usr_init",bo,message)--test
			if bo then
				local resuss={SESSION=mes.SESSION,ID="2",STATE=bo}
				local resuss1_2=packtable(resuss)
			  	return resuss1_2.."\n"
			elseif not bo then
			  	local reinit={SESSION=mes.SESSION,ID="2",STATE=bo,MESSAGE=message}
				local reinit1_2=packtable(reinit)
			  	return reinit1_2.."\n"
			end
		elseif not bool then 
			local refal={SESSION=mes.SESSION,ID="2",STATE=bool,MESSAGE=msg}
			local refal1_2=packtable(refal)
			return refal1_2.."\n"
		end
-------------------------用户登录-------------------------------------
    elseif mes.ID=="1" then   
    --     if sessionID[mes.NAME] then
				-- local reqmoney={SESSION=mes.SESSION,ID="1",STATE=false,MESSAGE="该用户已登录"}
			 --    local str3_1=packtable(reqmoney)
				-- return str3_1.."\n"
    --     end
            sessionID[mes.NAME]=mes.SESSION
            for k,v in pairs(sessionID) do
                   printI("sessionID,k=%s,v=%s",k,v)
            end            
		    mes.PASSWD=md5.sumhexa(mes.PASSWD)
		    local bool,msg=dat_ser.login(mes.NAME, mes.PASSWD)
		    skynet.error(bool,msg)
		if bool then     --登录成功返回拥有金钱
		        local boo,money =sgoly_tool.getMoney(mes.NAME)
		        printI("money is %s",money)
		    if boo then
				local reqmoney={SESSION=mes.SESSION,ID="1",STATE=boo,MONEY=money}
			    local str5_1=packtable(reqmoney)
			    cluster.call("cluster_gateway",".gateway","heart",fd)
			    cluster.call("cluster_game",".agent","start",fd,mes.NAME)
			    return str5_1.."\n"
		    elseif not boo then
				local reqmoney={SESSION=mes.SESSION,ID="1",STATE=boo,MESSAGE=money}
			    local str3_1=packtable(reqmoney)
				return str3_1.."\n"
			end
		elseif	not bool then
			    local rep4={SESSION=mes.SESSION,ID="1",STATE=bool,MESSAGE=msg}
				local str4_1=packtable(rep4)
				return str4_1.."\n"	
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
			    skynet.error(bool,msg)
			end
	    if msg=="插入用户数据成功" then 
			    printI("插入用户数据成功")
			    printI("%s,%s",name,trpd)           
				local bo,message=dat_ser.usr_init(name,500000,"0",nil)
				skynet.error("record_init=",bo,message)--test
			if bo then 
				local rep={SESSION=mes.SESSION,ID="3",STATE=bo,NAME=name,PASSWD=password}
				local str2=packtable(rep)
				return str2.."\n"
			elseif not bo then
				local rep5={SESSION=mes.SESSION,ID="3",STATE=bo,MESSAGE=message}
			    local str5_1=packtable(rep5)
			    return str5_1.."\n"
		    end
	    else
			       local rep={SESSION=mes.SESSION,ID="3",STATE=false,MESSAGE=msg}
			       local str2=packtable(rep)
			       return str2.."\n"
	    end 
-------------------------修改密码----------------------------------	    
    elseif  mes.ID=="11" then            
		    local PASSWD=md5.sumhexa(mes.PASSWARD)
		    local CURPASSWARD=md5.sumhexa(mes.CURPASSWARD)
			local bool,msg=dat_ser.cha_pwd(mes.NAME,CURPASSWARD,PASSWD)
			skynet.error(bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="11",STATE=true}
					local resuss1_2=packtable(resuss)
				  	return resuss1_2.."\n"
			else 
				local refal={SESSION=mes.SESSION,ID="11",STATE=bool,MESSAGE=msg}
				local refal1_2=packtable(refal)
				return refal1_2.."\n"
			end
-------------------------修改头像----------------------------------
	elseif  mes.ID=="12" then 
	    if  mes.TYPE=="query"  then         
			local bool,msg=dat_ser.get_img_name(mes.NAME)
			skynet.error(bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="12",STATE=true,TYPE="query",PORTRAIT=msg}
					local resuss1_2=packtable(resuss)
				  	return resuss1_2.."\n"
			else 
				local refal={SESSION=mes.SESSION,ID="12",STATE=false,TYPE="query",MESSAGE=msg}
				local refal1_2=packtable(refal)
				return refal1_2.."\n"
			end
		elseif mes.TYPE=="reset" then
			local bool,msg=dat_ser.cha_img_name(mes.NAME,mes.PORTRAIT)
			skynet.error(bool,msg)
			if bool then            
					local resuss={SESSION=mes.SESSION,ID="12",STATE=true,TYPE="reset",PORTRAIT=tonumber(mes.PORTRAIT)}
					local resuss1_2=packtable(resuss)
				  	return resuss1_2.."\n"
			else 
				local refal={SESSION=mes.SESSION,ID="12",STATE=false,TYPE="reset",MESSAGE=msg}
				local refal1_2=packtable(refal)
				return refal1_2.."\n"
			end
		else
		    local rep6={SESSION=mes.SESSION,ID=mes.ID,STATE=false,TYPE==mes.TYPE,MESSAGE="未知错误"}
			local str6_1=packtable(rep6)
		    return str6_1.."\n"
		end
	elseif  mes.ID=="13" then 

		    cluster.call("cluster_game",".agent","setline",fd)
		    return nil
    else
      local rep6={SESSION=mes.SESSION,ID=mes.ID,STATE=false,MESSAGE="未知错误"}
	  local str6_1=packtable(rep6)
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

function packtable(req)
	local who="123456"
	local result=cjson.encode(req)
	local result1=crypt.aesencode(result,who,"")
	local result1_1=crypt.base64encode(result1)
	return result1_1
end

function CMD.release(fd,name)
	printI("release sessionID")
	sessionID[name]=nil
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
