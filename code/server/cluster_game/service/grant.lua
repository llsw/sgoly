local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
local dat_ser=require "sgoly_dat_ser"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.getgrant(fd,mes,name)
	local bool3,req3=dat_ser.query_saf_money(name)
	if bool3 and req3>0 then
		return sgoly_pack.returnfalse(mes,"14","1")
	end
	local bool4,num=sgoly_tool.getCharityTimesFromRedis(name)
	if num<5 then 
		local bool1,req1 = dat_ser.get_award("charity","0")
		local bool,req=sgoly_tool.getMoney(name)
		local bool2,req2=sgoly_tool.saveMoneyToRedis(name,req+req1)
		if bool1 and bool and bool2 then 
			local boo4,req4=sgoly_tool.setCharityTimesToRedis(name,num+1)
			local rqs={SESSION=mes.SESSION,ID="14",STATE=true,MONEY=req+req1,NUM=5-num-1}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return sgoly_pack.returnfalse(mes,"14","3") 
	    end  
	else
		return sgoly_pack.returnfalse(mes,"14","2")
	end
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".grant")
end)
