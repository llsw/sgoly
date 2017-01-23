local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}



function CMD.ranklist(fd,mes)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
        local bool,rqs=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req1.serialWinNum), "serialWinNum",c)
	    printI("this is rank",mes.NAME)
	if bool1 and bool then 
		rqs.SESSION=mes.session
		rqs.ID="7"
		rqs.STATE=true
		local req2_1=sgoly_pack.encode(rqs)
	    return req2_1
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