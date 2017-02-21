local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}

function CMD.shoplist(fd,mes)
	if mes.TYPE=="look"   then
		local bool,req = sgoly_tool.getMoney(mes.NAME)
		if bool then
		   local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="look",PROPLIST=req}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16",req)
	    end
	elseif mes.TYPE=="buy" then
		local bool,req=sgoly_tool.getMoney(mes.NAME)
		local bool1,req1=sgoly_tool.getMoney(mes.NAME)
		if bool then
	       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROP=mes.PROP,PROPNUM=mes.PROPNUM,MONEY=req1}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16",req)
    	end
    elseif mes.TYPE=="use" then
    	local bool,req=sgoly_tool.getMoney(mes.NAME)
		if bool then
	       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROP=mes.PROP,PROPNUM=mes.PROPNUM}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16",req)
    	end
    else
    	return sgoly_pack.typereturn(mes,"16","参数错误")
    end
end

 


skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".shop")
end)