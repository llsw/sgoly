local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
local dat_ser=require"sgoly_dat_ser"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.safebox(fd,mes,name)         --保险柜
	if mes.TYPE=="query" then
	       local bool,req1 = dat_ser.seted_safe_pwd(name)
		   printI("this is safe1,%s",mes.NAME)
		if bool then 
			local rqs={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="query",SET="yes"}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        local rqs={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="query",SET="no"}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		end
	elseif mes.TYPE=="setpd" then
		    local x = {}
		    x.PASSWD=mes.PASSWARD
		    local bo2=sgoly_pack.filter_password(x)
		    if bo2==false then
	        	local refal={SESSION=mes.SESSION,ID="9",STATE=false,TYPE="setpd",MESSAGE="密码含有非法字符"}
	            local refal1_2=sgoly_pack.encode(refal)
	            return refal1_2.."\n"
       		end
		    local PASSWD=md5.sumhexa(mes.PASSWARD)
	        local bool,rqs=dat_ser.set_safe_pwd(name,PASSWD)
		    printI("this is safe2,%s",mes.NAME)
		if  bool then 
			local rqs1={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="setpd"}
			local req2_1=sgoly_pack.encode(rqs1)
		    return req2_1
		else
			return sgoly_pack.typereturn(mes,"9",rqs) 
		end
	elseif mes.TYPE=="reset" then
			local x = {}
		    x.PASSWD=mes.PASSWARD
			local bo2=sgoly_pack.filter_password(x)
			    if bo2==false then
		        	local refal={SESSION=mes.SESSION,ID="9",STATE=false,TYPE="reset",MESSAGE="密码含有非法字符"}
		            local refal1_2=sgoly_pack.encode(refal)
		            return refal1_2.."\n"
	       		end
		    local CURPASSWD=md5.sumhexa(mes.CURPASSWARD )
		    local PASSWD = md5.sumhexa(mes.PASSWARD)
	        local bool,rqs=dat_ser.cha_saf_pwd(name,CURPASSWD,PASSWD)
		    printI("this is safe3,%s",mes.NAME)
			if  bool then 
				local rqs1={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="reset"}
				local req2_1=sgoly_pack.encode(rqs1)
			    return req2_1
		    else
		        return sgoly_pack.typereturn(mes,"9",rqs)
		    end
	elseif mes.TYPE=="login" then
		   local PASSWD = md5.sumhexa(mes.PASSWARD)
	       local bool,req1 =dat_ser.open_saf(name,PASSWD)
		   printI("this is safe4,%s",mes.NAME)
		   local bool1,req2=dat_ser.query_saf_money(name)
		if bool and bool1 then 
		   local rqs={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="login",MONEY=req2}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
		else 
		   return sgoly_pack.typereturn(mes,"9",req1..req2)
		end
	elseif mes.TYPE=="save" then
		   local bool2,nowmoney=sgoly_tool.getMoney(name)
		    if nowmoney-100000<tonumber(mes.MONEY) then
	       	  return sgoly_pack.typereturn(mes,"9","金额不足")
	       end
	       local boo,msg =dat_ser.save_money_2saf(name,tonumber(mes.MONEY))
	       if boo==false then
		      return sgoly_pack.typereturn(mes,"9","存钱失败")
		   end
	       local bool=sgoly_tool.saveMoneyToRedis(name,nowmoney-tonumber(mes.MONEY))
		   printI("this is safe5,%s",mes.NAME)
		if boo and bool and bool2 then 
		   local rqs={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="save",MONEY=nowmoney-tonumber(mes.MONEY)}
	       local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
		else 
		   return sgoly_pack.typereturn(mes,"9",msg)
		end
	elseif mes.TYPE=="load" then
		   local bool2,nowmoney=sgoly_tool.getMoney(name)
	       local boo,msg =dat_ser.get_saf_money(name,tonumber(mes.MONEY))
	       if boo==false then
		      return sgoly_pack.typereturn(mes,"9","提取失败")
		   end
	       local bool=sgoly_tool.saveMoneyToRedis(name,nowmoney+tonumber(mes.MONEY))
		   printI("this is safe5,%s",mes.NAME)
		if boo and bool and bool2 then 
		   local rqs={SESSION=mes.SESSION,ID="9",STATE=true,TYPE="load",MONEY=nowmoney+mes.MONEY}
	       local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
		else 
		   return sgoly_pack.typereturn(mes,"9",msg)
		end
	else 
		return sgoly_pack.typereturn(mes,"9","参数错误")
	end
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".safe")
end)