local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}



function CMD.ranklist(fd,mes)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	if mes.TYPE=="daySERIES" then
	    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
	        local bool,rqs=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req1.serialWinNum), "serialWinNum",os.date("%Y-%m-%d"))
		    printI("this is rank,%s",mes.NAME)
		if bool1 and bool then 
			rqs.SESSION=mes.session
			rqs.ID="7"
			rqs.STATE=true
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		end
	elseif mes.TYPE=="dayALLMONEY" then
	    	local bool2,req2 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
	        local bool2_1,rqs2_1=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req2.winMoney), "winMoney",os.date("%Y-%m-%d"))
		    printI("this is rank,%s",mes.NAME)
		if bool2 and bool2_1 then 
			rqs2_1.SESSION=mes.session
			rqs2_1.ID="7"
			rqs2_1.STATE=true
			local req2_2=sgoly_pack.encode(rqs2_1)
		    return req2_2
		end
	elseif mes.TYPE=="yesSERIES" then
	    	local bool3_1,req3_1 = sgoly_tool.getStatementsFromRedis(mes.NAME, c)
	     local bool3,rqs3=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req3_1.serialWinNum), "serialWinNum",c)
		    printI("this is rank,%s",mes.NAME)
		if bool3 and bool3_1 then 
			rqs3.SESSION=mes.session
			rqs3.ID="7"
			rqs3.STATE=true
			local req3_1=sgoly_pack.encode(rqs3)
		    return req3_1
		end
	elseif mes.TYPE=="yesALLMONEY" then
    	local bool4_1,req4_1 = sgoly_tool.getStatementsFromRedis(mes.NAME, c)
     local bool4,rqs4=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req4_1.winMoney), "winMoney",c)
	    printI("this is rank,%s",mes.NAME)
	if bool4 and bool4_1 then 
		rqs4.SESSION=mes.session
		rqs4.ID="7"
		rqs4.STATE=true
		local req4_1=sgoly_pack.encode(rqs4)
	    return req4_1
	end
    else 
        local req5={SESSION=mes.session,ID="7",STATE=false,MESSAGE="false"}--,--MESSAGE=rqs}
		local req5_1=sgoly_pack.encode(req5)
		return req5_1
   	end
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".rank")
end)