local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.sign_in(fd,mes,name)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	if mes.TYPE=="look" then
	    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
		    printI("this is rank1,%s",mes.NAME)
		if bool1 and bool then 
			local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="look",LIST=list}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return returnfalse()
		end
	elseif mes.TYPE=="signin" then
	    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
		    printI("this is rank1,%s",mes.NAME)
		if bool1  then 
			local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="signin"}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return returnfalse()
		end
	elseif mes.TYPE=="award" then
	    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
		    printI("this is rank1,%s",mes.NAME)
		if bool1  then 
			local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="award",MONEY=50000}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return returnfalse()
		end
	else 
		returnfalse()
	end           
end

function returnfalse()
	        local req1={SESSION=mes.session,ID="10",STATE=false,MESSAGE="false"}
			local req1_1=sgoly_pack.encode(req1)
			return req1_1
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".sign")
end)
