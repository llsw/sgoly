local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}
function CMD.shoplist(fd,mes)                   --商城
	if mes.TYPE=="look"   then                  --查看背包 
		local bool,req = sgoly_tool.getPackageFromRedis(mes.NAME)
	    local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="look",PROPLIST=req}
	    local req2_1=sgoly_pack.encode(rqs)
	    return req2_1
	elseif mes.TYPE=="buy" then					--购买道具
		if mes.PROPID=="4" then
			local bo,money=sgoly_tool.getMoney(mes.NAME)
			local bo1,re=sgoly_tool.saveMoneyToRedis(mes.NAME,money+mes.PROPNUM)
			if bo and bo1 then
			   local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROPID=mes.PROPID,PROPNUM=money+mes.PROPNUM}
			   local req2_1=sgoly_pack.encode(rqs)
			   return req2_1
			else
		    	return sgoly_pack.typereturn(mes,"16",money..re)
	    	end  
		else
		    sgoly_tool.getPackageFromRedis(mes.NAME)
			local bool1,req1=sgoly_tool.getPropFromRedis(mes.NAME, mes.PROPID)
			if not req1 then
				req1 = mes.PROPNUM
			else
				req1 = req1+mes.PROPNUM
	        end
			local bool,req=sgoly_tool.setPropToRedis(mes.NAME,mes.PROPID,req1)
			if bool then
		       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROPID=mes.PROPID,PROPNUM=req1}
			   local req2_1=sgoly_pack.encode(rqs)
			   return req2_1
		    else
		    	return sgoly_pack.typereturn(mes,"16",req)
	    	end
	    end
    elseif mes.TYPE=="use" then                    --使用道具
    	local bool,req = sgoly_tool.getPackageFromRedis(mes.NAME)
    	local bool1,req1=sgoly_tool.getPropFromRedis(mes.NAME, mes.PROPID)
    	if req1==0 then
    		return sgoly_pack.typereturn(mes,"16","道具数量为0")
    	end
		local bool,req=sgoly_tool.setPropToRedis(mes.NAME,mes.PROPID, req1-1)
		if bool then
	       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="use",PROPID=mes.PROPID,PROPNUM=req1-1}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16",req)
    	end
    else
    	return sgoly_pack.typereturn(mes,"16","参数错误")
    end
end

function  CMD.TEST()
	skynet.error(1234)  
	return  "789" 
end 


skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".shop")
end)